{
  config,
  pkgs,
  lib,
  ...
}:

let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  # Reuse the shared system package list here because the Linux flake output only
  # applies home-manager (no system module). For NixOS, you'd wire
  # nix-darwin/linux-configuration.nix into a nixosConfiguration instead.
  commonSystemPackages = import ../system/common-packages.nix { inherit pkgs; };
in
{
  imports = [ ./common.nix ];

  nixpkgs.config.allowUnfree = true;

  # Align with the actual HOME in WSL/Linux to avoid “outside $HOME” install errors.
  home.homeDirectory = lib.mkForce (builtins.getEnv "HOME");

  # Linux-specific packages that aren't needed on macOS
  home.packages = commonSystemPackages;

  # Linux-specific configurations
  home.file = {
    # Add Linux-specific symlinks here if needed
    # Note: Some macOS-specific tools (aerospace, karabiner, yabai, skhd) won't work on Linux
    # Code/Cursor paths are different on Linux
    ".config/Code/User".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Code/User";
    ".config/Cursor/User".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Cursor/User";
    ".config/Windsurf/User".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Windsurf/User";
  };

  # WSL-specific session variables
  home.sessionVariables = {
    # Add any WSL-specific variables here
  };

  programs.fish.enable = true;
}
