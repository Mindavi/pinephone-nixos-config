#!/usr/bin/env bash

nix build -L .#nixosConfigurations.pinephone-nixos-cross.config.mobile.outputs.default

