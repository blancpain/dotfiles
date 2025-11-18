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
in
{
  home.username = "blancpain";
  home.homeDirectory = lib.mkDefault baseHomeDir;
  home.stateVersion = "25.05";

  # No shared package list; per-OS packages are managed in each system module.
  home.packages = [ ];

  # Ensure ~/.nix-profile always points at the multi-user profile that nix-darwin builds.
  home.activation.ensureNixProfileSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="/etc/profiles/per-user/${config.home.username}"
    if [ -e "$target" ]; then
      if [ ! -L "$HOME/.nix-profile" ] || [ "$(${pkgs.coreutils}/bin/readlink "$HOME/.nix-profile")" != "$target" ]; then
        ${pkgs.coreutils}/bin/ln -sfn "$target" "$HOME/.nix-profile"
      fi
    fi
  '';

  # Common symlinks for configuration files
  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/wezterm";
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
    ".config/nix".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nix";
    ".config/nix-darwin".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nix-darwin";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux";
    ".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/lazygit";
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
