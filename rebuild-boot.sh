#!/usr/bin/env bash

sudo nixos-rebuild boot -I nixos-config=./pinephone-configuration.nix -I nixpkgs=./nixpkgs -I mobile-nixos=./mobile-nixos

