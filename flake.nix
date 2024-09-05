{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    {
      overlays.default = final: prev: {
        inherit (final.callPackage self.lib { }) millPlatform;
      };
      lib = ./lib.nix;
    }
    // (
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
            millDeps = pkgs.millPlatform.millFetchDeps {
              inherit src;
              hash = "sha256-fv6fhgGyNNxw3EcT0hiZZefHzvic4KHtQUmCpHefK64=";
            };
            millCheckDeps = true;
            nativeBuildInputs = with pkgs; [
              circt
              millPlatform.millSetupHook
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
            CHISEL_FIRTOOL_PATH = "${pkgs.circt}/bin";
          };
        };
        formatter.x86_64-linux =
          (treefmt-nix.lib.evalModule pkgs {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.scalafmt.enable = true;
          }).config.build.wrapper;
      }
    );
}
