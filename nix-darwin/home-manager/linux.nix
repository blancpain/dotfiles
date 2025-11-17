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

  # Avoid clobbering existing dotfiles; back them up with a .backup suffix.
  home-manager.backupFileExtension = "backup";

  # Override home directory for Linux
  home.homeDirectory = lib.mkForce "/home/blancpain";

  # Linux-specific packages that aren't needed on macOS
  home.packages = with pkgs; [
    # Add Linux specific nix pkgs here
  ];

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
}
