#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-macos-non-nix-personal.sh

Automates a fresh macOS setup WITHOUT Nix (personal machine):
  1. Ensure Apple Command Line Tools
  2. Install Homebrew (Apple Silicon default path)
  3. Install all packages via Brewfile.personal (brew bundle)
  4. Install AWS CLI v2 (via .pkg installer)
  5. Install Claude Code
  6. Set up Node.js (fnm + LTS) and global npm packages
  7. Set up Rust toolchain (stable)
  8. Install global Go tools
  9. Configure global git identity (user.name / user.email)
  10. Set up SSH keys (personal + work GitHub) + write ~/.ssh/config
  11. Set up Tailscale + Mac Mini SSH access
  12. Optionally restore Snowflake SSH key from 1Password
  13. Create dotfile symlinks
  14. Install TPM (Tmux Plugin Manager)
  15. Bootstrap Fisher plugins for fish shell
  16. Configure Touch ID sudo (pam-reattach)
  17. Configure passwordless sudo for yabai --load-sa
  18. Set fish as default shell
  19. Apply macOS system defaults

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
BREWFILE="${REPO_ROOT}/brew/Brewfile.personal"

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
error() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

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

  info "Installing packages from Brewfile.personal (this may take a while)."
  brew bundle --file="$BREWFILE" || warn "brew bundle finished with errors — check the output above."
}

# ---------- Step 4: AWS CLI ----------

install_aws_cli() {
  if command -v aws >/dev/null 2>&1; then
    info "AWS CLI already installed ($(aws --version 2>&1 | head -1))."
    return
  fi

  info "Installing AWS CLI v2."
  local pkg_path
  pkg_path=$(mktemp -d)/AWSCLIV2.pkg
  if ! curl -fsSL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "$pkg_path"; then
    warn "Failed to download AWS CLI installer — skipping."
    return
  fi
  if ! sudo installer -pkg "$pkg_path" -target /; then
    warn "AWS CLI installer failed — check sudo access."
  else
    info "AWS CLI installed: $(aws --version 2>&1 | head -1)."
  fi
  rm -f "$pkg_path"
}

# ---------- Step 5: Claude Code ----------

install_claude_code() {
  if command -v claude >/dev/null 2>&1; then
    info "Claude Code already installed."
    return
  fi

  info "Installing Claude Code."
  curl -fsSL https://claude.ai/install.sh | bash ||
    warn "Claude Code install failed (proxy or firewall may be blocking the download)."
}

# ---------- Step 6: Node.js + global npm packages ----------

setup_node() {
  if ! command -v fnm >/dev/null 2>&1; then
    warn "fnm not found; skipping Node.js setup."
    return
  fi

  # fnm needs eval in the current shell
  eval "$(fnm env)"

  if ! fnm list | grep -q lts; then
    info "Installing Node.js LTS via fnm."
    if ! fnm install --lts; then
      warn "fnm install failed; skipping Node.js setup."
      return
    fi
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
      npm install -g "$pkg" || warn "Failed to install $pkg."
    fi
  done
}

# ---------- Step 7: Rust toolchain + cargo packages ----------

setup_rust() {
  # Install rustup via the official installer (not Homebrew) so that
  # ~/.cargo/bin, proxy binaries, and ~/.cargo/env are all set up correctly.
  if ! command -v rustup >/dev/null 2>&1; then
    info "Installing Rust toolchain via rustup."
    if ! curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path; then
      warn "rustup install failed; skipping Rust setup."
      return
    fi
  fi

  # Source cargo env for the rest of this script
  # shellcheck source=/dev/null
  [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

  if ! rustup show | grep -q stable; then
    info "Installing Rust stable toolchain."
    if ! rustup install stable; then
      warn "rustup install failed; skipping Rust setup."
      return
    fi
    rustup default stable
  fi

  if command -v cargo >/dev/null 2>&1; then
    info "cargo $(cargo --version | awk '{print $2}') available."
  else
    warn "cargo not found — check your rustup installation."
  fi
}

# ---------- Step 8: Go tools ----------

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
      go install "$pkg" || warn "Failed to install $bin_name."
    fi
  done
}

# ---------- Step 9: Git global config ----------

