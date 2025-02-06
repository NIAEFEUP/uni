{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
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
        platformVersions = [ "31" "33" "34" ];
        buildToolsVersions = [ "34.0.0" ];
        includeNDK = true;
        includeEmulator = true;
        includeSystemImages = true;
      };

      androidSdk = androidComposition.androidsdk;
    in {

      devShell.${system} = pkgs.mkShell {
        packages = with pkgs; [
          flutter
          jdk17
          androidSdk
        ];

        shellHook = ''
          export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
          export JAVA_HOME="${pkgs.jdk17}"
        '';
      };
    };
}
