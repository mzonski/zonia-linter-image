{ pkgs, ... }:
{
  generateRuntime =
    {
      image_name,
      mount_local,
      mount_remote,
    }:
    let
      inherit (import ./bash.nix { }) userBashHeaderEE;
      buildImageHeader = (
        userBashHeaderEE
        + ''
          IMAGE_PATH="$(nix build --no-link --print-out-paths .#${image_name})"
          IMAGE_SIZE="$(du -h "$IMAGE_PATH" | awk '{print $1}')"
          echo "($IMAGE_SIZE) $IMAGE_PATH "
        ''
      );
    in
    {
      buildAndRun = {
        type = "app";
        program = toString (
          pkgs.writeScript "run-${image_name}.sh" (
            buildImageHeader
            + ''
              docker load < "$IMAGE_PATH"
              docker run --name ${image_name} --rm ${image_name}:latest
            ''
            + (pkgs.lib.optionalString (mount_local != "" && mount_remote != "") ''
              docker run -v ${mount_local}:${mount_remote} --name ${image_name} --rm ${image_name}:latest
            '')
          )
        );
      };
      run = {
        type = "app";
        program = toString (
          pkgs.writeScript "run-${image_name}.sh" (
            userBashHeaderEE
            + (
              if (mount_local != "" && mount_remote != "") then
                "docker run -v ${mount_local}:${mount_remote} --name ${image_name} --rm ${image_name}:latest"
              else
                "docker run --name ${image_name} --rm ${image_name}:latest"
            )
          )
        );
      };
      build = {
        type = "app";
        program = toString (pkgs.writeScript "build-${image_name}.sh" buildImageHeader);
      };
    };
}
