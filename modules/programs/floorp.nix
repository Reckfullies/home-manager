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
        vendorPath = ".mozilla";
        configPath = "${vendorPath}/floorp";
      };
      platforms.darwin = {
        vendorPath = "Library/Application Support/Mozilla";
        configPath = "Library/Application Support/Floorp";
      };
    })
  ];
}
