# Cross-Platform Nix Configuration

This configuration supports both **macOS** (via nix-darwin) and **Linux/WSL**.

## Structure

```
nix-darwin/
├── flake.nix                    # Main flake orchestrating all configurations
├── darwin-configuration.nix     # macOS system-level configuration
├── linux-configuration.nix      # NixOS system-level configuration (reference)
├── networking.nix               # Networking configuration for NixOS
├── system/
│   └── common-packages.nix      # Shared system packages for all platforms
└── home-manager/
    ├── common.nix               # Shared configuration for both platforms
    ├── darwin.nix               # macOS-specific home configuration
    └── linux.nix                # Linux-specific home configuration
```

## Prerequisite: Git (SSH) Access

1. Check for an existing key:

   ```bash
   ls ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub
   ```

2. If absent, generate one (same on macOS/WSL/Linux):

   ```bash
   ssh-keygen -t ed25519 -C "you@example.com"
   # press Enter to accept defaults
   ```

3. Start agent and add the key:

   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

4. Copy the **entire** public key (single line, no BEGIN/END):

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

5. Add it to GitHub: Settings → SSH and GPG keys → New SSH key → paste → save.
6. Test:

   ```bash
   ssh -T git@github.com
   ```

7. Clone with SSH:

   ```bash
   cd ~
   git clone git@github.com:<owner>/<repo>.git dotfiles
   ```

## Usage

### macOS

```bash
# Apply configuration on macOS
darwin-rebuild switch --flake ~/.config/nix-darwin#mac

# Or if you're in the nix-darwin directory
darwin-rebuild switch --flake .#mac
```

### Fresh macOS Bootstrap

The goal is to get a brand-new Mac to the point where `darwin-rebuild switch --flake ~/dotfiles/nix-darwin#mac` works. The steps below assume Apple Silicon. For an automated run, execute `./scripts/bootstrap-macos.sh` from this repo—it walks through the same steps and stops if manual intervention is required.

1. **Clone this repository to ~/dotfiles**

   ```bash
   cd ~
   git clone <repo-url> dotfiles
   ```

2. **Install Apple tooling**

   ```bash
   xcode-select --install
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

**Note:** Fish shell is set as the default automatically by the bootstrap script. If you need to set it manually (e.g., after a fresh darwin-rebuild without the bootstrap script), run:

```bash
chsh -s /run/current-system/sw/bin/fish
```

### Linux/WSL

Use the helper script (assumes repo is cloned to `~/dotfiles`):

```bash
cd ~/dotfiles/nix-darwin
./scripts/bootstrap-linux.sh
```

What the script does:

- Installs Nix via the Determinate Systems installer if missing
- Runs home-manager with the right flake attribute (passes `--extra-experimental-features "nix-command flakes"` and `-b backup` for safe backups):
  - `blancpain@linux` for `x86_64`
  - `blancpain@linux-aarch64` for `aarch64`
    After `home-manager switch`, your `~/.config/nix` will be symlinked from this repo (via `home-manager/common.nix`), so we don't touch `nix.conf` during bootstrap.

Note: the Linux outputs in this flake are home-manager-only (for WSL/regular Linux). `linux-configuration.nix` is a reference system module; to use it you’d need to add a `nixosConfigurations` entry and rebuild with `nixos-rebuild`. All CLI tools (including fish) are pulled in via home-manager for WSL/Linux.

Manual equivalent:

```bash
# Install Nix (multi-user)
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Apply configuration (x86_64)
cd ~/dotfiles/nix-darwin
nix run --extra-experimental-features "nix-command flakes" home-manager/master -- switch -b backup --flake .#blancpain@linux

# For ARM (aarch64)
nix run --extra-experimental-features "nix-command flakes" home-manager/master -- switch -b backup --flake .#blancpain@linux-aarch64
```

Optional (once per machine): add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf` so you don't need to pass `--extra-experimental-features` manually.

The Linux/WSL equivalent of `darwin-rebuild switch --flake .#mac` is `home-manager switch --flake .#<attr>` (or the `nix run home-manager/master -- switch --flake ...` form above). On NixOS, system-level changes use `sudo nixos-rebuild switch --flake .#<hostname>`.

## Configuration Details

### Common Packages (Both Platforms)

- `home-manager/common.nix`: User-level packages and dotfiles (installed per-user)
  - CLI tools and development utilities
  - Shared symlinks for nvim, tmux, fish, starship, etc.
- `system/common-packages.nix`: System-level packages (installed system-wide)
  - Available to all users on macOS and Linux

### macOS-Specific

Located in `home-manager/darwin.nix` and `darwin-configuration.nix`:

### Linux-Specific

Located in `home-manager/linux.nix`:

### NixOS-Specific

Located in `linux-configuration.nix` and `networking.nix`:

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

### Fixing yabai + skhd Accessibility Permissions on macOS (Nix)

This guide documents how to inspect and clean `TCC.db` (macOS Accessibility permissions database) when using **yabai** and **skhd** installed via **Nix**, especially when stale or duplicate `/nix/store` or Homebrew paths exist.

#### 1️⃣ Check existing TCC Accessibility entries

```bash
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
"SELECT rowid, client, auth_value
FROM access
WHERE service = 'kTCCServiceAccessibility'
ORDER BY client;"
```

Interpretation:

- `auth_value = 2` → allowed
- `auth_value = 0` → denied (stale/not approved)
- We want only one allowed entry per binary (yabai + skhd)

#### 2️⃣ Determine current binaries via Nix-darwin

```bash
which yabai
which skhd
readlink -f "$(which yabai)"
readlink -f "$(which skhd)"
```

The `readlink -f` results show the **actual live binaries**. Those are the entries you must keep and authorize.

#### 3️⃣ Backup the TCC database (critical!)

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

#### 4️⃣ Delete stale yabai/skhd entries

Replace the rowids with those that:

- do NOT match the `readlink -f` results
- are old Homebrew or older Nix-store paths
- have `auth_value = 0` or outdated path

_Example_:

```bash
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
"DELETE FROM access WHERE rowid IN (270,272);"
```

#### 5️⃣ Enable correct (current) binaries

Update the _correct_ yabai + skhd paths to `auth_value = 2`:

_Example_:

```bash
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
"UPDATE access SET auth_value = 2 WHERE rowid IN (274,275);"

```

#### 6️⃣ Verify final state

```bash
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
"SELECT rowid, client, auth_value
FROM access
WHERE client LIKE '%yabai%' OR client LIKE '%skhd%';"
```

Expect:

- Exactly _two_ rows: one yabai, one skhd
- Both `auth_value = 2`
- Both matching your `readlink -f` paths

Example expected output:

```bash
274|/nix/store/...yabai|2
275|/nix/store/...skhd|2

```

#### 7️⃣ Reboot and confirm

After reboot:

- yabai window tiling works
- skhd keybindings function
- No duplicate permission entries remain
- No popups needed — launchd services will run cleanly

#### Notes

| Issue                              | Cause                         | Fix                                 |
| ---------------------------------- | ----------------------------- | ----------------------------------- |
| No popup appears for Accessibility | launchd starts apps too early | Force-enable via SQL (Step 5)       |
| Nix updates create new paths       | store path changed            | Repeat process — takes <1 min       |
| Homebrew yabai still appears       | Old installation              | Delete TCC row + uninstall Brew pkg |

**Important**: yabai/skhd may not appear in System Settings → Accessibility because they are CLI binaries, not `.app` bundles. This is expected and fine.

## Resources

- [Nix Darwin Documentation](https://github.com/LnL7/nix-darwin)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Package Search](https://search.nixos.org/packages)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
