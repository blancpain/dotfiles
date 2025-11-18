#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-macos.sh

Automates the "Fresh macOS Bootstrap" steps:
  1. Ensure Apple Command Line Tools (and Rosetta on Apple Silicon)
  2. Install Determinate Systems Nix installer
  3. Install Homebrew (Apple Silicon default path)
  4. Install nix-darwin via sudo nix run ... --flake (using this repo)
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
NIX_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
DETERMINATE_INSTALLER_URL="https://install.determinate.systems/nix"

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
error() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
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

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    info "Homebrew already installed."
    return
  fi

  info "Installing Homebrew (needed for casks/MAS)."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon default path
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_nix_darwin() {
  info "Installing/updating nix-darwin via flakes (sudo nix run ...)."
  sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "$REPO_ROOT"
}

apply_flake() {
  info "Applying darwin configuration via darwin-rebuild switch --flake."
  darwin-rebuild switch --flake "$REPO_ROOT"
}

set_default_shell() {
  local fish_path="/run/current-system/sw/bin/fish"

  if [[ ! -x $fish_path ]]; then
    warn "Fish not found at $fish_path; skipping shell change."
    return
  fi

  if [[ $SHELL == "$fish_path" ]]; then
    info "Fish is already the default shell."
    return
  fi

  info "Setting fish as the default shell."
  chsh -s "$fish_path"
  info "Default shell changed to fish. Open a new terminal to use it."
}

main() {
  ensure_clt
  ensure_rosetta
  source_nix_profile
  ensure_nix
  ensure_homebrew
  install_nix_darwin
  apply_flake
  set_default_shell
  info "Bootstrap complete."
}

main "$@"
