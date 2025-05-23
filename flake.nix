{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { nixpkgs, ... }: 
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      androidComposition = pkgs.androidenv.composeAndroidPackages {
        platformVersions = [ "31" "33" "34" "35" ];
        buildToolsVersions = [ "34.0.0" ];
        cmakeVersions = [ "3.22.1" ];

        includeSystemImages = "if-supported";
        includeEmulator = "if-supported";

        includeNDK = "if-supported";
        ndkVersions = [ "25.1.8937393" ];
      };

      androidSdk = androidComposition.androidsdk;

      jdk = pkgs.jdk17;

    in {

      devShell.${system} = pkgs.mkShell rec {
        packages = [
          jdk
          androidSdk
          pkgs.flutter329

          (pkgs.writeShellApplication {
            name = "emulator-setup";

            text = ''
              avdmanager delete avd -n uni_emulator 2>/dev/null || true
              avdmanager create avd -n uni_emulator -k "system-images;android-35;google_apis;x86_64" -d "pixel_9_pro_xl"

              # Enable GPU acceleration
              {
                echo "hw.gpu.enabled=yes"
                echo "hw.gpu.mode=host"
              } >> ~/.android/avd/uni_emulator.avd/config.ini

              avdmanager list avd
            '';
          })
        ];

        LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ libGL];
        ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
        ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk-bundle";
        JAVA_HOME = "${jdk}";

        passthru = {
          inherit androidComposition;
        };
      };
    };
}
