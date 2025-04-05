{
  pkgs,
  linter,
  nodejs,
  ...
}:
let
  inherit (pkgs)
    buildEnv
    writeScript
    lib
    stdenv
    ;
  inherit (import ../lib/bash.nix { }) binBashHeader;

  debug = true;
  appPath = "/app/linter";

  runLint = writeScript "run-lint.sh" (
    binBashHeader
    + ''
      export PATH="$PATH:${linter}/lib/node_modules/.bin"
      npm run lint --prefix ${appPath}

      if [ -f "${appPath}/lint-warnings.xml" ] && [ -s "${appPath}/lint-warnings.xml" ]; then
        echo "Lint warnings file generated successfully!"
        cp ${appPath}/lint-warnings.xml ${appPath}/src/
        du -h ${appPath}/src/lint-warnings.xml
      fi
    ''
  );

  linterApp = stdenv.mkDerivation {
    name = "linter-app";
    dontUnpack = true;
    dontConfigure = true;
    dontInstall = true;

    buildPhase =
      ''
        mkdir -p $out${appPath}/src
        cp -r ${linter}/lib/node_modules/linter $out/app
        touch $out${appPath}/src/.keep
      ''
      + (lib.optionalString debug ''
        cp ${runLint} $out/app/run-lint.sh
        echo "${linter}/lib/node_modules/linter" >> $out/app/binpath'');
  };
in
{
  name = "linter-image";
  tag = "latest";
  created = "now";

  copyToRoot = buildEnv {
    name = "linter-root";
    paths = [
      pkgs.bash
      pkgs.coreutils
      nodejs
      linterApp
    ];
    pathsToLink = [
      "/bin"
      "/app"
    ];
  };

  config = {
    Cmd = [ runLint ];
    WorkingDir = appPath;
    Volumes = {
      "${appPath}/src" = { };
    };
  };
}
