#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-linux-vps.sh

Automates a fresh Ubuntu VPS setup (e.g., Hetzner):
  1. Install build essentials and prerequisites
  2. Install CLI packages via apt
  3. Fix Ubuntu binary name quirks (fd-find, batcat)
  4. Install Go (from go.dev)
  5. Install tools not available in apt (starship, lazygit, etc.)
  6. Install Docker Engine
  7. Install AWS CLI v2
  8. Install Claude Code
  9. Set up Rust toolchain (stable) + cargo tools (bob)
  10. Set up Node.js (fnm + LTS) and global npm packages
  11. Install Python tools via pipx (awsume, pgcli)
  12. Configure global git identity (user.name / user.email)
  13. Set up SSH key (personal GitHub) via 1Password or ssh-keygen
  14. Create dotfile symlinks
  15. Install TPM (Tmux Plugin Manager)
  16. Bootstrap Fisher plugins for fish shell
  17. Set fish as default shell

Run this script from anywhere inside the repo.
EOF
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $(uname) != "Linux" ]]; then
  echo "This bootstrap script is intended for Linux only." >&2
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
  echo "Run this script as a regular user (sudo will be requested when needed)." >&2
  exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)

# Detect architecture for download URLs
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  DEB_ARCH="amd64"; GO_ARCH="amd64" ;;
  aarch64) DEB_ARCH="arm64"; GO_ARCH="arm64" ;;
  *)       echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

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

# Helper: fetch the latest GitHub release tag for a repo.
gh_latest_tag() {
  local repo="$1"
  curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" | jq -r '.tag_name'
}

# Helper: install a .deb from a URL.
install_deb() {
  local url="$1"
  local tmp
  tmp=$(mktemp --suffix=.deb)
  curl -fsSL -o "$tmp" "$url"
  sudo dpkg -i "$tmp" || sudo apt-get install -yf
  rm -f "$tmp"
}

# ---------- Step 1: Build essentials ----------

ensure_build_essentials() {
  info "Installing build essentials and prerequisites."
  sudo apt-get update
  sudo apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    libfontconfig1-dev \
    unzip \
    curl \
    wget \
    software-properties-common \
    jq
}

# ---------- Step 2: Apt packages ----------

install_apt_packages() {
  # Add fish shell PPA for latest version
  if ! grep -q "fish-shell" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    info "Adding fish shell PPA."
    sudo add-apt-repository -y ppa:fish-shell/release-4
    sudo apt-get update
  fi

  info "Installing CLI packages via apt."
  sudo apt-get install -y \
    automake \
    bat \
    btop \
    cloc \
    cpanminus \
    fd-find \
    fish \
    fontconfig \
    fzf \
    ghostscript \
    git \
    httpie \
    hub \
    imagemagick \
    make \
    ncurses-bin \
    pandoc \
    php \
    pipx \
    poppler-utils \
    python3 \
    python3-venv \
    rclone \
    redis-tools \
    ripgrep \
    tmux \
    tree \
    unar \
    webp \
    wget \
    wimtools \
    xclip \
    || warn "Some apt packages may have failed — check output above."
}

# ---------- Step 3: Fix apt binary names ----------

fix_apt_binary_names() {
  # Ubuntu installs fd as "fdfind" and bat as "batcat" to avoid name conflicts
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    info "Creating fd symlink (fdfind → fd)."
    sudo ln -sfn "$(command -v fdfind)" /usr/local/bin/fd
  fi

  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    info "Creating bat symlink (batcat → bat)."
    sudo ln -sfn "$(command -v batcat)" /usr/local/bin/bat
  fi
}

# ---------- Step 4: Go ----------

install_go() {
  if command -v go >/dev/null 2>&1; then
    info "Go already installed ($(go version))."
    return
  fi

  info "Installing Go from go.dev."
  local go_version
  go_version=$(curl -fsSL "https://go.dev/dl/?mode=json" | jq -r '.[0].version')
  local url="https://go.dev/dl/${go_version}.linux-${GO_ARCH}.tar.gz"

  sudo rm -rf /usr/local/go
  curl -fsSL "$url" | sudo tar -C /usr/local -xzf -
  export PATH="/usr/local/go/bin:$PATH"
  info "Go installed: $(go version)."
}

# ---------- Step 5: Manual tool installs ----------

