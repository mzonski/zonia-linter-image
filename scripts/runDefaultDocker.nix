{ pkgs, ... }:
let
  buildImageHeader = ''
    #!/usr/bin/env bash
    set -e

    IMAGE_PATH="$(nix build --no-link --print-out-paths .#default)"
    IMAGE_SIZE="$(du -h "$IMAGE_PATH" | awk '{print $1}')"
    echo "($IMAGE_SIZE) $IMAGE_PATH "
  '';
in
{
  runDefault = {
    type = "app";
    program = toString (
      pkgs.writeScript "run-default.sh" (
        buildImageHeader
        + ''
          docker load < "$IMAGE_PATH"
          docker run --name hello-world --rm hello-world:latest
        ''
      )
    );
  };
  buildDefault = {
    type = "app";
    program = toString (pkgs.writeScript "build-default.sh" buildImageHeader);
  };
}
