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
darwin-rebuild switch --flake ~/.config/nix-darwin#mac

# Or if you're in the nix-darwin directory
darwin-rebuild switch --flake .#mac
```

## Fresh macOS Bootstrap

The goal is to get a brand-new Mac to the point where `darwin-rebuild switch --flake ~/dotfiles/nix-darwin#mac` works. The steps below assume Apple Silicon. For an automated run, execute `./scripts/bootstrap-macos.sh` from this repo—it walks through the same steps and stops if manual intervention is required.

1. **Clone this repository to ~/dotfiles**

   ```bash
   cd ~
   git clone <repo-url> dotfiles
   ```

2. **Install Apple tooling**

   ```bash
   xcode-select --install
   softwareupdate --install-rosetta --agree-to-license # Apple Silicon only
   ```

3. **Install multi-user Nix (Determinate Systems installer)**

   ```bash
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
   ```

   See the [Determinate Nix Installer docs](https://github.com/DeterminateSystems/nix-installer#determinate-nix-installer) for background. This repo manages `~/.config/nix/nix.conf` (symlinked when the flake is applied), so no need to manually enable flakes here.

4. **Install Homebrew** (for casks & MAS CLI)

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```

5. **Install nix-darwin**
   Follow the [nix-darwin getting-started guide](https://github.com/nix-darwin/nix-darwin?tab=readme-ov-file#getting-started-from-scratch) if you need to bootstrap `/etc/nix-darwin` (create the directory, `nix flake init -t ...`, set `nixpkgs.hostPlatform`, etc.). Once the flake exists (repo cloned) install or update nix-darwin via:

   ```bash
   sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles/nix-darwin#mac
   ```

   The command above will fail if the flake does not exist yet.

   The flake exports a single macOS configuration named `mac`, so always include `#mac` when invoking the flake.

6. **Apply the configuration**

   ```bash
   cd ~/dotfiles/nix-darwin
   darwin-rebuild switch --flake .#mac
   ```

Touch ID (including Apple Watch unlock) is configured automatically via nix-darwin; no manual PAM edits or helper scripts are required.

### Barebones apps installed on macOS

- **Terminal & windowing**: Ghostty, yabai, skhd.
- **Browsers & productivity**: Arc, Firefox, Google Chrome, Slack, Discord, Obsidian, Raindrop, Toggl.
- **System essentials**: 1Password (+ CLI), Alfred, AppCleaner, AltTab, Karabiner Elements, key fonts (Meslo, Victor Mono, SF Mono, Fira Sans).

All CLI tooling (git, gh, fzf, ripgrep, tmux, Docker/Colima, language toolchains, etc.) is installed via nix packages declared in `darwin-configuration.nix` and `home-manager/common.nix`, so once `darwin-rebuild` succeeds the machine is ready for development.

## Linux/WSL

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
darwin-rebuild switch --flake ~/.config/nix-darwin#mac

# Linux: Apply updates
home-manager switch --flake ~/.config/nix-darwin#blancpain@linux
```

## Important Notes

1. **Dotfiles Path**: Update the `dotfilesPath` variable in both `common.nix` and `linux.nix` if your dotfiles are in a different location

2. **Username**: The username `blancpain` is hardcoded. If you need to change it:
   - Update in `darwin-configuration.nix`
   - Update in all `home-manager/*.nix` files
   - Update the flake.nix homeConfigurations

3. **Touch ID / Apple Watch**: PAM is configured automatically via nix-darwin (`watchIdAuth` + `pam_reattach`); no manual edits or scripts are required.

4. **WSL Considerations**:
   - Some tools like yabai, skhd, karabiner won't work on Linux (they're macOS-only)
   - GUI applications should be installed via WSL's preferred method (not included here)
   - Consider using [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) for a more integrated experience

## Troubleshooting

### macOS: Permission denied on sudo

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
