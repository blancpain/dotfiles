{
  pkgs,
  config,
  lib,
  username,
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

  system.primaryUser = username;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  # security.pam.services.sudo_local.watchIdAuth = true;  # TODO: re-enable when Swift cache is fixed upstream (pam-watchid requires Swift)

  users.users.${username} = {
    home = "/Users/${username}";
  };

  # Add fish as a login shell
  environment.shells = [ pkgs.fish ];

  # Set system-wide defaults for certain options.
  system.defaults = {

    dock = {
      autohide = true; # auto-hide the Dock
      largesize = 128; # icon size when magnified
      magnification = true; # enlarge icons on hover
      mru-spaces = false; # don't auto-rearrange Spaces based on recent use
      orientation = "bottom"; # Dock position on screen
      show-recents = false; # hide recent apps section in Dock
      # Hot corners (1=disabled, 5=Start Screen Saver)
      wvous-bl-corner = 1; # bottom-left: disabled
      wvous-br-corner = 5; # bottom-right: start screen saver
      wvous-tl-corner = 1; # top-left: disabled
      wvous-tr-corner = 1; # top-right: disabled
    };

    finder = {
      AppleShowAllExtensions = true; # always show file extensions
      ShowPathbar = true; # show path breadcrumbs at bottom of Finder
      ShowStatusBar = false; # hide status bar at bottom of Finder
    };

    screencapture.location = "~/Documents/Screenshots"; # save screenshots here

    # Stage Manager disabled, tiling disabled (using yabai)
    WindowManager = {
      GloballyEnabled = false; # disable Stage Manager
      AppWindowGroupingBehavior = true; # group windows by app when showing
      AutoHide = false; # don't auto-hide Stage Manager strip
      EnableTiledWindowMargins = false; # no margins when tiling windows
      EnableTilingByEdgeDrag = false; # disable drag-to-edge tiling
      EnableTilingOptionAccelerator = false; # disable Option-key tiling accelerator
      EnableTopTilingByEdgeDrag = false; # disable drag-to-top-edge fullscreen
      HideDesktop = true; # hide desktop items when clicking wallpaper
      StageManagerHideWidgets = false; # don't hide widgets in Stage Manager
      StandardHideWidgets = true; # hide widgets when not on desktop
    };

    trackpad = {
      Clicking = true; # tap to click
    };

    NSGlobalDomain = {
      # Keyboard
      KeyRepeat = 1; # key repeat rate (lower = faster)
      InitialKeyRepeat = 14; # delay before key repeat starts (lower = shorter)
      ApplePressAndHoldEnabled = false; # disables accent menu, enables key repeat
      "com.apple.keyboard.fnState" = false; # Fn key shows special keys, not F1-F12
      # Appearance
      AppleInterfaceStyle = "Dark"; # dark mode
      AppleFontSmoothing = 0; # disable sub-pixel font smoothing
      # Scrolling & navigation
      "com.apple.swipescrolldirection" = false; # non-natural (traditional) scrolling
    };

    # Settings without direct nix-darwin typed options
    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleKeyboardUIMode = 1; # keyboard access for dialogs (bitmask: 1=dialogs, 2=all controls, 3=both)
        "com.apple.mouse.scaling" = 1.5; # mouse tracking speed
        "com.apple.scrollwheel.scaling" = 1; # scroll wheel speed
      };
    };
  };

  # NOTE: can also add an onActivation func to zap all brews/casks that are not in the list
  # Keep only macOS-specific tools and GUI apps in homebrew
  homebrew = {
    enable = true;
    taps = [
    ];
    casks = [
      "1password-cli"
      "1password"
      "obsidian"
      "discord"
      "google-chrome"
      "hammerspoon"
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
      "raycast"
    ];
    brews = [
      "mas" # Mac App Store CLI
      "bob"
    ];
    masApps = {
      "Unzip - RAR ZIP 7Z Unarchiver" = 1537056818;
      "Gifski" = 1351639930;
      "Toggl Track" = 1291898086;
      "Klack" = 6446206067;
    };
  };
}
