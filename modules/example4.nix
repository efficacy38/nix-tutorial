# Actually using multiple language servers: go and rust
{ pkgs }:
builtins.toJSON (
  (pkgs.lib.evalModules {
    modules = [
      { _module.args.pkgs = pkgs; }

      (
        {
          lib,
          pkgs,
          ...
        }:
        with lib;
        let
          languageServerModule =
            { ... }:
            {
              options.name = mkOption { type = types.str; };
              options.start = mkOption { type = types.str; };
            };
        in
        {
          options.lsp = mkOption {
            type = types.attrsOf (types.submodule languageServerModule);
            default = { };
          };
          config.lsp.go = {
            name = "go lsp";
            start = "${pkgs.gopls}/bin/gopls";
          };
          config.lsp.rust = {
            name = "rust lsp";
            start = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
        }
      )
    ];
  }).config
)