setup_git_config() {
  if ! command -v git >/dev/null 2>&1; then
    warn "git not found; skipping git config setup."
    return
  fi

  local name="Yasen Dimitrov"
  local email="y_dimitrov@ymail.com"

  local current_name current_email
  current_name=$(git config --global user.name 2>/dev/null || true)
  current_email=$(git config --global user.email 2>/dev/null || true)

  if [[ -n "$current_name" && -n "$current_email" ]]; then
    info "Git global identity already configured: $current_name <$current_email>"
    return
  fi

  [[ -z "$current_name" ]] && git config --global user.name "$name"
  [[ -z "$current_email" ]] && git config --global user.email "$email"
  info "Git identity set: $(git config --global user.name) <$(git config --global user.email)>"
}

# ---------- Step 10: SSH keys ----------

setup_ssh_keys() {
  local personal_key="$HOME/.ssh/id_ed25519"
  local work_key="$HOME/.ssh/id_ed25519_github_work"
  local ssh_config="$HOME/.ssh/config"

  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  if [[ -d "/Applications/1Password.app" ]]; then
    if ! command -v op >/dev/null 2>&1; then
      warn "1Password CLI (op) not found; skipping key extraction."
    else
      if ! op whoami >/dev/null 2>&1; then
        info "Signing in to 1Password CLI."
        if ! op signin; then
          warn "1Password sign-in failed; skipping key extraction."
        fi
      fi
      if op whoami >/dev/null 2>&1; then
        if [[ ! -f "$personal_key.pub" ]]; then
          info "Extracting GitHub Personal public key from 1Password."
          op item get "GitHub Personal" --fields "public key" >"$personal_key.pub" ||
            warn "Failed to extract 'GitHub Personal' public key from 1Password."
        else
          info "GitHub Personal public key already exists; skipping."
        fi
        if [[ ! -f "$work_key.pub" ]]; then
          info "Extracting GitHub Work public key from 1Password."
          op item get "GitHub Work" --fields "public key" >"$work_key.pub" ||
            warn "Failed to extract 'GitHub Work' public key from 1Password."
        else
          info "GitHub Work public key already exists; skipping."
        fi
      fi
    fi
  else
    # Personal key
    if [[ ! -f "$personal_key" ]]; then
      info "No personal SSH key found; generating $personal_key."
      local personal_email
      read -r -p "[SSH] Enter your personal GitHub email: " personal_email
      ssh-keygen -t ed25519 -C "$personal_email" -f "$personal_key"
      info "Personal key generated. Add to GitHub (Settings → SSH keys):"
      cat "${personal_key}.pub"
      read -r -p "Press Enter once you've added the personal key to GitHub..."
    else
      info "Personal SSH key already exists at $personal_key."
    fi

    # Work key
    if [[ ! -f "$work_key" ]]; then
      info "No work SSH key found; generating $work_key."
      local work_email
      read -r -p "[SSH] Enter your work GitHub email: " work_email
      ssh-keygen -t ed25519 -C "$work_email" -f "$work_key"
      info "Work key generated. Add to your work GitHub account (Settings → SSH keys):"
      cat "${work_key}.pub"
      read -r -p "Press Enter once you've added the work key to GitHub..."
    else
      info "Work SSH key already exists at $work_key."
    fi

    # Load keys into agent
    ssh-add "$personal_key" 2>/dev/null || true
    ssh-add "$work_key" 2>/dev/null || true
  fi

  # Ensure ~/.ssh/config has the two GitHub host entries
  if grep -qF "Host github-work" "$ssh_config" 2>/dev/null; then
    info "GitHub SSH host entries already in $ssh_config."
  else
    info "Adding GitHub SSH host entries to $ssh_config."
    local tmp
    tmp=$(mktemp)
    cat >"$tmp" <<'SSHCONF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519

Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github_work

SSHCONF
    # Prepend to any pre-existing config, preserving manual additions
    [[ -f "$ssh_config" ]] && cat "$ssh_config" >>"$tmp"
    mv "$tmp" "$ssh_config"
    chmod 600 "$ssh_config"
  fi

  # Test both connections
  # ssh -T always exits non-zero (GitHub denies shell access), so capture output
  # separately to avoid the pipe failing under set -o pipefail.
  info "Testing GitHub SSH connections..."
  local out
  out=$(ssh -T git@github.com -o StrictHostKeyChecking=accept-new 2>&1) || true
  if [[ "$out" == *"successfully authenticated"* ]]; then
    info "Personal GitHub SSH: OK"
  else
    warn "Personal GitHub SSH test failed — make sure the key is added to your GitHub account."
  fi
  out=$(ssh -T git@github-work -o StrictHostKeyChecking=accept-new 2>&1) || true
  if [[ "$out" == *"successfully authenticated"* ]]; then
    info "Work GitHub SSH: OK"
    info "If your org uses SAML SSO, you must also authorize the key:"
    info "  GitHub → Settings → SSH and GPG keys → Configure SSO → Authorize <org>"
  else
    warn "Work GitHub SSH test failed — make sure the key is added to your work GitHub account."
  fi
}

