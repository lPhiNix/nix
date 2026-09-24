#    _  ___        ___           __         _    __
#   / |/ (_)_ __  / _ | ___  ___/ /______  (_)__/ /
#  /    / /\ \ / / __ |/ _ \/ _  / __/ _ \/ / _  /
# /_/|_/_//_\_\ /_/ |_/_//_/\_,_/_/  \___/_/\_,_/
# -------------------------------------------------
# Android nix home packages by lPhiNix
#
{pkgs, ...}: let
  # Accept the SDK license on this derivation only, so no global
  # nixpkgs.config.android_sdk.accept_license is needed.
  androidSdk =
    (pkgs.androidenv.composeAndroidPackages.override {
      licenseAccepted = true;
    }) {
      platformVersions = ["36" "35"];
      buildToolsVersions = ["36.0.0" "35.0.0"];

      # Physical device only for now; flip these on for an emulator.
      includeEmulator = false;
      includeSystemImages = false;

      includeNDK = false;
    };
in {
  home.packages = with pkgs; [
    # adb, fastboot, sdkmanager and avdmanager on PATH.
    androidSdk.androidsdk

    # Mirror and control the device from the desktop (no Android Studio needed).
    scrcpy
  ];

  home.sessionVariables = {
    ANDROID_HOME = "${androidSdk.androidsdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk.androidsdk}/libexec/android-sdk";

    # Keep user state out of $HOME.
    ANDROID_USER_HOME = "$HOME/.local/share/android";
    GRADLE_USER_HOME = "$HOME/.local/share/gradle";
  };
}
