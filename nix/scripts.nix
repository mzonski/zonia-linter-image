{ pkgs, ... }:
let
  inherit (import ./lib/dockerRuntime.nix pkgs) generateRuntime;
  inherit
    (generateRuntime {
      image_name = "linter-image";
      mounts = [
        {
          local = "$(git rev-parse --show-toplevel)/ugly-testcode";
          remote = "/app/linter/src";
        }
      ];
    })
    run
    buildAndRun
    build
    ;
in
{
  runLinterDocker = run;
  buildAndRunLinterDocker = buildAndRun;
  buildLinterDocker = build;
}
