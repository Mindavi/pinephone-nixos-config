{
  description = "Pinephone NixOS config";

  inputs.nixpkgs = {
    url = "github:samueldr/nixpkgs/feature/plasma-mobile";
    #url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  inputs.nixpkgs-cross = {
    url = "github:NixOS/nixpkgs/6ad93ecdbb115566d66b7a04b914e7ac3d780cd9";
  };

  inputs.mobile-nixos = {
    url = "github:NixOS/mobile-nixos/master";
    flake = false;
  };

  inputs.mobile-nixos-cross = {
    url = "github:Mindavi/mobile-nixos/wip-pinephone";
    flake = false;
  };

  outputs = { self, nixpkgs, mobile-nixos, nixpkgs-cross, mobile-nixos-cross }: {
    nixosConfigurations.pinephone-nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./pinephone-configuration.nix ];
      specialArgs = { inherit mobile-nixos; };
    };
    nixosConfigurations.pinephone-nixos-cross = nixpkgs-cross.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./pinephone-configuration-cross.nix ];
      specialArgs = { mobile-nixos = mobile-nixos-cross; };
    };
  };
}

