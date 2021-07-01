#!/usr/bin/env bash

nixos-rebuild build -I nixos-config=./pinephone-configuration.nix -I nixpkgs=./nixpkgs -I mobile-nixos=./mobile-nixos

