{
  description = "Riced NixOS with HyprLand";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs = { self, nixpkgs, nixos-hardware, home-manager, catppuccin, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.rice-machine = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Hardware configuration (generate this with nixos-generate-config)
        ./nixos/hardware-configuration.nix
        # Main system configuration
        ./nixos/configuration.nix
        # Hyprland module
        ./nixosModules/hyprland.nix
        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.rsanchez = import ./homeModules/riced.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    # Add Surface Go 2 work configuration
    nixosConfigurations.surface-work = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Surface hardware support
        nixos-hardware.nixosModules.microsoft-surface-go
        # Hardware configuration (generate this on the Surface)
        ./nixos/surface-hardware-configuration.nix
        # Same system configuration
        ./nixos/configuration.nix
        # Same Hyprland setup
        ./nixosModules/hyprland.nix
        # Same Home Manager setup
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.rsanchez = import ./homeModules/riced.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.backupFileExtension = "backup";
          # Set hostname for work machine
          networking.hostName = "surface-work";
        }
      ];
    };

    # Add installer configuration
    nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        {
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
          # Override conflicting bootloader options
          boot.loader.grub.enable = nixpkgs.lib.mkForce false;
          boot.loader.systemd-boot.enable = nixpkgs.lib.mkForce false;
          # Add your user for convenience during installation
          users.users.rsanchez = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" ];
            # Uncomment and set a password if you want
            # password = "nixos";
          };
        }
      ];
    };
  };
}