# ---------- Step 11: Tailscale + Mac Mini SSH ----------

setup_tailscale() {
  if ! command -v tailscale >/dev/null 2>&1; then
    warn "tailscale not found; skipping."
    return
  fi

  # Start daemon if not running
  if ! tailscale status >/dev/null 2>&1; then
    info "Starting Tailscale daemon."
    sudo brew services start tailscale
  fi

  # Authenticate if not logged in
  if ! tailscale status >/dev/null 2>&1; then
    info "Authenticating Tailscale (this will open a browser)."
    tailscale up
  else
    info "Tailscale already authenticated."
  fi

  tailscale status

  # Add Mac Mini to SSH config
  local ssh_config="$HOME/.ssh/config"
  local macmini_key="$HOME/.ssh/macmini.pub"

  if grep -qF "Host macmini" "$ssh_config" 2>/dev/null; then
    info "Mac Mini SSH host entry already in $ssh_config."
  else
    local answer
    read -r -p "[Tailscale] Add Mac Mini SSH entry to ~/.ssh/config? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then

      # Extract Mac Mini public key from 1Password for IdentityFile
      if [[ ! -f "$macmini_key" ]]; then
        if command -v op >/dev/null 2>&1 && op whoami >/dev/null 2>&1; then
          info "Extracting Mac Mini public key from 1Password."
          op item get "Mac Mini" --fields "public key" >"$macmini_key" ||
            warn "Failed to extract 'Mac Mini' public key from 1Password."
        else
          warn "1Password CLI not available; you'll need to manually create ~/.ssh/macmini.pub with the public key."
        fi
      fi

      info "Adding Mac Mini entry to $ssh_config."
      cat >>"$ssh_config" <<'SSHCONF'

Host macmini
  HostName 100.82.197.87
  User blancpain
  IdentityFile ~/.ssh/macmini.pub
  IdentitiesOnly yes
  ServerAliveInterval 60
  ServerAliveCountMax 3
  ForwardAgent yes
SSHCONF
      chmod 600 "$ssh_config"

      # Copy public key to Mac Mini authorized_keys for key-based auth
      if [[ -f "$macmini_key" ]]; then
        info "Copying public key to Mac Mini (you'll be prompted for the Mac Mini password once)."
        ssh -o PreferredAuthentications=password macmini \
          "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys" <"$macmini_key" ||
          warn "Failed to copy key — you can add it manually to the Mac Mini's ~/.ssh/authorized_keys."
      fi

      info "Mac Mini SSH configured. Use: ssh macmini"
    fi
  fi
}

# ---------- Step 12: Snowflake SSH key ----------
#
# Pulls the private key from 1Password and derives the public key locally.
# Gated behind a prompt — skip on machines that don't need Snowflake access.

setup_snowflake_key() {
  local snowflake_dir="$HOME/.ssh/snowflake"
  local private_key="$snowflake_dir/rsa_key.p8"
  local public_key="$snowflake_dir/rsa_key.pub"

  if [[ -f "$private_key" && -f "$public_key" ]]; then
    info "Snowflake SSH key already present; skipping."
    return
  fi

  local answer
  read -r -p "[Snowflake] Set up Snowflake SSH key on this machine? [y/N] " answer
  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    info "Skipping Snowflake SSH key setup."
    return
  fi

  if ! command -v op >/dev/null 2>&1; then
    warn "1Password CLI (op) not found; skipping Snowflake key setup."
    return
  fi

  # Ensure we have an active 1Password session
  if ! op whoami >/dev/null 2>&1; then
    info "Signing in to 1Password CLI."
    if ! op signin; then
      warn "1Password sign-in failed; skipping Snowflake key setup."
      return
    fi
  fi

  mkdir -p "$snowflake_dir"

  info "Pulling Snowflake private key from 1Password."
  if ! op document get "Snowflake SSH Key (SME)" --output "$private_key" 2>/dev/null; then
    warn "Failed to retrieve 'Snowflake SSH Key (SME)' from 1Password — check the item name and vault access."
    return
  fi
  chmod 600 "$private_key"

  info "Deriving Snowflake public key."
  if ! openssl pkey -in "$private_key" -pubout -out "$public_key" 2>/dev/null; then
    warn "Failed to derive public key from $private_key."
    return
  fi
  chmod 644 "$public_key"

  info "Snowflake SSH key ready at $snowflake_dir."
}

