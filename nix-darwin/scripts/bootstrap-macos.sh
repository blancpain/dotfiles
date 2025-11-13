#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-macos.sh

Automates the "Fresh macOS Bootstrap" steps:
  1. Ensure Apple Command Line Tools (and Rosetta on Apple Silicon)
  2. Install Determinate Systems Nix installer
  3. Symlink this repo to ~/.config/nix-darwin (if needed)
  4. Install nix-darwin via sudo nix run ... --flake
  5. Apply the flake with darwin-rebuild switch --flake

Run this script from anywhere inside the repo.
EOF
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $(uname) != "Darwin" ]]; then
  echo "This bootstrap script is intended for macOS only." >&2
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
  echo "Run this script as a regular user (sudo will be requested when needed)." >&2
  exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)
TARGET_DIR="${HOME}/.config/nix-darwin"
NIX_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
DETERMINATE_INSTALLER_URL="https://install.determinate.systems/nix"

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
error() { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

resolve_path() {
  /usr/bin/python3 - "$1" <<'PY'
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
}

ensure_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    info "Command Line Tools already installed."
    return
  fi

  info "Command Line Tools not found; launching installer UI."
  xcode-select --install >/dev/null 2>&1 || true
  error "Command Line Tools installation must finish before continuing. Re-run this script afterward."
}

ensure_rosetta() {
  local arch
  arch=$(uname -m)
  if [[ $arch != "arm64" ]]; then
    info "Rosetta not required on $arch."
    return
  fi

  info "Ensuring Rosetta 2 is installed (sudo required)."
  if sudo /usr/sbin/softwareupdate --install-rosetta --agree-to-license >/dev/null 2>&1; then
    info "Rosetta 2 is installed."
  else
    error "Failed to install Rosetta 2."
  fi
}

source_nix_profile() {
  if [[ -f $NIX_PROFILE ]]; then
    # shellcheck disable=SC1091
    . "$NIX_PROFILE"
  fi
}

ensure_nix() {
  if command -v nix >/dev/null 2>&1; then
    info "Nix already installed."
    return
  fi

  info "Installing Nix via Determinate Systems installer."
  curl -fsSL "$DETERMINATE_INSTALLER_URL" | sh -s -- install --determinate

  source_nix_profile

  if command -v nix >/dev/null 2>&1; then
    info "Nix installation complete."
  else
    error "Nix command not yet available; open a new shell (to source ${NIX_PROFILE}) and re-run."
  fi
}

ensure_repo_link() {
  if [[ $REPO_ROOT == "$TARGET_DIR" ]]; then
    info "Repository already located at $TARGET_DIR."
    return
  fi

  mkdir -p "$(dirname "$TARGET_DIR")"

  if [[ -e $TARGET_DIR || -L $TARGET_DIR ]]; then
    local resolved_repo resolved_target
    resolved_repo=$(resolve_path "$REPO_ROOT")
    resolved_target=$(resolve_path "$TARGET_DIR")
    if [[ $resolved_repo == "$resolved_target" ]]; then
      info "Existing $TARGET_DIR already points at this repo."
      return
    fi
    error "$TARGET_DIR already exists and does not point to this repository; move it out of the way and re-run."
  fi

  ln -s "$REPO_ROOT" "$TARGET_DIR"
  info "Symlinked $TARGET_DIR -> $REPO_ROOT."
}

install_nix_darwin() {
  info "Installing/updating nix-darwin via flakes (sudo nix run ...)."
  sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "$TARGET_DIR"
}

apply_flake() {
  info "Applying darwin configuration via darwin-rebuild switch --flake."
  darwin-rebuild switch --flake "$TARGET_DIR"
}

main() {
  ensure_clt
  ensure_rosetta
  source_nix_profile
  ensure_nix
  ensure_repo_link
  install_nix_darwin
  apply_flake
  info "Bootstrap complete."
  info "Touch ID reminder: disable pam_watchid in darwin-configuration.nix until watchID helper is installed."
}

main "$@"
