#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-macos-non-nix.sh

Automates a fresh macOS setup WITHOUT Nix:
  1. Ensure Apple Command Line Tools
  2. Install Homebrew (Apple Silicon default path)
  3. Install all packages via Brewfile (brew bundle)
  4. Install Claude Code
  5. Set up Node.js (fnm + LTS) and global npm packages
  6. Set up Rust toolchain (stable)
  7. Install global Go tools
  8. Create dotfile symlinks
  9. Set fish as default shell
  10. Apply macOS system defaults

  NOTE: Touch ID sudo (pam-reattach) and yabai sudoers are commented out —
  they cannot be used on corporate/BYOD-enrolled machines. Uncomment if
  running on a personal machine.

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
BREWFILE="${REPO_ROOT}/brew/Brewfile"

info()  { printf '[INFO] %s\n' "$*"; }
warn()  { printf '[WARN] %s\n' "$*" >&2; }
error() { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

# Create a symlink, backing up any existing non-symlink target.
link_file() {
  local src="$1" dest="$2"

  if [[ -L "$dest" ]]; then
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    warn "Backing up existing $dest → ${dest}.backup"
    mv "$dest" "${dest}.backup"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  info "Linked $dest → $src"
}

# ---------- Step 1: Command Line Tools ----------

ensure_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    info "Command Line Tools already installed."
    return
  fi

  info "Command Line Tools not found; launching installer UI."
  xcode-select --install >/dev/null 2>&1 || true
  error "Command Line Tools installation must finish before continuing. Re-run this script afterward."
}

# ---------- Step 2: Homebrew ----------

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    info "Homebrew already installed."
    return
  fi

  info "Installing Homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

# ---------- Step 3: Packages ----------

install_packages() {
  if [[ ! -f "$BREWFILE" ]]; then
    error "Brewfile not found at $BREWFILE"
  fi

  info "Installing packages from Brewfile (this may take a while)."
  brew bundle --file="$BREWFILE"
}

# ---------- Step 4: Claude Code ----------

install_claude_code() {
  if command -v claude >/dev/null 2>&1; then
    info "Claude Code already installed."
    return
  fi

  info "Installing Claude Code."
  curl -fsSL https://claude.ai/install.sh | bash
}

# ---------- Step 5: Node.js + global npm packages ----------

setup_node() {
  if ! command -v fnm >/dev/null 2>&1; then
    warn "fnm not found; skipping Node.js setup."
    return
  fi

  # fnm needs eval in the current shell
  eval "$(fnm env)"

  if ! fnm list | grep -q lts; then
    info "Installing Node.js LTS via fnm."
    fnm install --lts
  fi

  fnm default lts-latest
  eval "$(fnm env)"

  info "Node.js $(node --version) active."

  # Global npm packages
  local npm_packages=(
    "@mermaid-js/mermaid-cli"
    "@google/gemini-cli"
    "@openai/codex"
    "tsx"
    "typescript"
    "tree-sitter-cli"
  )

  info "Installing global npm packages."
  for pkg in "${npm_packages[@]}"; do
    if npm list -g "$pkg" >/dev/null 2>&1; then
      info "$pkg already installed."
    else
      info "Installing $pkg globally."
      npm install -g "$pkg"
    fi
  done
}

# ---------- Step 6: Rust toolchain + cargo packages ----------

setup_rust() {
  if ! command -v rustup >/dev/null 2>&1; then
    warn "rustup not found; skipping Rust setup."
    return
  fi

  if rustup show | grep -q stable; then
    info "Rust stable toolchain already installed."
  else
    info "Installing Rust stable toolchain."
    rustup install stable
    rustup default stable
  fi
}

# ---------- Step 7: Go tools ----------

setup_go() {
  if ! command -v go >/dev/null 2>&1; then
    warn "go not found; skipping Go tools setup."
    return
  fi

  local go_packages=(
    "github.com/bootdotdev/bootdev@latest"
  )

  for pkg in "${go_packages[@]}"; do
    local bin_name
    bin_name=$(basename "${pkg%%@*}")
    if command -v "$bin_name" >/dev/null 2>&1; then
      info "$bin_name already installed."
    else
      info "Installing $bin_name via go install."
      go install "$pkg"
    fi
  done
}

# ---------- Step 8: Symlinks ----------

create_symlinks() {
  info "Creating dotfile symlinks."

  # ~/.config targets (common + darwin)
  local config_pkgs=(starship nvim tmux lazygit fish yazi karabiner skhd yabai ghostty)
  for pkg in "${config_pkgs[@]}"; do
    link_file "$REPO_ROOT/$pkg" "$HOME/.config/$pkg"
  done

  # Home-directory targets
  link_file "$REPO_ROOT/hammerspoon" "$HOME/.hammerspoon"
  link_file "$REPO_ROOT/Cursor/.cursor" "$HOME/.cursor"

  # Library/Application Support targets
  link_file "$REPO_ROOT/Code/User"     "$HOME/Library/Application Support/Code/User"
  link_file "$REPO_ROOT/Cursor/User"   "$HOME/Library/Application Support/Cursor/User"
  link_file "$REPO_ROOT/Windsurf/User" "$HOME/Library/Application Support/Windsurf/User"
}

# ---------- DISABLED: Touch ID sudo + pam-reattach ----------
# NOTE: Cannot be used on corporate/BYOD-enrolled machines.
# Uncomment this function and add configure_sudo to main() for personal machines.

