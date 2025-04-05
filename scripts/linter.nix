{ pkgs, ... }:
let
  inherit (import ../lib/dockerApp.nix pkgs) generateRuntime;
  inherit
    (generateRuntime {
      image_name = "linter-image";
      mount_local = "$(git rev-parse --show-toplevel)/js-packages/ugly-ts";
      mount_remote = "/app/linter/src";
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
