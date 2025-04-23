{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
        includeSources = true;
        includeSystemImages = true;
        includeEmulator = "if-supported";
        includeNDK = "if-supported";

        minPlatformVersion = 31;
        buildToolsVersions = [ "34.0.0" "35.0.1" "36.0.0" ];
      };

      androidSdk = androidComposition.androidsdk;
    in {

      devShell.${system} = pkgs.mkShell rec {
        packages = with pkgs; [
          flutter324
          jdk17
          androidSdk
        ];

        ANDROID_SDK_ROOT="${androidSdk}/libexec/android-sdk";
        ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";
        JAVA_HOME = "${pkgs.jdk17}";
      };
    };
}
