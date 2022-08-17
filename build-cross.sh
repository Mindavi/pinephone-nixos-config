#!/usr/bin/env bash

# Due to env var, impure must be enabled.
# Unfree is required due to unfree firmware for the pinephone.
#export NIXPKGS_ALLOW_UNFREE=1
nix build -L .#nixosConfigurations.pinephone-nixos-cross-full.config.mobile.outputs.default --keep-going
#nix build -L .#nixosConfigurations.pinephone-nixos-cross-minimal.config.mobile.outputs.default --keep-going

