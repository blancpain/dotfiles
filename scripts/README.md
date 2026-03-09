# Dotfiles

dotfiles managed with Homebrew and symlinks.

## Prerequisite: Git (SSH) Access

This is required before the repo can be cloned.

### With 1Password (recommended)

Prerequisites:

- 1Password installed and signed in to your account
- SSH keys stored in your vault as **"GitHub Personal"** and **"GitHub Work"** items (already registered in GitHub)
- SSH agent enabled: **1Password → Settings → Developer → Use the SSH agent**

1. Test the connection:

   ```bash
   ssh -T git@github.com
   ```

2. Clone:

   ```bash
   cd ~
   git clone git@github.com:<owner>/<repo>.git dotfiles
   ```

### Without 1Password

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

Two bootstrap scripts and two Brewfiles exist — pick the right pair for your machine:

| Machine type | Script | Brewfile |
| ------------ | ------ | -------- |
| Corporate / BYOD | `scripts/bootstrap-macos-non-nix-corporate.sh` | `brew/Brewfile.corporate` |
| Personal | `scripts/bootstrap-macos-non-nix-personal.sh` | `brew/Brewfile.personal` |

**Differences between corporate and personal:**

| Feature | Corporate | Personal |
| ------- | --------- | -------- |
| `cloudflared`, `ngrok`, `supabase` | — | ✓ |
| `pam-reattach` (Touch ID sudo in tmux) | — | ✓ |
| Yabai passwordless sudoers | — | ✓ |
| Mac App Store apps (Gifski, Klack, Toggl Track) | — | ✓ |
| Safari Extensions (1Password, Raindrop, Notion Clipper, uBlock) | — | ✓ |

Run from anywhere inside the repo:

```bash
# Corporate / BYOD
./scripts/bootstrap-macos-non-nix-corporate.sh

# Personal
./scripts/bootstrap-macos-non-nix-personal.sh
```

What each script does:

1. Ensures Apple Command Line Tools are installed
2. Installs Homebrew (Apple Silicon)
3. Installs all packages via `brew bundle` (using the matching Brewfile)
4. Installs AWS CLI v2
5. Installs Claude Code
6. Sets up Node.js (fnm + LTS) and global npm packages (mermaid-cli, gemini-cli, codex, tsx, typescript, tree-sitter-cli)
7. Sets up Rust toolchain (stable)
8. Installs Go tools (bootdev)
9. Configures global git identity (user.name / user.email)
10. Sets up SSH keys — if 1Password is installed, extracts public keys from "GitHub Personal" and "GitHub Work" items via `op`; otherwise generates fresh keys interactively. Writes `~/.ssh/config` with GitHub host aliases and tests both connections. **If your org enforces SAML SSO**, you must also authorize the work key: GitHub → Settings → SSH and GPG keys → Configure SSO → Authorize `<org>`
11. Optionally restores the Snowflake private key from 1Password (`Snowflake SSH Key (SME)`) and derives the public key from it
12. Creates dotfile symlinks
13. Installs TPM (Tmux Plugin Manager)
14. Bootstraps Fisher plugins for fish shell
15. *(Personal only)* Configures Touch ID sudo via `pam-reattach`
16. *(Personal only)* Configures passwordless sudo for `yabai --load-sa`
17. Sets fish as the default shell
18. Applies macOS system defaults (Dock, Finder, keyboard, trackpad, appearance, etc.)

### SSH Keys

**What the bootstrap script manages:**

| File                                | How it's handled                                                                          |
| ----------------------------------- | ----------------------------------------------------------------------------------------- |
| `~/.ssh/id_ed25519.pub`             | Extracted from 1Password ("GitHub Personal") via `op`, or generated fresh if no 1Password |
| `~/.ssh/id_ed25519_github_work.pub` | Extracted from 1Password ("GitHub Work") via `op`, or generated fresh if no 1Password     |
| `~/.ssh/snowflake/rsa_key.p8`       | Pulled from 1Password item `Snowflake SSH Key (SME)` (prompted)                           |
| `~/.ssh/snowflake/rsa_key.pub`      | Derived from the private key (see below) — same public key every time                     |
| `~/.ssh/config`                     | Written by the script — GitHub host aliases + 1Password agent block                       |
| `~/.ssh/known_hosts`                | **Do not copy.** Rebuilds automatically on first connection to each host                  |

**With 1Password**, the same public keys are extracted on every machine — no need to re-add them to GitHub after the first setup. **Without 1Password**, fresh keys are generated and must be added to GitHub after bootstrap. Because the Snowflake public key is derived deterministically from the private key (which lives in 1Password), it is always identical to the one registered in Terraform — no Terraform changes needed.

**Deriving a public key from a private key:**

For the Snowflake RSA key (PKCS8 `.p8` format):

```bash
openssl pkey -in ~/.ssh/snowflake/rsa_key.p8 -pubout -out ~/.ssh/snowflake/rsa_key.pub
```

For a standard OpenSSH key:

```bash
ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub
```

**The `~/.ssh/config` written by the bootstrap:**

```
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519

Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github_work
```

The `Host * / IdentityAgent` block for the 1Password SSH agent is **not** written by the bootstrap — 1Password adds it automatically when you enable the SSH agent in **Settings → Developer → Use the SSH agent**. This avoids duplicating the block if 1Password has already written it.

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

*(Personal machines only.)* Touch ID is configured for sudo via `/etc/pam.d/sudo_local`, including `pam-reattach` so it works inside tmux sessions. This is handled automatically by the personal bootstrap script — no manual PAM edits required.

## Adding/Removing Packages

Edit the appropriate Brewfile (`brew/Brewfile.corporate` or `brew/Brewfile.personal`) and run:

```bash
brew bundle --file=brew/Brewfile.corporate
# or
brew bundle --file=brew/Brewfile.personal
```

To also remove packages not in the Brewfile:

```bash
brew bundle --file=brew/Brewfile.corporate --cleanup
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
