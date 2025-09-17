{
  description = "A basic flake for Flutter development with Nix and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:limwa/nix-flake-utils";

    # Needed for shell.nix
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
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
        };

        # Reuse the same Android SDK, JDK and Flutter versions across all derivations
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          includeNDK = "if-supported";

          buildToolsVersions = ["34.0.0"];
          cmakeVersions = ["3.22.1"];
          platformVersions = ["31" "33" "34" "35"];
          ndkVersions = ["25.1.8937393"];
        };

        emulator = let
          base = pkgs.androidenv.emulateApp {
            name = "uni-emulator";

            platformVersion = "35";
            abiVersion = "x86_64";
            systemImageType = "google_apis";

            configOptions = {
              "hw.gpu.enabled" = "yes";
              "hw.gpu.mode" = "host";
            };
          };
        in
          # A wrapper is needed to fix hardware acceleration on NixOS
          pkgs.runCommandNoCC "${base.name}-wrapped" {
            nativeBuildInputs = [pkgs.makeWrapper];
            meta.mainProgram = "emulator";
          } ''
            mkdir -p $out/bin
            makeWrapper "${pkgs.lib.getExe base}" "$out/bin/${emulator.meta.mainProgram}" \
              --unset ANDROID_HOME \
              --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [pkgs.libGL]}"
          '';

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
        emulator = {
          pkgs,
          emulator,
          ...
        }: {
          type = "app";
          program = pkgs.lib.getExe emulator;
        };
      };
    };
}
