#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-linux.sh

Automates the Linux/WSL bootstrap steps:
  1. Ensure Nix is installed (Determinate Systems installer)
  2. Apply the home-manager flake for the detected architecture (with --extra-experimental-features)
  3. Set fish as the default shell
  4. Install bob (Neovim version manager) via cargo

Run this script from anywhere inside the repo (clone at ~/dotfiles for best results).
EOF
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $(uname) != "Linux" ]]; then
  echo "This bootstrap script is intended for Linux/WSL only." >&2
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
  echo "Run this script as a regular user (sudo may be requested by the installer)." >&2
  exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)
EXPECTED_REPO="${HOME}/dotfiles/nix-darwin"
NIX_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
DETERMINATE_INSTALLER_URL="https://install.determinate.systems/nix"

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
error() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

source_nix_profile() {
  if [[ -f $NIX_PROFILE ]]; then
    # shellcheck disable=SC1091
    . "$NIX_PROFILE"
  fi
}

ensure_repo_location() {
  if [[ $REPO_ROOT != "$EXPECTED_REPO" ]]; then
    warn "Repo path is $REPO_ROOT (expected $EXPECTED_REPO); symlinks assume ~/dotfiles."
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

detect_home_manager_attr() {
  local arch
  arch=$(uname -m)
  case "$arch" in
    x86_64) echo "$USER@linux" ;;
    aarch64) echo "$USER@linux-aarch64" ;;
    *)
      error "Unsupported architecture: $arch. Add a matching homeConfigurations attr to flake.nix."
      ;;
  esac
}

apply_home_manager() {
  local hm_attr="$1"
  info "Applying home-manager flake attribute: $hm_attr"
  nix run --extra-experimental-features "nix-command flakes" home-manager/master -- switch -b backup --impure --flake "${REPO_ROOT}#${hm_attr}"
}

setup_fish_shell() {
  local fish_path="${HOME}/.nix-profile/bin/fish"

  if [[ ! -x "$fish_path" ]]; then
    warn "Fish shell not found at $fish_path, skipping shell setup."
    return
  fi

  info "Setting up fish as default shell..."

  # Check if fish is already in /etc/shells
  if ! grep -qx "$fish_path" /etc/shells 2>/dev/null; then
    info "Adding fish to /etc/shells (requires sudo)..."
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  else
    info "Fish already in /etc/shells."
  fi

  # Check if fish is already the default shell
  if [[ $(basename "$SHELL") != "fish" ]]; then
    info "Setting fish as default shell..."
    chsh -s "$fish_path"
    info "Default shell changed to fish. You may need to log out and back in for this to take effect."
  else
    info "Fish is already the default shell."
  fi
}

install_bob() {
  if command -v bob >/dev/null 2>&1; then
    info "Bob (Neovim version manager) already installed."
    return
  fi

  if ! command -v cargo >/dev/null 2>&1; then
    warn "Cargo not found. Skipping bob installation."
    info "Install Rust first: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    return
  fi

  info "Installing bob (Neovim version manager) via cargo..."
  cargo install --git https://github.com/MordechaiHadad/bob.git

  if command -v bob >/dev/null 2>&1; then
    info "Bob installed successfully."
  else
    warn "Bob installation completed but not found in PATH. You may need to add ~/.cargo/bin to your PATH."
  fi
}

main() {
  ensure_repo_location
  source_nix_profile
  ensure_nix
  local hm_attr
  hm_attr=$(detect_home_manager_attr)
  apply_home_manager "$hm_attr"
  setup_fish_shell
  install_bob
  info "Bootstrap complete."
}

main "$@"
