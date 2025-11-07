{
  config,
  pkgs,
  lib,
  ...
}:

let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
in
{
  imports = [ ./common.nix ];

  # Override home directory for Linux
  home.homeDirectory = lib.mkForce "/home/blancpain";

  # Linux-specific packages
  home.packages = with pkgs; [
    # Add any Linux-specific packages here
    # For WSL, you might want to add:
    # wslu # WSL utilities (if available in nixpkgs)
  ];

  # Linux-specific configurations
  home.file = {
    # Add Linux-specific symlinks here if needed
    # Note: Some macOS-specific tools (aerospace, karabiner, yabai, skhd) won't work on Linux
    # Code/Cursor paths are different on Linux
    ".config/Code/User".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Code/User";
    ".config/Cursor/User".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Cursor/User";
    ".config/Windsurf/User".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Windsurf/User";
  };

  # WSL-specific session variables
  home.sessionVariables = {
    # Add any WSL-specific variables here
  };
}
