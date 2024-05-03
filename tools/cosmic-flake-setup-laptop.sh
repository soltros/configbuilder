#!/bin/bash

mkdir -p ~/.flakes/
cd ~/.flakes/
wget https://raw.githubusercontent.com/soltros/configbuilder/main/flakes/flake.nix.laptop -O flake.nix