# ---------- Step 12: Symlinks ----------

create_symlinks() {
  info "Creating dotfile symlinks."

  # ~/.config targets (common + darwin)
  local config_pkgs=(starship nvim tmux lazygit fish yazi karabiner skhd yabai ghostty)
  for pkg in "${config_pkgs[@]}"; do
    link_file "$REPO_ROOT/$pkg" "$HOME/.config/$pkg"
  done

  # Home-directory targets
  link_file "$REPO_ROOT/hammerspoon" "$HOME/.hammerspoon"

  # Library/Application Support targets
  link_file "$REPO_ROOT/Code/User" "$HOME/Library/Application Support/Code/User"
  link_file "$REPO_ROOT/Cursor/User" "$HOME/Library/Application Support/Cursor/User"
  link_file "$REPO_ROOT/Windsurf/User" "$HOME/Library/Application Support/Windsurf/User"
}

# ---------- Step 13: TPM (Tmux Plugin Manager) ----------

setup_tmux() {
  local tpm_dir="$REPO_ROOT/tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    info "TPM (Tmux Plugin Manager) already installed."
    return
  fi

  info "Installing TPM (Tmux Plugin Manager)."
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir" ||
    warn "Failed to clone TPM — check network connectivity."
}

# ---------- Step 14: Fisher plugins ----------

setup_fisher() {
  local fish_path
  fish_path="$(brew --prefix)/bin/fish"

  if [[ ! -x "$fish_path" ]]; then
    warn "Fish not found; skipping Fisher plugin setup."
    return
  fi

  local fish_plugins="$HOME/.config/fish/fish_plugins"
  if [[ ! -f "$fish_plugins" ]]; then
    warn "fish_plugins file not found at $fish_plugins; skipping Fisher setup."
    return
  fi

  # Check if Fisher and all plugins are already installed by comparing
  # `fisher list` output against the fish_plugins manifest.
  local installed
  installed=$("$fish_path" -c 'fisher list 2>/dev/null' | sort) || true
  local wanted
  wanted=$(sort <"$fish_plugins")

  if [[ -n "$installed" && "$installed" == "$wanted" ]]; then
    info "Fisher plugins already installed."
    return
  fi

  info "Bootstrapping Fisher plugins."
  # On a fresh machine fisher.fish doesn't exist yet (plugin files aren't tracked
  # in git). Curl the bootstrap script, source it in the running fish session, then
  # run `fisher update` which reads fish_plugins and installs everything.
  "$fish_path" -c '
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher update
  ' || warn "Fisher plugin bootstrap failed — you can retry manually with: fish -c \"curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update\""
}

# ---------- Step 15: Touch ID sudo + pam-reattach ----------

configure_sudo() {
  local sudo_local="/etc/pam.d/sudo_local"
  local pam_reattach_lib="/opt/homebrew/lib/pam/pam_reattach.so"

  if [[ -f "$sudo_local" ]] && grep -q pam_tid "$sudo_local"; then
    info "Touch ID sudo already configured."
    return
  fi

  if [[ ! -f "$pam_reattach_lib" ]]; then
    warn "pam-reattach not found at $pam_reattach_lib; skipping sudo configuration."
    return
  fi

  info "Configuring Touch ID for sudo (with pam-reattach for tmux sessions)."
  sudo tee "$sudo_local" >/dev/null <<EOF
# Touch ID for sudo (pam-reattach enables it inside tmux)
auth       optional       $pam_reattach_lib ignore_ssh
auth       sufficient     pam_tid.so
EOF
  info "Touch ID sudo configured."
}

