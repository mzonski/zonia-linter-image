{ pkgs, ... }:
let
  inherit (pkgs) buildEnv writeScript;
in
{
  name = "hello-world";
  tag = "latest";
  created = "now";

  copyToRoot = buildEnv {
    name = "image-root";
    paths = [ pkgs.bash ];
    pathsToLink = [ "/bin" ];
  };

  runAsRoot =
    let
      hello = writeScript "hello.sh" ''
        #!/bin/bash
        echo "Hello world from Nix Docker container!"
      '';
      runtime = ''
        #!/bin/bash
        mkdir -p /app
        cp ${hello} /app/hello.sh
        chmod +x /app/hello.sh
      '';
    in
    runtime;

  config = {
    Cmd = [ "/app/hello.sh" ];
    WorkingDir = "/app";
  };
}
