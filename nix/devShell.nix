{
  mkShell,
  linter,
  nodejs,
  ...
}:
mkShell {
  shellHook = ''
    export PATH="$PATH:${linter}/lib/node_modules/.bin"

    echo "Path enhanced with: ${linter}/lib/node_modules/.bin"

    export NODE_MODULES_PATH="${linter}/lib/node_modules/linter/node_modules"
    export OUTPUT_MODULES_PATH="linter/node_modules"
    rm -rf $OUTPUT_MODULES_PATH
    ln -s "$NODE_MODULES_PATH" "$OUTPUT_MODULES_PATH"

    echo "Created symbolic link: $OUTPUT_MODULES_PATH -> $NODE_MODULES_PATH"
  '';

  packages = [
    nodejs
    linter
  ];
}
