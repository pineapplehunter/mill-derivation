{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    {
      overlays.default = final: prev: {
        inherit (final.callPackage self.lib { }) millFetchDeps millSetupHook;
      };
      lib = ./lib.nix;
    } // (
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ self.overlays.default ];
        };
      in
      {
        packages.x86_64-linux = rec {
          default = create-circuit;
          create-circuit = pkgs.stdenv.mkDerivation rec {
            name = "circuit";
            src = ./circuit-src;
            millDeps = pkgs.millFetchDeps {
              inherit src;
              depsHash = "sha256-0C1GzEk5p3IPReOHtUnd6sKwpA3NyBEKVwx9qyoItDE=";
            };
            millCheckDeps = true;
            nativeBuildInputs = with pkgs;[
              circt
              millSetupHook
            ];
            buildPhase = ''
              mill run
            '';
            checkPhase = ''
              mill test
            '';
            doCheck = true;
            installPhase = ''
              mkdir -p $out
              cp -f *.sv *.anno.json $out
            '';
            passthru.deps = millDeps;
          };
        };
        formatter.x86_64-linux = pkgs.nixpkgs-fmt;
      }
    );
}
