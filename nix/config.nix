{
  config,
  dream2nix,
  ...
}:
{
  name = "linter";
  version = "0.0.1";

  imports = [
    dream2nix.modules.dream2nix.nodejs-package-lock-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  mkDerivation = {
    src = ../linter;
  };

  deps =
    { nixpkgs, ... }:
    {
      inherit (nixpkgs)
        fetchFromGitHub
        stdenv
        ;
    };

  nodejs-package-lock-v3 = {
    packageLockFile = "${config.mkDerivation.src}/package-lock.json";
  };

}