# ---------- Step 16: Yabai sudoers ----------

configure_yabai_sudoers() {
  local yabai_path
  yabai_path="$(brew --prefix)/bin/yabai"
  local sudoers_file="/etc/sudoers.d/yabai"

  if [[ ! -x "$yabai_path" ]]; then
    warn "yabai not found at $yabai_path; skipping sudoers configuration."
    return
  fi

  local hash
  hash=$(shasum -a 256 "$yabai_path" | cut -d ' ' -f1)

  if [[ -f "$sudoers_file" ]] && grep -q "$hash" "$sudoers_file"; then
    info "Yabai sudoers already up to date."
    return
  fi

  info "Configuring passwordless sudo for yabai --load-sa (requires SIP partially disabled)."
  sudo tee "$sudoers_file" >/dev/null <<EOF
$(whoami) ALL=(root) NOPASSWD: sha256:$hash $yabai_path --load-sa
EOF
  info "Yabai sudoers configured."
}

# ---------- Step 17: Default shell ----------

set_default_shell() {
  local fish_path
  fish_path="$(brew --prefix)/bin/fish"

  if [[ ! -x "$fish_path" ]]; then
    warn "Fish not found at $fish_path; skipping shell change."
    return
  fi

  # $SHELL can be stale; query the directory service for the actual login shell.
  local current_shell
  current_shell=$(dscl . -read /Users/"$(whoami)" UserShell 2>/dev/null | awk '{print $2}')
  if [[ "$current_shell" == "$fish_path" ]]; then
    info "Fish is already the default shell."
    return
  fi

  # Ensure fish is in /etc/shells
  if ! grep -qF "$fish_path" /etc/shells; then
    info "Adding $fish_path to /etc/shells."
    if ! echo "$fish_path" | sudo tee -a /etc/shells >/dev/null; then
      warn "Could not add $fish_path to /etc/shells. Skipping shell change."
      return
    fi
  fi

  info "Setting fish as the default shell."
  if chsh -s "$fish_path"; then
    info "Default shell changed to fish. Open a new terminal to use it."
  else
    warn "chsh failed — you can launch fish from your terminal profile settings instead."
  fi
}

