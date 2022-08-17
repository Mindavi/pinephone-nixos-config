{
  description = "Pinephone NixOS config";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixpkgs-cross-fork.url = "github:Mindavi/nixpkgs/pinephone-patches-3";

    mobile-nixos.flake = false;
    mobile-nixos.url = "github:NixOS/mobile-nixos/master";
  };

  outputs = { self, nixpkgs, mobile-nixos, nixpkgs-cross-fork }: {
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
    nixosConfigurations.pinephone-nixos-cross-full = nixpkgs-cross-full.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./pinephone-configuration-cross-full.nix
        (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephone"; })
      ];
    };
  };
}

