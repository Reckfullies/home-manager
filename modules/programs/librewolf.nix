{ config, lib, ... }:

with lib;

let

  modulePath = [ "programs" "librewolf" ];

  cfg = getAttrFromPath modulePath config;

  mkFirefoxModule = import ./firefox/mkFirefoxModule.nix;

  mkOverridesFile = prefs: ''
    // Generated by Home Manager.

    ${concatStrings (mapAttrsToList (name: value: ''
      defaultPref("${name}", ${builtins.toJSON value});
    '') prefs)}
  '';

  configPath = ".librewolf";

in {
  meta.maintainers = [ maintainers.onny ];

  imports = [
    (mkFirefoxModule modulePath {
      name = "Librewolf";
      wrappedPackageName = "librewolf";
      unwrappedPackageName = "librewolf-unwrapped";
      platforms.linux.configPath = configPath;
    })
  ];

  options = setAttrByPath modulePath {
    settings = mkOption {
      type = with types; attrsOf (either bool (either int str));
      default = { };
      example = literalExpression ''
        {
          "webgl.disabled" = false;
          "privacy.resistFingerprinting" = false;
        }
      '';
      description = ''
        Attribute set of LibreWolf settings and overrides. Refer to
        <https://librewolf.net/docs/settings/>
        for details on supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    # TODO: Check whether it works on debian

    home.file."${configPath}/librewolf.overrides.cfg".text =
      mkOverridesFile cfg.settings;
  };
}
