{
  pkgs,
  config,
  lib,
  ...
}:

let
  commonSystemPackages = import ./system/common-packages.nix { inherit pkgs; };
in

{
  # For WSL/Linux, we primarily use home-manager for user-level configuration
  # This file contains system-level packages that would be available

  environment.systemPackages = commonSystemPackages;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # WSL-specific configurations
  # Note: For WSL, you might want to use NixOS-WSL
  # See: https://github.com/nix-community/NixOS-WSL
}
