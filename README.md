# zonia-linter-image

This repository contains a flake and Node/ESLint project created to build and deploy a linter Docker image for CI/CD environments using NixOS.

## Prerequisites:
Nix package manager installed on your system

## Commands:
- `nix run .#buildLinterDocker` - build and register linter docker image
- `nix run .#runLinterDocker` - run already built and registered linter docker image
- `nix run .#buildAndRunLinterDocker` - build, register and run linter docker image
