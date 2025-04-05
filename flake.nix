{
  description = "A JS/TS Linter image built with NixOS";

  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    nixpkgs.follows = "dream2nix/nixpkgs";
  };

  outputs =
    {
      self,
      dream2nix,
      nixpkgs,
      ...
    }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (pkgs: {
        default = self.devShells.${pkgs.system}.linterNode;
        linterNode = import ./js-packages/linter/nix/devShell.nix {
          inherit (pkgs) mkShell;
          linter = self.packages.${pkgs.system}.linter-node;
          nodejs = pkgs.nodejs_22;
        };
      });

      packages = eachSystem (
        pkgs:
        let
          linter = dream2nix.lib.evalModules {
            packageSets.nixpkgs = nixpkgs.legacyPackages.${pkgs.system};
            modules = [
              ./js-packages/linter/nix/config.nix
              {
                paths.projectRoot = ./.;
                paths.projectRootFile = "flake.nix";
                paths.package = ./.;
              }
            ];
          };
        in
        {
          default = self.packages.${pkgs.system}.linter-image;

          hello-world-image = pkgs.dockerTools.buildImage (import ./docker-images/helloWorld.nix pkgs);
          linter-image = pkgs.dockerTools.buildImage (
            import ./docker-images/linter.nix {
              inherit pkgs linter;
              nodejs = pkgs.nodejs_22;
            }
          );
          linter-node = linter;
        }
      );

      apps = eachSystem (pkgs: {
        default = self.apps.${pkgs.system}.buildAndRunLinterDocker;

        inherit (import ./scripts/runDefaultDocker.nix pkgs) runDefault buildDefault;
        inherit (import ./scripts/linter.nix pkgs)
          runLinterDocker
          buildLinterDocker
          buildAndRunLinterDocker
          ;
      });
    };
}
