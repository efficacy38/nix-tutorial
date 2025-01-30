{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        ex =
          example:
          pkgs.callPackage ./utils/print_config.nix {
            inherit example;
          };
      in
      {
        packages = rec {
          example0 = ex ./modules/example0.nix;
          example1 = ex ./modules/example1.nix;
          example2 = ex ./modules/example2.nix;
          example3 = ex ./modules/example3.nix;
          example4 = ex ./modules/example4.nix;
          docker4 = pkgs.dockerTools.buildLayeredImage {
            name = "rust-lsp";
            config.Cmd = [
              "${pkgs.bash}/bin/bash"
              "-c"
              "$(${pkgs.jq}/bin/jq -r .lsp.rust.start <${example4.moduleConfig}) --version"
            ];
          };
          docker4-load-and-run = pkgs.writeScriptBin "docker-load-and-run" ''
            ${pkgs.docker}/bin/docker run $(${pkgs.docker}/bin/docker load -q < ${docker4} | cut -d' ' -f3)
          '';
          example5 = ex ./modules/example5.nix;
          example6 = ex ./modules/example6.nix;
        };
      }
    );
}