# configure_sudo() {
#   local sudo_local="/etc/pam.d/sudo_local"
#   local pam_reattach_lib="/opt/homebrew/lib/pam/pam_reattach.so"
#
#   if [[ -f "$sudo_local" ]] && grep -q pam_tid "$sudo_local"; then
#     info "Touch ID sudo already configured."
#     return
#   fi
#
#   if [[ ! -f "$pam_reattach_lib" ]]; then
#     warn "pam-reattach not found at $pam_reattach_lib; skipping sudo configuration."
#     return
#   fi
#
#   info "Configuring Touch ID for sudo (with pam-reattach for tmux sessions)."
#   sudo tee "$sudo_local" >/dev/null <<EOF
# # Touch ID for sudo (pam-reattach enables it inside tmux)
# auth       optional       $pam_reattach_lib ignore_ssh
# auth       sufficient     pam_tid.so
# EOF
#   info "Touch ID sudo configured."
# }

# ---------- DISABLED: Yabai sudoers ----------
# NOTE: Cannot be used on corporate/BYOD-enrolled machines.
# Uncomment this function and add configure_yabai_sudoers to main() for personal machines.

# configure_yabai_sudoers() {
#   local yabai_path
#   yabai_path="$(brew --prefix)/bin/yabai"
#   local sudoers_file="/etc/sudoers.d/yabai"
#
#   if [[ ! -x "$yabai_path" ]]; then
#     warn "yabai not found at $yabai_path; skipping sudoers configuration."
#     return
#   fi
#
#   local hash
#   hash=$(shasum -a 256 "$yabai_path" | cut -d ' ' -f1)
#
#   if [[ -f "$sudoers_file" ]] && grep -q "$hash" "$sudoers_file"; then
#     info "Yabai sudoers already up to date."
#     return
#   fi
#
#   info "Configuring passwordless sudo for yabai --load-sa (requires SIP partially disabled)."
#   sudo tee "$sudoers_file" >/dev/null <<EOF
# $(whoami) ALL=(root) NOPASSWD: sha256:$hash $yabai_path --load-sa
# EOF
#   info "Yabai sudoers configured."
# }

# ---------- Step 9: Default shell ----------

set_default_shell() {
  local fish_path
  fish_path="$(brew --prefix)/bin/fish"

  if [[ ! -x "$fish_path" ]]; then
    warn "Fish not found at $fish_path; skipping shell change."
    return
  fi

  if [[ "$SHELL" == "$fish_path" ]]; then
    info "Fish is already the default shell."
    return
  fi

  # Ensure fish is in /etc/shells
  if ! grep -qF "$fish_path" /etc/shells; then
    info "Adding $fish_path to /etc/shells."
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  info "Setting fish as the default shell."
  chsh -s "$fish_path"
  info "Default shell changed to fish. Open a new terminal to use it."
}

# ---------- Step 10: macOS defaults ----------

configure_macos_defaults() {
  info "Applying macOS defaults."

  # --- Dock ---
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock largesize -int 128
  defaults write com.apple.dock magnification -bool true
  defaults write com.apple.dock mru-spaces -bool false
  defaults write com.apple.dock orientation -string bottom
  defaults write com.apple.dock show-recents -bool false
  # Hot corners (1 = disabled, 5 = start screen saver)
  defaults write com.apple.dock wvous-bl-corner -int 1
  defaults write com.apple.dock wvous-br-corner -int 5
  defaults write com.apple.dock wvous-tl-corner -int 1
  defaults write com.apple.dock wvous-tr-corner -int 1

  # --- Finder ---
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool false

  # --- Screenshots ---
  mkdir -p "$HOME/Documents/Screenshots"
  defaults write com.apple.screencapture location -string "$HOME/Documents/Screenshots"

  # --- Window Manager (Stage Manager off, tiling off — using yabai) ---
  defaults write com.apple.WindowManager GloballyEnabled -bool false
  defaults write com.apple.WindowManager AppWindowGroupingBehavior -bool true
  defaults write com.apple.WindowManager AutoHide -bool false
  defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
  defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
  defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
  defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
  defaults write com.apple.WindowManager HideDesktop -bool true
  defaults write com.apple.WindowManager StageManagerHideWidgets -bool false
  defaults write com.apple.WindowManager StandardHideWidgets -bool true

  # --- Trackpad ---
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

  # --- Keyboard ---
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 14
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 1

  # --- Appearance ---
  defaults write NSGlobalDomain AppleInterfaceStyle -string Dark
  defaults write NSGlobalDomain AppleFontSmoothing -int 0

  # --- Mouse & scrolling ---
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
  defaults write NSGlobalDomain com.apple.mouse.scaling -float 1.5
  defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 1

  # --- Input source indicator ---
  defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

  # Restart affected services
  killall Dock || true
  killall Finder || true
  killall SystemUIServer || true

  info "macOS defaults applied."
}

# ---------- Main ----------

main() {
  ensure_clt
  ensure_homebrew
  install_packages
  install_claude_code
  setup_node
  setup_rust
  setup_go
  create_symlinks
  # configure_sudo            # disabled: not available on corporate/BYOD machines
  # configure_yabai_sudoers   # disabled: not available on corporate/BYOD machines
  set_default_shell
  configure_macos_defaults
  info "Bootstrap complete. Some changes may require a logout or restart to take full effect."
}

main "$@"
