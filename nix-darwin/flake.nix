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
    let
      # Resolve the current user dynamically so the config works for any user.
      # SUDO_USER is checked first because darwin-rebuild typically runs under sudo.
      # Requires the --impure flag on rebuild commands.
      envUser = builtins.getEnv "USER";
      envSudoUser = builtins.getEnv "SUDO_USER";
      username =
        if envSudoUser != "" then envSudoUser
        else if envUser != "" then envUser
        else "blancpain";
    in
    {
      # macOS configurations using nix-darwin
      darwinConfigurations = {
        # Single macOS configuration; pick this attr when switching
        mac = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit username; };
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username; };
              home-manager.users.${username} = import ./home-manager/darwin.nix;
            }
          ];
        };
      };

      # NixOS configurations using nixpkgs.lib.nixosSystem
      nixosConfigurations = {
        # For NixOS systems, use: sudo nixos-rebuild switch --impure --flake .#nixos
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit username; };
          modules = [
            ./linux-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username; };
              home-manager.users.${username} = import ./home-manager/linux.nix;
            }
          ];
        };

        # ARM NixOS (e.g., Raspberry Pi)
        nixos-aarch64 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit username; };
          modules = [
            ./linux-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username; };
              home-manager.users.${username} = import ./home-manager/linux.nix;
            }
          ];
        };
      };

      # Linux/WSL configurations using home-manager standalone
      homeConfigurations = {
        # For WSL or any Linux system, use: home-manager switch --impure --flake .#$USER@linux
        "${username}@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit username; };
          modules = [ ./home-manager/linux.nix ];
        };

        # If you need ARM Linux (e.g., Raspberry Pi or ARM VM)
        "${username}@linux-aarch64" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit username; };
          modules = [ ./home-manager/linux.nix ];
        };
      };
    };
}
