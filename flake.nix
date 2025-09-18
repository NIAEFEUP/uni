{
  description = "A basic flake for Flutter development with Nix and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:limwa/nix-flake-utils";

    # For hardware-accelerated Android emulator on NixOS
    limwa.url = "github:limwa/nix-registry";

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

          buildToolsVersions = ["34.0.0"];
          cmakeVersions = ["3.22.1"];
          platformVersions = ["31" "33" "34" "35"];
          ndkVersions = ["25.1.8937393"];
        };

        flutter = pkgs.flutter332;
        jdk = pkgs.jdk17;
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
          jdk,
          ...
        }:
          pkgs.mkShell rec {
            meta.description = "A development shell with Flutter and an Android SDK installation";

            env = {
              # Android environment variables
              ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
              GRADLE_OPTS = let
                buildToolsVersion = pkgs.lib.getVersion (builtins.elemAt androidComposition.build-tools 0);
              in "-Dorg.gradle.project.android.aapt2FromMavenOverride=${env.ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2";

              # Java environment variables
              JAVA_HOME = "${jdk}";
            };

            packages = [
              androidComposition.androidsdk
              flutter
              jdk
            ];
          };
      };

      apps = utils.lib.invokeAttrs {
        emulator = {pkgs, ...}: {
          type = "app";
          program = pkgs.lib.getExe (
            pkgs.limwa.android.wrapEmulatorWith {} (
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
            )
          );
        };
      };
    };
}
