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
  #NOTE: rm this overlay when fish test phase is fixed in nixpkgs
  nixpkgs.overlays = [
    (final: prev: {
      fish = prev.fish.overrideAttrs (old: {
        # disable test/check phase that’s failing
        doCheck = false;
        # just in case, override explicit checkPhase too
        checkPhase = "true";
      });
    })
  ];

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

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = null;

  system.primaryUser = "blancpain";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Enable fish shell
  programs.fish.enable = true;

  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.watchIdAuth = true;

  users.users.blancpain = {
    home = "/Users/blancpain";
    shell = pkgs.fish;
  };

  environment.shells = [ pkgs.fish ];

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
    taps = [
      "1password/tap"
      "epk/epk"
    ];
    casks = [
      "alfred"
      "arc"
      "1password-cli"
      "1password"
      "obsidian"
      "discord"
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
      "google-chrome"
      "redis-insight"
      "spotify"
    ];
    brews = [
      "mas" # Mac App Store CLI
      "bob"
    ];
    masApps = {
      "Unzip - RAR ZIP 7Z Unarchiver" = 1537056818;
      "Gifski" = 1351639930;
      "Toggl Track" = 1291898086;
      "Xcode" = 497799835;
      "Spark" = 1176895641;
      "Trello" = 1278508951;
    };
  };
}
