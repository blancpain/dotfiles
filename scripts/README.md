# Dotfiles

dotfiles managed with Homebrew and symlinks.

## Prerequisite: Git (SSH) Access

This is required before the repo can be cloned. Only the personal key is needed here — the bootstrap script handles generating and configuring the work key automatically.

1. Check for an existing key:

   ```bash
   ls ~/.ssh/id_ed25519.pub
   ```

2. If absent, generate one:

   ```bash
   ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_ed25519
   ```

3. Start agent and add the key:

   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

4. Copy the public key:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

5. Add it to GitHub: **Settings > SSH and GPG keys > New SSH key** > paste > save.

6. Test:

   ```bash
   ssh -T git@github.com
   ```

7. Clone:

   ```bash
   cd ~
   git clone git@github.com:<owner>/<repo>.git dotfiles
   ```

## Fresh macOS Bootstrap

Run the automated bootstrap script from anywhere inside the repo:

```bash
./scripts/bootstrap-macos-non-nix.sh
```

What it does:

1. Ensures Apple Command Line Tools are installed
2. Installs Homebrew (Apple Silicon)
3. Installs all packages via `brew bundle` (Brewfile)
4. Installs Claude Code
5. Sets up Node.js (fnm + LTS) and global npm packages (mermaid-cli, gemini-cli, codex, tsx, typescript, tree-sitter-cli)
6. Sets up Rust toolchain (stable)
7. Installs Go tools (bootdev)
8. Configures global git identity (user.name / user.email)
9. Sets up SSH keys — generates personal (`~/.ssh/id_ed25519`) and work (`~/.ssh/id_ed25519_github_work`) keys if absent, configures `~/.ssh/config` with `github.com` (personal) and `github-work` (work) host aliases, and tests both connections. **If your org enforces SAML SSO**, you must also authorize the work key: GitHub → Settings → SSH and GPG keys → Configure SSO → Authorize `<org>`
10. Creates dotfile symlinks
11. Installs TPM (Tmux Plugin Manager)
12. Bootstraps Fisher plugins for fish shell
13. Sets fish as the default shell
14. Applies macOS system defaults (Dock, Finder, keyboard, trackpad, appearance, etc.)

> **Corporate/BYOD note:** Touch ID sudo (`pam-reattach`) and yabai sudoers are commented out in the bootstrap script — they require modifying `/etc/pam.d` and `/etc/sudoers.d` which is not permitted on corporate-enrolled machines. Uncomment them in the script for personal machines.

### Post-bootstrap (laptops only)

Install [AlDente](https://apphousekitchen.com/) for battery charge management. This is only needed on MacBook laptops (not Mac minis, Mac Studios, etc.).

### Symlinks Created

| Target in `~`                               | Source in repo   |
| ------------------------------------------- | ---------------- |
| `.config/starship`                          | `starship/`      |
| `.config/nvim`                              | `nvim/`          |
| `.config/tmux`                              | `tmux/`          |
| `.config/lazygit`                           | `lazygit/`       |
| `.config/fish`                              | `fish/`          |
| `.config/yazi`                              | `yazi/`          |
| `.config/karabiner`                         | `karabiner/`     |
| `.config/skhd`                              | `skhd/`          |
| `.config/yabai`                             | `yabai/`         |
| `.config/ghostty`                           | `ghostty/`       |
| `.hammerspoon`                              | `hammerspoon/`   |
| `Library/Application Support/Code/User`     | `Code/User/`     |
| `Library/Application Support/Cursor/User`   | `Cursor/User/`   |
| `Library/Application Support/Windsurf/User` | `Windsurf/User/` |

### macOS Defaults Applied

The bootstrap script configures these system preferences:

- **Dock**: auto-hide, magnification, no recent apps, no MRU space reordering, bottom-right hot corner starts screen saver
- **Finder**: show all extensions, show path bar, hide status bar
- **Screenshots**: saved to `~/Documents/Screenshots`
- **Window Manager**: Stage Manager disabled, all tiling disabled (yabai handles this)
- **Trackpad**: tap to click, secondary click via bottom-right corner
- **Keyboard**: fast key repeat (rate 1, delay 14), press-and-hold disabled (key repeat instead), Fn shows special keys, keyboard access for dialogs
- **Appearance**: dark mode, sub-pixel font smoothing disabled
- **Mouse/Scrolling**: traditional (non-natural) scrolling, tracking speed 1.5, scroll wheel speed 1.0
- **Input**: input source indicator disabled

### Manual Settings

These cannot be automated via `defaults write` and must be configured by hand:

- **Display**: System Settings > Displays > disable "Automatically adjust brightness"
- **Location Services**: System Settings > Privacy & Security > Location Services > disable location access for most apps (keep only Find My and essential services)

### Fish Shell

Fish is set as the default shell automatically. To set it manually:

```bash
echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/fish"
```

### Touch ID for sudo

Touch ID is configured for sudo via `/etc/pam.d/sudo_local`, including `pam-reattach` so it works inside tmux sessions. No manual PAM edits required.

## Adding/Removing Packages

Edit `brew/Brewfile` and run:

```bash
brew bundle --file=brew/Brewfile
```

To also remove packages not in the Brewfile:

```bash
brew bundle --file=brew/Brewfile --cleanup
```

## Granting yabai + skhd Accessibility Permissions

CLI binaries like yabai and skhd won't appear in the standard Accessibility list and can't be added by dragging into System Settings directly. The trick is to use the **file picker dialog** instead. No SIP disablement required.

### Steps (repeat for both yabai and skhd)

1. Open the Homebrew bin directory in Finder:

   ```bash
   open /opt/homebrew/bin
   ```

2. Go to **System Settings > Privacy & Security > Accessibility**.

3. Click the **+** button at the bottom — this opens a file picker dialog.

4. **Drag and drop** the binary (e.g. `yabai`) from the Finder window **into the file picker dialog** (not into the System Settings window itself).

5. Approve the change if prompted.

6. The binary will **not** appear in the Accessibility list afterwards — this is normal for CLI binaries that aren't `.app` bundles.

7. Verify it works:

   ```bash
   yabai --restart-service
   skhd --restart-service
   ```

> **Note:** After Homebrew updates that replace the binary, you may need to repeat this process.

## Troubleshooting

### Permission denied on sudo

Verify yabai sudoers configuration:

```bash
cat /etc/sudoers.d/yabai
```

The hash should match the current binary:

```bash
shasum -a 256 "$(which yabai)"
```

If they differ, re-run the bootstrap script or manually update the sudoers file.

### Symlink conflicts

The bootstrap script backs up existing non-symlink targets to `<path>.backup`. Check for `.backup` files if something looks wrong.

### Package not found in Brewfile

Search Homebrew for the correct formula name:

```bash
brew search <package>
```
