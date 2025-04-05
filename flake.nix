{
  description = "A JS/TS Linter image built with Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    dream2nix.url = "github:nix-community/dream2nix";
    dream2nix.inputs.nixpkgs.follows = "nixpkgs";
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
        linterNode = import ./nix/devShell.nix {
          inherit (pkgs) mkShell;
          linter = self.packages.${pkgs.system}.linter-node;
          nodejs = pkgs.nodejs_23;
        };
      });

      packages = eachSystem (
        pkgs:
        let
          linter = dream2nix.lib.evalModules {
            packageSets.nixpkgs = nixpkgs.legacyPackages.${pkgs.system};
            modules = [
              ./nix/config.nix
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

          linter-image = pkgs.dockerTools.buildImage (
            import ./nix/docker.nix {
              inherit pkgs linter;
              nodejs = pkgs.nodejs_23;
            }
          );
          linter-node = linter;
        }
      );

      apps = eachSystem (pkgs: {
        default = self.apps.${pkgs.system}.buildAndRunLinterDocker;

        inherit (import ./nix/scripts.nix pkgs)
          runLinterDocker
          buildLinterDocker
          buildAndRunLinterDocker
          ;
      });
    };
}