# ---------- Step 18: macOS defaults ----------

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
  defaults write com.apple.finder AppleShowAllFiles -bool true
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
  # Secondary click: bottom-right corner
  defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool false
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool false

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

  # Verify settings weren't overridden by MDM configuration profiles
  info "Verifying macOS defaults..."
  local mdm_overrides=0

  # Check managed preferences — MDM profiles live in /Library/Managed Preferences/
  # and override user-domain plists at runtime. Reading back from the user domain
  # alone would always agree with what we wrote, giving false "all clear" results.
  verify_default() {
    local domain="$1" key="$2" expected="$3"
    local managed_domain="$domain"

    # NSGlobalDomain and kCFPreferencesAnyApplication map to .GlobalPreferences on disk
    case "$domain" in
    NSGlobalDomain | kCFPreferencesAnyApplication) managed_domain=".GlobalPreferences" ;;
    esac

    local managed_plist="/Library/Managed Preferences/${managed_domain}"
    local managed_val
    if managed_val=$(defaults read "$managed_plist" "$key" 2>/dev/null); then
      if [[ "$managed_val" != "$expected" ]]; then
        warn "\"$domain $key\" is managed by MDM (enforced: $managed_val, wanted: $expected)."
        mdm_overrides=$((mdm_overrides + 1))
      fi
      return 0
    fi

    # Also check per-user managed preferences
    local user_managed_plist="/Library/Managed Preferences/$(whoami)/${managed_domain}"
    if managed_val=$(defaults read "$user_managed_plist" "$key" 2>/dev/null); then
      if [[ "$managed_val" != "$expected" ]]; then
        warn "\"$domain $key\" is managed by MDM (enforced: $managed_val, wanted: $expected)."
        mdm_overrides=$((mdm_overrides + 1))
      fi
      return 0
    fi

    # No MDM profile for this key — verify our write took effect
    local actual
    actual=$(defaults read "$domain" "$key" 2>/dev/null) || return 0
    if [[ "$actual" != "$expected" ]]; then
      warn "\"$domain $key\" was set to $expected but reads back as $actual."
      mdm_overrides=$((mdm_overrides + 1))
    fi
  }

  # Dock
  verify_default com.apple.dock autohide 1
  verify_default com.apple.dock largesize 128
  verify_default com.apple.dock magnification 1
  verify_default com.apple.dock mru-spaces 0
  verify_default com.apple.dock orientation bottom
  verify_default com.apple.dock show-recents 0
  verify_default com.apple.dock wvous-bl-corner 1
  verify_default com.apple.dock wvous-br-corner 5
  verify_default com.apple.dock wvous-tl-corner 1
  verify_default com.apple.dock wvous-tr-corner 1

  # Finder
  verify_default NSGlobalDomain AppleShowAllExtensions 1
  verify_default com.apple.finder AppleShowAllFiles 1
  verify_default com.apple.finder ShowPathbar 1
  verify_default com.apple.finder ShowStatusBar 0

  # Screenshots
  verify_default com.apple.screencapture location "$HOME/Documents/Screenshots"

  # Window Manager
  verify_default com.apple.WindowManager GloballyEnabled 0
  verify_default com.apple.WindowManager AppWindowGroupingBehavior 1
  verify_default com.apple.WindowManager AutoHide 0
  verify_default com.apple.WindowManager EnableTiledWindowMargins 0
  verify_default com.apple.WindowManager EnableTilingByEdgeDrag 0
  verify_default com.apple.WindowManager EnableTilingOptionAccelerator 0
  verify_default com.apple.WindowManager EnableTopTilingByEdgeDrag 0
  verify_default com.apple.WindowManager HideDesktop 1
  verify_default com.apple.WindowManager StageManagerHideWidgets 0
  verify_default com.apple.WindowManager StandardHideWidgets 1

  # Trackpad
  verify_default com.apple.AppleMultitouchTrackpad Clicking 1
  verify_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 1
  verify_default com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick 2
  verify_default com.apple.AppleMultitouchTrackpad TrackpadRightClick 0
  verify_default com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick 2
  verify_default com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick 0

  # Keyboard
  verify_default NSGlobalDomain KeyRepeat 1
  verify_default NSGlobalDomain InitialKeyRepeat 14
  verify_default NSGlobalDomain ApplePressAndHoldEnabled 0
  verify_default NSGlobalDomain com.apple.keyboard.fnState 0
  verify_default NSGlobalDomain AppleKeyboardUIMode 1

  # Appearance
  verify_default NSGlobalDomain AppleInterfaceStyle Dark
  verify_default NSGlobalDomain AppleFontSmoothing 0

  # Mouse & scrolling
  verify_default NSGlobalDomain com.apple.swipescrolldirection 0
  verify_default NSGlobalDomain com.apple.mouse.scaling "1.5"
  verify_default NSGlobalDomain com.apple.scrollwheel.scaling 1

  # Input source indicator
  verify_default kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

  if [[ "$mdm_overrides" -gt 0 ]]; then
    warn "$mdm_overrides setting(s) appear to be managed by MDM — check warnings above."
  else
    info "All macOS defaults verified successfully."
  fi
}

# ---------- Step 19: Mac App Store apps ----------

install_mas_apps() {
  # mas "purchase" via brew bundle is unreliable — install directly instead.
  declare -A MAS_APPS=(
    [1351639930]="Gifski"
    [6446206067]="Klack"
    [1291898086]="Toggl Track"
  )

  for id in "${!MAS_APPS[@]}"; do
    name="${MAS_APPS[$id]}"
    if mas list | grep -q "^${id}"; then
      info "${name} already installed."
    else
      info "Installing ${name}..."
      if mas install "$id"; then
        info "${name} installed."
      else
        warn "${name} failed to install — make sure you are signed into the App Store with the Apple ID that purchased it."
      fi
    fi
  done
}

# ---------- Main ----------

main() {
  ensure_clt
  ensure_homebrew
  install_packages
  install_aws_cli
  install_claude_code
  setup_node
  setup_rust
  setup_go
  setup_git_config
  setup_ssh_keys
  setup_tailscale
  setup_snowflake_key
  create_symlinks
  setup_tmux
  setup_fisher
  configure_sudo
  configure_yabai_sudoers
  set_default_shell
  configure_macos_defaults
  install_mas_apps
  info "Bootstrap complete. Some changes may require a logout or restart to take full effect."
}

main "$@"
