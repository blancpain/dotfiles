# Dotfiles

dotfiles managed with Homebrew and symlinks.

## Prerequisite: Git (SSH) Access

1. Check for an existing key:

   ```bash
   ls ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub
   ```

2. If absent, generate one:

   ```bash
   ssh-keygen -t ed25519 -C "you@example.com"
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
8. Creates dotfile symlinks
9. Sets fish as the default shell
10. Applies macOS system defaults (Dock, Finder, keyboard, trackpad, appearance, etc.)

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
- **Trackpad**: tap to click
- **Keyboard**: fast key repeat (rate 1, delay 14), press-and-hold disabled (key repeat instead), Fn shows special keys, keyboard access for dialogs
- **Appearance**: dark mode, sub-pixel font smoothing disabled
- **Mouse/Scrolling**: traditional (non-natural) scrolling, tracking speed 1.5, scroll wheel speed 1.0
- **Input**: input source indicator disabled

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

## Fixing yabai + skhd Accessibility Permissions

When yabai or skhd don't respond to Accessibility permissions (common after updates), you can fix them via the TCC database.

### 1. Check existing TCC Accessibility entries

```bash
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
"SELECT rowid, client, auth_value
FROM access
WHERE service = 'kTCCServiceAccessibility'
ORDER BY client;"
```

- `auth_value = 2` means allowed
- `auth_value = 0` means denied (stale/not approved)

### 2. Find current binary paths

```bash
which yabai
which skhd
```

With Homebrew these are typically `/opt/homebrew/bin/yabai` and `/opt/homebrew/bin/skhd`.

### 3. Backup the TCC database

```bash
sudo cp "/Library/Application Support/com.apple.TCC/TCC.db" \
"/Library/Application Support/com.apple.TCC/TCC.db.bak.$(date +%s)"
```

To restore if needed:

```bash
sudo cp "/Library/Application Support/com.apple.TCC/TCC.db.bak.TIMESTAMP" \
"/Library/Application Support/com.apple.TCC/TCC.db"
sudo reboot
```

### 4. Delete stale entries

Delete rows that don't match your current binary paths (replace rowids with your own):

```bash
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
"DELETE FROM access WHERE rowid IN (270,272);"
```

### 5. Enable correct binaries

Set the correct yabai + skhd entries to `auth_value = 2`:

```bash
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
"UPDATE access SET auth_value = 2 WHERE rowid IN (274,275);"
```

### 6. Verify

```bash
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
"SELECT rowid, client, auth_value
FROM access
WHERE client LIKE '%yabai%' OR client LIKE '%skhd%';"
```

Expect exactly two rows, both with `auth_value = 2`, matching your binary paths.

### 7. Reboot and confirm

After reboot, yabai tiling and skhd keybindings should work without permission popups.

| Issue                              | Cause                         | Fix                                 |
| ---------------------------------- | ----------------------------- | ----------------------------------- |
| No popup appears for Accessibility | launchd starts apps too early | Force-enable via SQL (Step 5)       |
| Homebrew updates change paths      | Binary path changed           | Repeat process                      |
| Old entries still appear           | Previous installation         | Delete TCC row + verify binary path |

yabai/skhd may not appear in System Settings > Accessibility because they are CLI binaries, not `.app` bundles. This is expected.

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
