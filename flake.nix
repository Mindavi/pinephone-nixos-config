{
  description = "Pinephone NixOS config";

  inputs = {
    nixpkgs.url = "github:dotlambda/nixpkgs/plasma-mobile-gear-21.12";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-cross-official.url = "github:NixOS/nixpkgs/master";
    nixpkgs-cross-fork.url = "github:Mindavi/nixpkgs/pinephone-patches-3";

    mobile-nixos.flake = false;
    #mobile-nixos.url = "github:NixOS/mobile-nixos/master";
    mobile-nixos.url = "github:tomfitzhenry/mobile-nixos/pine64-pinephone-kernel-5.17";
  };

  outputs = { self, nixpkgs, mobile-nixos, nixpkgs-cross-official, nixpkgs-cross-fork }: {
    nixosConfigurations.pinephone-nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./pinephone-configuration.nix ];
      specialArgs = { inherit mobile-nixos; };
    };
    nixosConfigurations.pinephone-nixos-cross-official = nixpkgs-cross-official.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./pinephone-configuration-cross-official.nix
        (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephone"; })
      ];
    };
    nixosConfigurations.pinephone-nixos-cross-fork = nixpkgs-cross-fork.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./pinephone-configuration-cross-fork.nix
        (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephone"; })
      ];
    };
  };
}

