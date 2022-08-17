{ ... }:
let
  pkgs' = (import <nixpkgs> {});
  mobileReleaseTools = (import <mobile/lib/release-tools.nix> {
    pkgs = pkgs';
  });

  pp-config-minimal = (mobileReleaseTools.evalWith {
    modules = [ ./pinephone-configuration-cross-minimal.nix ];
    device = "pine64-pinephone";
  });

  pp-config-full = (mobileReleaseTools.evalWith {
    modules = [ ./pinephone-configuration-cross-full.nix ];
    device = "pine64-pinephone";
  });

  # nixos config actually used on pinephone. ('final image')
  pp-config-real = (mobileReleaseTools.evalWith {
    modules = [ ./pinephone-configuration.nix ];
    device = "pine64-pinephone";
  });

  pp-config-minimal-eval = (import <nixpkgs/nixos/lib/eval-config.nix> {
    system = "x86_64-linux";
    modules = [
      ./pinephone-configuration-cross-minimal.nix
      (import <mobile/lib/configuration.nix> { device = "pine64-pinephone"; })
    ];
  });

in {
  minimal-image = pp-config-minimal.config.mobile.outputs.default;
  full-image = pp-config-full.config.mobile.outputs.default;
  minimal-image2 = pp-config-minimal-eval.config.mobile.outputs.default;
  #real-image = pp-config-real.config.mobile.outputs.default;
}

