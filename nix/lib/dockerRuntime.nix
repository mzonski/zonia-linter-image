# docker-runtime.nix
{
  pkgs,
  lib ? pkgs.lib,
  ...
}:

let
  inherit (lib) concatStringsSep optionalString;
  inherit (import ./bash.nix { }) userBashHeaderEE;
in
{
  generateRuntime =
    {
      image_name,
      mounts ? [ ],
      docker_args ? "",
      tag ? "latest",
    }:
    let
      getMountArg = mount: "-v ${mount.local}:${mount.remote}";
      volumeArgs = concatStringsSep " " (map getMountArg mounts);

      dockerRunCmd = ''
        docker run \
          --name ${image_name} \
          ${optionalString (volumeArgs != "") volumeArgs} \
          ${docker_args} \
          --rm \
          ${image_name}:${tag}
      '';

      buildImageCmd = ''
        echo "Building ${image_name}:${tag}..."
        IMAGE_PATH="$(nix build --no-link --print-out-paths .#${image_name})"

        if [ $? -ne 0 ]; then
          echo "Error: Failed to build ${image_name}" >&2
          exit 1
        fi

        IMAGE_SIZE="$(du -h "$IMAGE_PATH" | awk '{print $1}')"
        echo "Built image ($IMAGE_SIZE): $IMAGE_PATH"
      '';

      loadImageCmd = ''
        echo "Loading image into Docker..."
        docker load < "$IMAGE_PATH"

        if [ $? -ne 0 ]; then
          echo "Error: Failed to load image into Docker" >&2
          exit 1
        fi
      '';
    in
    {

      buildAndRun = {
        type = "app";
        program = toString (
          pkgs.writeScript "build-run-${image_name}.sh" (
            userBashHeaderEE
            + ''
              ${buildImageCmd}
              ${loadImageCmd}

              echo "Starting container..."
              ${dockerRunCmd}
            ''
          )
        );
      };

      run = {
        type = "app";
        program = toString (
          pkgs.writeScript "run-${image_name}.sh" (
            userBashHeaderEE
            + ''
              echo "Starting container..."
              ${dockerRunCmd}
            ''
          )
        );
      };

      build = {
        type = "app";
        program = toString (
          pkgs.writeScript "build-${image_name}.sh" (
            userBashHeaderEE
            + ''
              ${buildImageCmd}
              ${loadImageCmd}
            ''
          )
        );
      };
    };
}
