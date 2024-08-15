{
  description = "Pinephone NixOS config";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Temporary for now: https://github.com/mobile-nixos/mobile-nixos/issues/734#issuecomment-2272582716
    nixpkgs.url = "github:NixOS/nixpkgs/9f4128e00b0ae8ec65918efeba59db998750ead6";

    mobile-nixos.flake = false;
    mobile-nixos.url = "github:mobile-nixos/mobile-nixos/development";
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

