{
  description = "Pinephone NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    mobile-nixos.flake = false;
    #mobile-nixos.url = "github:nixos/mobile-nixos/development";
    # Temporary for now: https://github.com/mobile-nixos/mobile-nixos/issues/734#issuecomment-2272582716
    mobile-nixos.url = "github:Luflosi/mobile-nixos/un-collide-eg25-manager";
  };

  outputs = { self, nixpkgs, mobile-nixos }: {
    nixosConfigurations.pp-rick = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./pinephone-configuration-gnome.nix ];
      specialArgs = { inherit mobile-nixos; };
    };
    nixosConfigurations.pinephone-nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./pinephone-configuration.nix ];
      specialArgs = { inherit mobile-nixos; };
    };
    nixosConfigurations.pinephone-nixos-cross-minimal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./pinephone-configuration-cross-minimal.nix
        (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephone"; })
      ];
    };
    nixosConfigurations.pinephone-nixos-cross-full = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./pinephone-configuration-cross-full.nix
        (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephone"; })
      ];
    };
  };
}

