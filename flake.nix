{
  description = "A JS/TS Linter image built with NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = eachSystem (pkgs: {
        helloWorld = pkgs.dockerTools.buildImage (import ./docker-images/helloWorld.nix pkgs);
        default = self.packages.${pkgs.system}.helloWorld;
      });

      apps = eachSystem (pkgs: {
        inherit (import ./scripts/runDefaultDocker.nix pkgs) runDefault buildDefault;
      });
    };
}
