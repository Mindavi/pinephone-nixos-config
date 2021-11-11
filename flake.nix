{
  description = "Pinephone NixOS config";

  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs/b165ce0c4efbb74246714b5c66b6bcdce8cde175";
    #url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

