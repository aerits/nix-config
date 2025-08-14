{
  config,
  lib,
  pkgs,
  ...
}:

{
  # xrizer with fbt
  nixpkgs.overlays = [
    (final: prev: {
      xrizer = prev.xrizer.overrideAttrs {
        src = final.fetchFromGitHub {
          owner = "RinLovesYou";
          repo = "xrizer";
          # IMPORTANT: Fill the below field with the latest commit hash from https://github.com/RinLovesYou/xrizer/commits/experimental2 (click the Copy full SHA button on the right side)
          rev = "f491eddd0d9839d85dbb773f61bd1096d5b004ef";
          # IMPORTANT: Replace the below field with the correct hash, the error when building with this empty will give you the expected hash.
          hash = "sha256-12M7rkTMbIwNY56Jc36nC08owVSPOr1eBu0xpJxikdw=";
        };
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          src = final.fetchFromGitHub {
            # quick and dirty fix to have the right cargo hash
            owner = "RinLovesYou";
            repo = "xrizer";
            rev = "f491eddd0d9839d85dbb773f61bd1096d5b004ef";
            hash = "sha256-12M7rkTMbIwNY56Jc36nC08owVSPOr1eBu0xpJxikdw=";
          };
          hash = "sha256-87JcULH1tAA487VwKVBmXhYTXCdMoYM3gOQTkM53ehE=";
        };
      };
    })
  ];

  services.wivrn = {
    enable = true;
    defaultRuntime = true;
    openFirewall = true;
    package = pkgs.wivrn.overrideAttrs (old: {
      cmakeFlags = old.cmakeFlags ++ [
        (lib.cmakeBool "WIVRN_FEATURE_STEAMVR_LIGHTHOUSE" true)
      ];
    });
    monadoEnvironment = {
      WIVRN_USE_STEAMVR_LH = "1";
      LH_DISCOVER_WAIT_MS = "6000";
    };
  };
  environment.systemPackages = with pkgs; [
    motoc
    wlx-overlay-s
  ];
}
