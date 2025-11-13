# Cross-Platform Nix Configuration

This configuration supports both **macOS** (via nix-darwin) and **Linux/WSL** (via home-manager standalone).

## Structure

```
nix-darwin/
├── flake.nix                    # Main flake orchestrating all configurations
├── darwin-configuration.nix     # macOS system-level configuration
├── linux-configuration.nix      # Linux system-level configuration (reference)
└── home-manager/
    ├── common.nix               # Shared configuration for both platforms
    ├── darwin.nix               # macOS-specific home configuration
    └── linux.nix                # Linux-specific home configuration
```

## Key Changes from Original Setup

### 1. **Brew packages moved to Nix**
Most brew packages are now installed via Nix and available on both platforms:
- Development tools: git, gh, fzf, ripgrep, bat, fd, jq, yazi, zoxide, etc.
- Language runtimes: go, rust, python, php, node (via fnm)
- Utilities: lazygit, lazydocker, btop, bottom, fastfetch, etc.

### 2. **Homebrew kept for macOS GUI apps only**
Homebrew now only manages:
- Casks (GUI applications): alfred, arc, 1password, obsidian, etc.
- `mas` (Mac App Store CLI)

### 3. **Platform-specific configurations**
- **macOS**: Uses nix-darwin for system config + home-manager for user config
- **Linux/WSL**: Uses home-manager standalone for user config

## Usage

### macOS

```bash
# Apply configuration on macOS
darwin-rebuild switch --flake ~/.config/nix-darwin

# Or if you're in the nix-darwin directory
darwin-rebuild switch --flake .
```

## Fresh macOS Bootstrap

The goal is to get a brand-new Mac to the point where `darwin-rebuild switch --flake ~/.config/nix-darwin` works. The steps below assume Apple Silicon but also apply to Intel (skip Rosetta).

1. **Install Apple tooling**
   ```bash
   xcode-select --install
   softwareupdate --install-rosetta --agree-to-license # Apple Silicon only
   ```
2. **Install multi-user Nix with flakes enabled**
   ```bash
   curl -L https://nixos.org/nix/install | sh -s -- --daemon
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```
3. **Install nix-darwin**
   ```bash
   nix run nix-darwin/master -- switch --flake ~/.config/nix-darwin
   ```
   The command above will fail if the flake does not exist yet—clone this repository into `~/.config/nix-darwin` (or any path you prefer and adjust commands accordingly) before running it.
4. **Apply the configuration**
   ```bash
   cd ~/.config/nix-darwin
   darwin-rebuild switch --flake .
   ```
5. **Touch ID / watchID reminder**: the `pam_watchid.so` line in `darwin-configuration.nix` is enabled by default (see the comment above the `etc."pam.d/sudo_local"` block). Comment it out until you have installed the watchID helper script; otherwise `sudo` will fail.

### Barebones apps installed on macOS

- **Terminal & windowing**: Ghostty, iTerm2, yabai, skhd, Aerospace-like hotkeys.
- **Browsers & productivity**: Arc, Firefox, Google Chrome, Slack, Discord, Obsidian, Raindrop, Toggl.
- **System essentials**: 1Password (+ CLI), Alfred, AppCleaner, AltTab, Karabiner Elements, key fonts (Meslo, Victor Mono, SF Mono, Fira Sans).

All CLI tooling (git, gh, fzf, ripgrep, tmux, Docker/Colima, language toolchains, etc.) is installed via nix packages declared in `darwin-configuration.nix` and `home-manager/common.nix`, so once `darwin-rebuild` succeeds the machine is ready for development.

### Linux/WSL

First, install Nix on WSL:
```bash
# Install Nix (multi-user installation recommended)
curl -L https://nixos.org/nix/install | sh -s -- --daemon

# Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Then install and use home-manager:
```bash
# Install home-manager
nix run home-manager/master -- init --switch

# Clone your dotfiles to Linux
cd ~
git clone <your-dotfiles-repo> dotfiles

# Update the dotfilesPath in home-manager/linux.nix if needed
# Default is: /home/blancpain/dotfiles

# Apply configuration on Linux (x86_64)
cd ~/dotfiles/nix-darwin
home-manager switch --flake .#blancpain@linux

# For ARM Linux (Raspberry Pi, etc.)
home-manager switch --flake .#blancpain@linux-aarch64
```

## Configuration Details

### Common Packages (Both Platforms)
Located in `home-manager/common.nix`:
- All CLI tools and development utilities
- Shared symlinks for nvim, tmux, fish, starship, etc.

### macOS-Specific
Located in `home-manager/darwin.nix` and `darwin-configuration.nix`:
- macOS GUI app paths (Library/Application Support)
- macOS-only tools: pngpaste, aerospace, karabiner, yabai, skhd
- System preferences: dock, finder, keyboard settings
- Homebrew casks and Mac App Store apps

### Linux-Specific
Located in `home-manager/linux.nix`:
- Linux-specific paths (.config/Code instead of Library/...)
- WSL-specific configurations
- Different home directory path (/home/blancpain)

## Adding New Packages

### CLI Tools (Available on Both Platforms)
Add to `home-manager/common.nix`:
```nix
home.packages = with pkgs; [
  # ... existing packages
  newtool
];
```

### macOS-Only Tools
Add to `home-manager/darwin.nix`:
```nix
home.packages = with pkgs; [
  # ... existing packages
  macos-only-tool
];
```

### Linux-Only Tools
Add to `home-manager/linux.nix`:
```nix
home.packages = with pkgs; [
  # ... existing packages
  linux-only-tool
];
```

### macOS GUI Apps
Add to `darwin-configuration.nix` under `homebrew.casks`:
```nix
homebrew = {
  casks = [
    # ... existing casks
    "new-app"
  ];
};
```

## Updating

```bash
# Update flake inputs
nix flake update

# macOS: Apply updates
darwin-rebuild switch --flake ~/.config/nix-darwin

# Linux: Apply updates
home-manager switch --flake ~/.config/nix-darwin#blancpain@linux
```

## Important Notes

1. **Dotfiles Path**: Update the `dotfilesPath` variable in both `common.nix` and `linux.nix` if your dotfiles are in a different location

2. **Username**: The username `blancpain` is hardcoded. If you need to change it:
   - Update in `darwin-configuration.nix`
   - Update in all `home-manager/*.nix` files
   - Update the flake.nix homeConfigurations

3. **WSL Considerations**:
   - Some tools like yabai, skhd, karabiner won't work on Linux (they're macOS-only)
   - GUI applications should be installed via WSL's preferred method (not included here)
   - Consider using [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) for a more integrated experience

4. **First-Time Setup on macOS**:
   - Comment out `pam_watchid.so` line in `darwin-configuration.nix` if you haven't set up watchID yet
   - Install watchID script before uncommenting

## Troubleshooting

### macOS: Permission denied on sudo
- Check that pam_watchid is properly commented out if not configured
- Verify yabai sudoers configuration

### Linux: Home directory not found
- Update `dotfilesPath` in `home-manager/linux.nix` and `common.nix`
- Ensure dotfiles are cloned to the correct location

### Package not found
- Run `nix flake update` to refresh package definitions
- Check if package name is correct: search on [search.nixos.org](https://search.nixos.org/packages)

## Resources

- [Nix Darwin Documentation](https://github.com/LnL7/nix-darwin)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Package Search](https://search.nixos.org/packages)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
