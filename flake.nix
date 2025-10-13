{
  description = "A basic flake for Flutter development with Nix and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/pull/450619/merge";
    utils.url = "github:limwa/nix-flake-utils";

    # For hardware-accelerated Android emulator on NixOS
    limwa.url = "github:limwa/nix-registry";
    limwa.inputs.nixpkgs.follows = "nixpkgs";

    # Needed for shell.nix
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    limwa,
    ...
  }:
    utils.lib.mkFlakeWith {
      forEachSystem = system: rec {
        outputs = utils.lib.forSystem self system;

        pkgs = import nixpkgs {
          inherit system;

          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };

          overlays = [
            # For hardware-accelerated Android emulator on NixOS
            limwa.overlays.android
          ];
        };

        # Reuse the same Android SDK, JDK and Flutter versions across all derivations
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          includeNDK = "if-supported";

          buildToolsVersions = ["35.0.0"];
          cmakeVersions = ["3.22.1"];
          platformVersions = ["36" "35" "34"];
          ndkVersions = ["27.0.12077973"];
        };

        flutter = pkgs.flutter335;
        jdks = with pkgs; [jdk21 jdk17];
      };
    } {
      formatter = {pkgs, ...}: pkgs.alejandra;

      devShells = utils.lib.invokeAttrs {
        default = {outputs, ...}: outputs.devShells.flutter;

        # Flutter development shell
        flutter = {
          pkgs,
          androidComposition,
          flutter,
          jdks,
          ...
        }: let
          jdk = builtins.elemAt jdks 0;
          buildToolsVersion = pkgs.lib.getVersion (builtins.elemAt androidComposition.build-tools 0);
        in
          pkgs.mkShell rec {
            meta.description = "A development shell with Flutter and an Android SDK installation";

            env = {
              # Android environment variables
              ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";

              # Java environment variables
              JAVA_HOME = "${jdk}";

              GRADLE_OPTS = pkgs.lib.concatStringsSep " " [
                "-Dorg.gradle.project.android.aapt2FromMavenOverride=${env.ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2"
                # KMS pls ;w;
                # https://github.com/gradle/gradle/issues/33307
                "-Dorg.gradle.project.org.gradle.java.installations.auto-detect=false"
                "-Dorg.gradle.project.org.gradle.java.installations.auto-download=false"
                "-Dorg.gradle.project.org.gradle.java.installations.paths=${pkgs.lib.concatStringsSep "," jdks}"
              ];
            };

            packages = [
              androidComposition.androidsdk

              flutter
              jdk
            ];

            shellHook = ''
              export PATH="$ANDROID_HOME/build-tools/${buildToolsVersion}:$PATH"
            '';
          };
      };

      packages = utils.lib.invokeAttrs {
        emulator = {pkgs, ...}:
          pkgs.limwa.android.wrapEmulatorWith {
            useHardwareGraphics = "vulkan";
          } (
            pkgs.androidenv.emulateApp {
              name = "uni-emulator";
              deviceName = "uni_emulator";

              platformVersion = "35";
              abiVersion = "x86_64";
              systemImageType = "google_apis_playstore";

              # Specify user home to speed up boot times and avoid creating
              # a lot of avd instances taking up disk space
              androidUserHome = "\$HOME/.android";
            }
          );
      };
    };
}
