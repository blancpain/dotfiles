{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Resolve dotfiles relative to the user's home directory so it works on any platform.
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  baseHomeDir =
    if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
  linuxOnlyPackages = with pkgs; [
    rabbitmq-server
  ];
in
{
  home.username = "blancpain";
  home.homeDirectory = lib.mkDefault baseHomeDir;
  home.stateVersion = "23.05";

  # Common packages available on both macOS and Linux
  home.packages =
    (with pkgs; [
      # Development tools
      lazydocker
      automake
      bat
      bob
      bottom
      btop
      cloc
      cloudflared
      perl538Packages.Appcpanminus
      fastfetch
      fd
      ffmpegthumbnailer
      flyctl
      fnm
      fzf
      gdu
      gh
      gifsicle
      git
      gnused
      go
      helix
      httpie
      jq
      llvmPackages_latest.clang
      luajitPackages.lpeg
      gnumake
      pgcli
      php
      poppler-utils
      python311
      redis
      ripgrep
      rustup
      tree
      unar
      wget
      yazi
      zoxide
    ])
    ++ lib.optionals pkgs.stdenv.isLinux linuxOnlyPackages;

  # Common symlinks for configuration files
  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/wezterm";
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
    ".config/nix".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nix";
    ".config/nix-darwin".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nix-darwin";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux";
    ".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/lazygit";
    ".config/nushell".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nushell";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/fish";
    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/helix";
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/yazi";
    ".aider.conf.yml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/aider/.aider.conf.yml";
  };

  home.sessionVariables = { };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs = {
    # Add common program configurations here
  };
}