install_starship() {
  if command -v starship >/dev/null 2>&1; then
    info "starship already installed."
    return
  fi
  info "Installing starship."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_lazygit() {
  if command -v lazygit >/dev/null 2>&1; then
    info "lazygit already installed."
    return
  fi
  info "Installing lazygit."
  local tag version
  tag=$(gh_latest_tag "jesseduffield/lazygit")
  version="${tag#v}"
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${version}_Linux_${ARCH}.tar.gz" | tar -C "$tmp" -xzf -
  sudo install "$tmp/lazygit" /usr/local/bin/
  rm -rf "$tmp"
}

install_lazydocker() {
  if command -v lazydocker >/dev/null 2>&1; then
    info "lazydocker already installed."
    return
  fi
  info "Installing lazydocker."
  local tag version
  tag=$(gh_latest_tag "jesseduffield/lazydocker")
  version="${tag#v}"
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/jesseduffield/lazydocker/releases/download/${tag}/lazydocker_${version}_Linux_${ARCH}.tar.gz" | tar -C "$tmp" -xzf -
  sudo install "$tmp/lazydocker" /usr/local/bin/
  rm -rf "$tmp"
}

install_gh() {
  if command -v gh >/dev/null 2>&1; then
    info "gh (GitHub CLI) already installed."
    return
  fi
  info "Installing GitHub CLI."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=${DEB_ARCH} signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli-stable.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y gh
}

install_fnm() {
  if command -v fnm >/dev/null 2>&1; then
    info "fnm already installed."
    return
  fi
  info "Installing fnm."
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
}

install_zoxide() {
  if command -v zoxide >/dev/null 2>&1; then
    info "zoxide already installed."
    return
  fi
  info "Installing zoxide."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

install_yazi() {
  if command -v yazi >/dev/null 2>&1; then
    info "yazi already installed."
    return
  fi
  info "Installing yazi."
  local tag
  tag=$(gh_latest_tag "sxyazi/yazi")
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/sxyazi/yazi/releases/download/${tag}/yazi-${ARCH}-unknown-linux-gnu.zip" -o "$tmp/yazi.zip"
  unzip -o "$tmp/yazi.zip" -d "$tmp/"
  sudo install "$tmp"/yazi-*/yazi /usr/local/bin/
  sudo install "$tmp"/yazi-*/ya /usr/local/bin/
  rm -rf "$tmp"
}

install_bun() {
  if command -v bun >/dev/null 2>&1; then
    info "bun already installed."
    return
  fi
  info "Installing bun."
  curl -fsSL https://bun.sh/install | bash
}

install_bottom() {
  if command -v btm >/dev/null 2>&1; then
    info "bottom already installed."
    return
  fi
  info "Installing bottom."
  local tag
  tag=$(gh_latest_tag "ClementTsang/bottom")
  install_deb "https://github.com/ClementTsang/bottom/releases/download/${tag}/bottom_${tag}_${DEB_ARCH}.deb"
}

install_gdu() {
  if command -v gdu >/dev/null 2>&1; then
    info "gdu already installed."
    return
  fi
  info "Installing gdu."
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/dundee/gdu/releases/latest/download/gdu_linux_${DEB_ARCH}.tgz" | tar -C "$tmp" -xzf -
  sudo install "$tmp"/gdu_linux_* /usr/local/bin/gdu
  rm -rf "$tmp"
}

install_carapace() {
  if command -v carapace >/dev/null 2>&1; then
    info "carapace already installed."
    return
  fi
  info "Installing carapace."
  local tag
  tag=$(gh_latest_tag "carapace-sh/carapace-bin")
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/carapace-sh/carapace-bin/releases/download/${tag}/carapace-bin_linux_${DEB_ARCH}.tar.gz" | tar -C "$tmp" -xzf -
  sudo install "$tmp/carapace" /usr/local/bin/
  rm -rf "$tmp"
}

install_sesh() {
  if command -v sesh >/dev/null 2>&1; then
    info "sesh already installed."
    return
  fi
  if ! command -v go >/dev/null 2>&1; then
    warn "Go not found; skipping sesh install."
    return
  fi
  info "Installing sesh via go install."
  go install github.com/joshmedeski/sesh@latest
}

install_fastfetch() {
  if command -v fastfetch >/dev/null 2>&1; then
    info "fastfetch already installed."
    return
  fi
  info "Installing fastfetch."
  local tag
  tag=$(gh_latest_tag "fastfetch-cli/fastfetch")
  install_deb "https://github.com/fastfetch-cli/fastfetch/releases/download/${tag}/fastfetch-linux-${DEB_ARCH}.deb"
}

install_cloudflared() {
  if command -v cloudflared >/dev/null 2>&1; then
    info "cloudflared already installed."
    return
  fi
  info "Installing cloudflared."
  install_deb "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${DEB_ARCH}.deb"
}

install_yq() {
  if command -v yq >/dev/null 2>&1; then
    info "yq already installed."
    return
  fi
  info "Installing yq."
  sudo curl -fsSL -o /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${DEB_ARCH}"
  sudo chmod +x /usr/local/bin/yq
}

install_uv() {
  if command -v uv >/dev/null 2>&1; then
    info "uv already installed."
    return
  fi
  info "Installing uv."
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_tectonic() {
  if command -v tectonic >/dev/null 2>&1; then
    info "tectonic already installed."
    return
  fi
  info "Installing tectonic."
  curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh
  # The install script drops the binary in the current directory
  if [[ -f ./tectonic ]]; then
    sudo install ./tectonic /usr/local/bin/
    rm ./tectonic
  fi
}

install_terraform() {
  if command -v terraform >/dev/null 2>&1; then
    info "terraform already installed."
    return
  fi
  info "Installing terraform."
  wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 2>/dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y terraform
}

install_supabase() {
  if command -v supabase >/dev/null 2>&1; then
    info "supabase already installed."
    return
  fi
  info "Installing supabase CLI."
  local tag version
  tag=$(gh_latest_tag "supabase/cli")
  version="${tag#v}"
  install_deb "https://github.com/supabase/cli/releases/download/${tag}/supabase_${version}_linux_${DEB_ARCH}.deb"
}

install_docker() {
  if command -v docker >/dev/null 2>&1; then
    info "Docker already installed."
    return
  fi
  info "Installing Docker Engine."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER"
  warn "You need to log out and back in for docker group membership to take effect."
}

install_manual_tools() {
  install_starship
  install_lazygit
  install_lazydocker
  install_gh
  install_fnm
  install_zoxide
  install_yazi
  install_bun
  install_bottom
  install_gdu
  install_carapace
  install_sesh
  install_fastfetch
  install_cloudflared
  install_yq
  install_uv
  install_tectonic
  install_terraform
  install_supabase
  install_docker
}

# ---------- Step 6: AWS CLI ----------

install_aws_cli() {
  if command -v aws >/dev/null 2>&1; then
    info "AWS CLI already installed ($(aws --version 2>&1 | head -1))."
    return
  fi

  info "Installing AWS CLI v2."
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o "$tmp/awscliv2.zip"
  unzip -o "$tmp/awscliv2.zip" -d "$tmp/"
  if sudo "$tmp/aws/install"; then
    info "AWS CLI installed: $(aws --version 2>&1 | head -1)."
  else
    warn "AWS CLI installer failed."
  fi
  rm -rf "$tmp"
}

# ---------- Step 7: Claude Code ----------

install_claude_code() {
  if command -v claude >/dev/null 2>&1; then
    info "Claude Code already installed."
    return
  fi

  info "Installing Claude Code."
  curl -fsSL https://claude.ai/install.sh | bash ||
    warn "Claude Code install failed (proxy or firewall may be blocking the download)."
}

# ---------- Step 8: Rust toolchain ----------

setup_rust() {
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

# ---------- Step 8b: Cargo tools ----------

install_cargo_tools() {
  if ! command -v cargo >/dev/null 2>&1; then
    warn "cargo not found; skipping cargo tool installs."
    return
  fi

  # bob (Neovim version manager)
  if command -v bob >/dev/null 2>&1; then
    info "bob already installed."
  else
    info "Installing bob (Neovim version manager) via cargo."
    cargo install --locked bob-nvim || warn "Failed to install bob."
  fi

  if command -v bob >/dev/null 2>&1; then
    if ! bob list 2>/dev/null | grep -q "Used"; then
      info "Installing Neovim stable via bob."
      bob install stable
      bob use stable
    else
      info "Neovim already managed by bob."
    fi
  fi
}

# ---------- Step 9: Node.js + global npm packages ----------

setup_node() {
  # fnm may have been installed to ~/.local/share/fnm
  if [[ -d "$HOME/.local/share/fnm" ]]; then
    export PATH="$HOME/.local/share/fnm:$PATH"
  fi

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

# ---------- Step 10: pipx packages ----------

install_pipx_packages() {
  if ! command -v pipx >/dev/null 2>&1; then
    warn "pipx not found; skipping Python tool installs."
    return
  fi

  pipx ensurepath 2>/dev/null || true

  local pipx_packages=(
    "awsume"
    "pgcli"
  )

  for pkg in "${pipx_packages[@]}"; do
    if pipx list 2>/dev/null | grep -q "$pkg"; then
      info "$pkg already installed via pipx."
    else
      info "Installing $pkg via pipx."
      pipx install "$pkg" || warn "Failed to install $pkg."
    fi
  done
}

# ---------- Step 11: Git global config ----------

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

# ---------- Step 12: SSH keys ----------

setup_ssh_keys() {
  local personal_key="$HOME/.ssh/id_ed25519"
  local ssh_config="$HOME/.ssh/config"

  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  # Try 1Password CLI first
  if command -v op >/dev/null 2>&1; then
    if ! op whoami >/dev/null 2>&1; then
      info "Signing in to 1Password CLI."
      op signin || warn "1Password sign-in failed."
    fi

    if op whoami >/dev/null 2>&1; then
      if [[ ! -f "$personal_key.pub" ]]; then
        info "Extracting GitHub Personal public key from 1Password."
        op item get "GitHub Personal" --fields "public key" >"$personal_key.pub" ||
          warn "Failed to extract 'GitHub Personal' public key from 1Password."
      else
        info "GitHub Personal public key already exists; skipping."
      fi
    fi
  fi

  # Fall back to generating a new key if no key exists
  if [[ ! -f "$personal_key" && ! -f "$personal_key.pub" ]]; then
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

  # Load key into agent
  eval "$(ssh-agent -s)" 2>/dev/null || true
  [[ -f "$personal_key" ]] && ssh-add "$personal_key" 2>/dev/null || true

  # Ensure ~/.ssh/config has the GitHub host entry
  if grep -qF "Host github.com" "$ssh_config" 2>/dev/null; then
    info "GitHub SSH host entry already in $ssh_config."
  else
    info "Adding GitHub SSH host entry to $ssh_config."
    local tmp
    tmp=$(mktemp)
    cat >"$tmp" <<'SSHCONF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519

SSHCONF
    # Prepend to any pre-existing config, preserving manual additions
    [[ -f "$ssh_config" ]] && cat "$ssh_config" >>"$tmp"
    mv "$tmp" "$ssh_config"
    chmod 600 "$ssh_config"
  fi

  # Test connection
  info "Testing GitHub SSH connection..."
  local out
  out=$(ssh -T git@github.com -o StrictHostKeyChecking=accept-new 2>&1) || true
  if [[ "$out" == *"successfully authenticated"* ]]; then
    info "Personal GitHub SSH: OK"
  else
    warn "Personal GitHub SSH test failed — make sure the key is added to your GitHub account."
  fi
}

# ---------- Step 13: Symlinks ----------

create_symlinks() {
  info "Creating dotfile symlinks."

  local config_pkgs=(starship nvim tmux lazygit fish yazi)
  for pkg in "${config_pkgs[@]}"; do
    link_file "$REPO_ROOT/$pkg" "$HOME/.config/$pkg"
  done
}

# ---------- Step 14: TPM (Tmux Plugin Manager) ----------

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

# ---------- Step 15: Fisher plugins ----------

setup_fisher() {
  local fish_path="/usr/bin/fish"

  if [[ ! -x "$fish_path" ]]; then
    warn "Fish not found at $fish_path; skipping Fisher plugin setup."
    return
  fi

  local fish_plugins="$HOME/.config/fish/fish_plugins"
  if [[ ! -f "$fish_plugins" ]]; then
    warn "fish_plugins file not found at $fish_plugins; skipping Fisher setup."
    return
  fi

  # Check if Fisher and all plugins are already installed
  local installed
  installed=$("$fish_path" -c 'fisher list 2>/dev/null' | sort) || true
  local wanted
  wanted=$(sort <"$fish_plugins")

  if [[ -n "$installed" && "$installed" == "$wanted" ]]; then
    info "Fisher plugins already installed."
    return
  fi

  info "Bootstrapping Fisher plugins."
  "$fish_path" -c '
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher update
  ' || warn "Fisher plugin bootstrap failed — you can retry manually with: fish -c \"curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update\""
}

# ---------- Step 16: Default shell ----------

set_default_shell() {
  local fish_path="/usr/bin/fish"

  if [[ ! -x "$fish_path" ]]; then
    warn "Fish not found at $fish_path; skipping shell change."
    return
  fi

  local current_shell
  current_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
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
  if sudo chsh -s "$fish_path" "$(whoami)"; then
    info "Default shell changed to fish. Log out and back in to use it."
  else
    warn "chsh failed — you can set fish as your shell manually."
  fi
}

# ---------- Main ----------

main() {
  ensure_build_essentials
  install_apt_packages
  fix_apt_binary_names
  install_go
  install_manual_tools
  install_aws_cli
  install_claude_code
  setup_rust
  install_cargo_tools
  setup_node
  install_pipx_packages
  setup_git_config
  setup_ssh_keys
  create_symlinks
  setup_tmux
  setup_fisher
  set_default_shell
  info "Bootstrap complete. Log out and back in for shell and docker group changes to take effect."
}

main "$@"
