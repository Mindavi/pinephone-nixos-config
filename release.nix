{ ... }:
let
  pkgs' = (import <nixpkgs> {
    config.contentAddressedByDefault = true;
  });
  mobileReleaseTools = (import <mobile/lib/release-tools.nix> {
    pkgs = pkgs';
  });

  pp-config-official = (mobileReleaseTools.evalWith {
    modules = [ ./pinephone-configuration-cross-official.nix ];
    device = "pine64-pinephone";
  });

  pp-config-fork = (mobileReleaseTools.evalWith {
    modules = [ ./pinephone-configuration-cross-fork.nix ];
    device = "pine64-pinephone";
  });

in {
  official = pp-config-official;
  official-image = pp-config-official.config.mobile.outputs.default;
  fork = pp-config-fork;
  fork-image = pp-config-fork.config.mobile.outputs.default;
}

