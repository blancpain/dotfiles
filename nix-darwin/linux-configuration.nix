{
  pkgs,
  config,
  lib,
  ...
}:

{
  # For WSL/Linux, we primarily use home-manager for user-level configuration
  # This file contains system-level packages that would be available

  environment.systemPackages = with pkgs; [
    automake
    bat
    bottom
    btop
    carapace
    cloc
    cloudflared
    curl
    docker
    fastfetch
    fd
    ffmpegthumbnailer
    fish
    flyctl
    fnm
    fzf
    gdu
    gh
    gifsicle
    git
    gnused
    go
    gnumake
    helix
    hub
    httpie
    imagemagick
    jq
    lazydocker
    lazygit
    llvmPackages_latest.clang
    luajitPackages.lpeg
    ngrok
    nil
    nixfmt-rfc-style
    perl538Packages.Appcpanminus
    pgcli
    php
    poppler-utils
    python311
    rabbitmq-server
    redis
    ripgrep
    rustup
    starship
    tmux
    tree
    unar
    wget
    yazi
    zoxide
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # WSL-specific configurations
  # Note: For WSL, you might want to use NixOS-WSL
  # See: https://github.com/nix-community/NixOS-WSL
}
