{
  pkgs,
  config,
  lib,
  ...
}:

let
  commonSystemPackages = import ./system/common-packages.nix { inherit pkgs; };
  darwinOnlyPackages = with pkgs; [
    colima
    pam-reattach
    skhd
    yabai
  ];
in
{
  environment = {
    systemPackages = commonSystemPackages ++ darwinOnlyPackages;

    etc."pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
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

  # Disable nix-darwin's Nix management (using Determinate Systems installer)
  # The Determinate installer handles Nix configuration including experimental-features
  nix.enable = false;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = null;

  system.primaryUser = "blancpain";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.watchIdAuth = true;

  users.users.blancpain = {
    home = "/Users/blancpain";
  };

  # Add fish as a login shell
  environment.shells = [ pkgs.fish ];

  # Set system-wide defaults for certain options.
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.AppleFontSmoothing = 0;
  };

  # NOTE: can also add an onActivation func to zap all brews/casks that are not in the list
  # Keep only macOS-specific tools and GUI apps in homebrew
  homebrew = {
    enable = true;
    taps = [
    ];
    casks = [
      "alfred"
      "1password-cli"
      "1password"
      "obsidian"
      "discord"
      "google-chrome"
      "spacelauncher"
      "slack"
      "chatgpt"
      "karabiner-elements"
      "appcleaner"
      "mongodb-compass"
      "postman"
      "raindropio"
      "ghostty"
      "redis-insight"
      "spotify"
      # fonts
      "font-cascadia-code-nf"
      "font-fira-code-nerd-font"
      "font-iosevka-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-hack-nerd-font"
    ];
    brews = [
      "mas" # Mac App Store CLI
      "bob"
    ];
    masApps = {
      "Unzip - RAR ZIP 7Z Unarchiver" = 1537056818;
      "Gifski" = 1351639930;
      "Toggl Track" = 1291898086;
      "Trello" = 1278508951;
    };
  };
}
