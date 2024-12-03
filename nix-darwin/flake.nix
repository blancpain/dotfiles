#NOTE: see `https://discourse.nixos.org/t/any-nix-darwin-nushell-users/37778/2` for nushell
# https://nixos.wiki/wiki/Nushell

{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      configuration =
        { pkgs, ... }:
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
              pkgs.wezterm
              pkgs.tmux
              pkgs.ngrok
              pkgs.carapace
              pkgs.pam-reattach
              pkgs.lazygit
              pkgs.skhd
              pkgs.yabai
            ];

            # NOTE: Custom PAM configuration (see https://write.rog.gr/writing/using-touchid-with-tmux/#leveraging-nix-with-nix-darwin)
            # For enabling touchId in clamshell mode follow: https://linkarzu.com/posts/macos/auth-apple-watch/
            # WARN: comment out the pam_watchid.so on first setup as we need to install the watchid script first
            # otherwise sudo will break
            # alternatively write some scripts for setting everything up

            # watchid script
            etc."pam.d/sudo_local".text = ''
              # Managed by Nix Darwin
              auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
              auth       sufficient     pam_tid.so
              auth       sufficient     pam_watchid.so
            '';

            # NOTE: blancpain is hardcoded as user here
            # Add yabai sudoers configuration
            # etc."sudoers.d/yabai".text = ''blancpain ALL=(root) NOPASSWD: sha256:4440221a5afa923f12b428689b9eadeaaf902a12b14cf0a30b9fd1737405df06 /run/current-system/sw/bin/yabai --load-sa''; # Note: no newline at the end

            etc."sudoers.d/yabai".text =
              let
                yabaiPath = "${pkgs.yabai}/bin/yabai";
                hash = builtins.readFile (
                  pkgs.runCommand "yabai-hash" { } ''
                    printf "%s" "$(sha256sum ${yabaiPath} | cut -d " " -f1)" > $out
                  ''
                );
              in
              "blancpain ALL=(root) NOPASSWD: sha256:${hash} ${yabaiPath} --load-sa";

          };

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnfree = true;

          security.pam.enableSudoTouchIdAuth = true;

          users.users.blancpain = {
            home = "/Users/blancpain";
          };
          home-manager.backupFileExtension = "backup";

          # Set system-wide defaults for certain options.
          system.defaults = {
            dock.autohide = true;
            finder.AppleShowAllExtensions = true;
            finder.FXPreferredViewStyle = "clmv";
            NSGlobalDomain.KeyRepeat = 1;
            NSGlobalDomain.InitialKeyRepeat = 14;
          };

          homebrew = {
            enable = true;
            casks = [
              "alfred"
              "1password-cli"
              "obsidian"
              "1password"
              "alt-tab"
              "font-fira-sans"
              "spacelauncher"
              "font-meslo-lg-nerd-font"
              "font-victor-mono"
              "slack"
              "gstreamer-runtime"
              "iterm2"
              "sequel-ace"
              "chatgpt"
              "epk/epk/font-sf-mono-nerd-font"
              # "nikitabobko/tap/aerospace"
              "karabiner-elements"
              "firefox"
              "appcleaner"
              "mongodb-compass"
              "postman"
              "raindropio"
            ];
            brews = [
              "mas"
              "automake"
              "bat"
              "bob"
              "bottom"
              "btop"
              "cloc"
              "cloudflared"
              "cpanminus"
              "fastfetch"
              "fd"
              "ffmpegthumbnailer"
              "flyctl"
              "fnm"
              "fzf"
              "gdu"
              "gh"
              "gifsicle"
              "git"
              "gnu-sed"
              "go"
              "helix"
              "httpie"
              "jq"
              "llvm@17"
              "lpeg"
              "make"
              "mycli"
              "php"
              "pngpaste"
              "poppler"
              "python@3.11"
              "rabbitmq"
              "redis"
              "ripgrep"
              "rust"
              "rust-analyzer"
              "rustup"
              "tldr"
              "tree"
              "unar"
              "wget"
              "yazi"
              "zoxide"
            ];
            masApps = {
              "Color Picker" = 1545870783;
              "Unzip - RAR ZIP 7Z Unarchiver" = 1537056818;
              "Gifski" = 1351639930;
              "Toggl Track" = 1291898086;
              "Xcode" = 497799835;
              "Spark" = 1176895641;
              "Trello" = 1278508951;
              "Things 3" = 904280696;
            };
          };
        };
      # Build darwin flake using:
      mkDarwinSystem =
        hostname:
        nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.blancpain = import ./home.nix;
            }
          ];
        };
    in
    {

      darwinConfigurations = {
        # You can add any hostname here and the configuration will work
        "Yasens-MacBook-Pro" = mkDarwinSystem "Yasens-MacBook-Pro";
        "Yasens-Mac-mini" = mkDarwinSystem "Yasens-Mac-mini";
      };

      # Expose the package set, including overlays, for convenience.
      # TODO: see how we can make hostname agnostic
      # darwinPackages = self.darwinConfigurations."Yasens-MacBook-Pro".pkgs;
    };
}
