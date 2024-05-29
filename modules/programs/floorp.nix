{lib, ...}:
with lib; let
  modulePath = ["programs" "floorp"];
  mkFirefoxModule = import ./firefox/mkFirefoxModule.nix;
in {
  meta.maintainers = [maintainers.rycee maintainers.kira-bruneau maintainers.bricked];

  imports = [
    (mkFirefoxModule modulePath {
      name = "Floorp";
      wrappedPackageName = "floorp";
      unwrappedPackageName = "floorp-unwrapped";
      visible = true;

      platforms.linux = rec {
        vendorPath = ".floorp";
        configPath = "${vendorPath}";
      };
      platforms.darwin = {
        vendorPath = "Library/Application Support/Floorp";
        configPath = "Library/Application Support/Floorp";
      };
    })
  ];
}
