# How configured values can be overridden
{ pkgs }:
builtins.toJSON (
  (pkgs.lib.evalModules {
    modules = [
      (
        { lib, ... }:
        with lib;
        {
          options = {
            default = mkOption {
              type = types.str;
              default = "default";
            };
            configured = mkOption {
              type = types.str;
              default = "default";
            };
            forced = mkOption {
              type = types.str;
              default = "default";
            };
          };
          config = {
            configured = "configured";
            forced = "configured";
          };
        }
      )

      (
        { lib, ... }:
        {
          forced = lib.mkForce "forced";
        }
      )
    ];
  }).config
)
