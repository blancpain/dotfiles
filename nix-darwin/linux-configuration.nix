{
  pkgs,
  config,
  lib,
  ...
}:

let
  commonSystemPackages = import ./system/common-packages.nix { inherit pkgs; };
  username = "blancpain";
  homeDir = "/home/${username}";
in

{
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.fish.enable = true;

  environment = {
    systemPackages = commonSystemPackages;
    shells = [ pkgs.fish ];
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.${username} = {
      isNormalUser = true;
      home = homeDir;
      description = username;
      shell = pkgs.fish;
      extraGroups = [ "wheel" ];
    };
  };

  # Set the persisted system version; adjust if you target a different NixOS release.
  system.stateVersion = lib.mkDefault "24.05";
}
