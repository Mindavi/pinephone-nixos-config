{
  description = "Pinephone NixOS config";

  inputs.nixpkgs = {
    url = "github:samueldr/nixpkgs/feature/plasma-mobile";
    #url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  inputs.mobile-nixos = {
    url = "github:NixOS/mobile-nixos/master";
    flake = false;
  };

  outputs = { self, nixpkgs, mobile-nixos }: {
    nixosConfigurations.pinephone-nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./pinephone-configuration.nix ];
      specialArgs = { inherit mobile-nixos; };
    };
  };
}

