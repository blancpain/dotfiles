#NOTE: see `https://discourse.nixos.org/t/any-nix-darwin-nushell-users/37778/2` for nushell
# https://nixos.wiki/wiki/Nushell

{
  description = "Cross-platform system flake for macOS and Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    {
      # macOS configurations using nix-darwin
      darwinConfigurations = {
        # You can add any hostname here and the configuration will work
        "Yasens-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.blancpain = import ./home-manager/darwin.nix;
            }
          ];
        };

        "Yasens-Mac-mini" = nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.blancpain = import ./home-manager/darwin.nix;
            }
          ];
        };
      };

      # Linux/WSL configurations using home-manager standalone
      homeConfigurations = {
        # For WSL or any Linux system, use: home-manager switch --flake .#blancpain@linux
        "blancpain@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home-manager/linux.nix ];
        };

        # If you need ARM Linux (e.g., Raspberry Pi or ARM VM)
        "blancpain@linux-aarch64" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [ ./home-manager/linux.nix ];
        };
      };
    };
}
