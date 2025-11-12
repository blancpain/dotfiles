{
  pkgs,
  config,
  lib,
  ...
}:

{
  environment = {
    systemPackages = [
      pkgs.vim
      pkgs.fish
      pkgs.nushell
      pkgs.starship
      pkgs.nixfmt-rfc-style
      pkgs.hub
      pkgs.docker
      pkgs.colima
      pkgs.tmux
      pkgs.ngrok
      pkgs.carapace
      pkgs.pam-reattach
      pkgs.lazygit
      pkgs.skhd
      pkgs.yabai
      pkgs.ncurses
      pkgs.curl
      pkgs.nil
      pkgs.sesh
      pkgs.ghostscript
      pkgs.tectonic
      pkgs.mermaid-cli
      pkgs.imagemagick
    ];

    # NOTE: Custom PAM configuration (see https://write.rog.gr/writing/using-touchid-with-tmux/#leveraging-nix-with-nix-darwin)
    # For enabling touchId in clamshell mode follow: https://linkarzu.com/posts/macos/auth-apple-watch/
    # WARN: comment out the pam_watchid.so on first setup as we need to install the watchid script first!!!
    # otherwise sudo will break
    # alternatively write some scripts for setting everything up

    # watchid script
    etc."pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
      auth       sufficient     pam_watchid.so
    '';

    # Add yabai sudoers configuration
    etc."sudoers.d/yabai".text =
      let
        yabaiPath = "${pkgs.yabai}/bin/yabai";
        hash = builtins.readFile (
          pkgs.runCommand "yabai-hash" { } ''
            printf "%s" "$(sha256sum ${yabaiPath} | cut -d " " -f1)" > $out
          ''
        );
      in
      "${config.system.primaryUser} ALL=(root) NOPASSWD: sha256:${hash} ${yabaiPath} --load-sa";
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = null;

  system.primaryUser = "blancpain";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.blancpain = {
    home = "/Users/blancpain";
  };

  # Set system-wide defaults for certain options.
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain.InitialKeyRepeat = 14;
  };

  # NOTE: can also add an onActivation func to zap all brews/casks that are not in the list
  # Keep only macOS-specific tools and GUI apps in homebrew
  homebrew = {
    enable = true;
    casks = [
      "alfred"
      "arc"
      "1password-cli"
      "1password"
      "obsidian"
      "discord"
      "alt-tab"
      "font-fira-sans"
      "spacelauncher"
      "font-meslo-lg-nerd-font"
      "font-victor-mono"
      "slack"
      "chatgpt"
      "epk/epk/font-sf-mono-nerd-font"
      "karabiner-elements"
      "firefox"
      "appcleaner"
      "mongodb-compass"
      "postman"
      "raindropio"
      "ghostty"
      "zen"
      "google-chrome"
      "iterm2"
      "redis-insight"
      "sequel-ace"
    ];
    brews = [
      "mas" # Mac App Store CLI - macOS only
      "llvm@17"
      "pipx"
      "python-yq"
      "python@3.12"
      "rabbitmq"
      "rust"
      "rust-analyzer"
      "wimlib"
      "zellij"
    ];
    masApps = {
      "Color Picker" = 1545870783;
      "Unzip - RAR ZIP 7Z Unarchiver" = 1537056818;
      "Gifski" = 1351639930;
      "Toggl Track" = 1291898086;
      "Xcode" = 497799835;
      "Spark" = 1176895641;
      "Trello" = 1278508951;
    };
  };
}
