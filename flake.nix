{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nur-xddxdd = {
      # url = "/home/lantian/Projects/nur-packages";
      url = "github:xddxdd/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nvfetcher.follows = "nvfetcher";
    };
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./kernels.nix
        ./flake-modules
        ./flake-modules/commands.nix
        inputs.nur-xddxdd.flakeModules.commands
        inputs.nur-xddxdd.flakeModules.lantian-pre-commit-hooks
        inputs.nur-xddxdd.flakeModules.lantian-treefmt
        inputs.nur-xddxdd.flakeModules.nixpkgs-options
      ];

      systems = [ "x86_64-linux" ];

      flake = {
        flakeModule = ./flake-modules;
        flakeModules.default = ./flake-modules;
      };

      perSystem =
        { pkgs, ... }:
        {
          packages = {
            gcc-aarch64-linux-android = pkgs.callPackage pkgs/gcc-aarch64-linux-android.nix { };
            gcc-arm-linux-androideabi = pkgs.callPackage pkgs/gcc-arm-linux-androideabi.nix { };
            android_prebuilts_clang_kernel_linux-x86_clang-r416183b =
              pkgs.callPackage pkgs/android_prebuilts_clang_kernel_linux-x86_clang-r416183b.nix
                { };
            android_prebuilts_clang_r416183b1 = pkgs.callPackage pkgs/android_prebuilts_clang_custom.nix {
              customGoogleClang = {
                CLANG_REV = null;
                CLANG_VERSION = "r416183b1";
                CLANG_BRANCH = "android12-release";
                CLANG_SHA256 = "1zg1cm8zn8prawgz3h1qnapxrgkmj894pl10i1q11nfcv3ycic41";
              };
            };
            google_clang_r377782d = pkgs.callPackage pkgs/android_prebuilts_clang_custom.nix {
              customGoogleClang = {
                CLANG_REV = "c013e9459821e16de10b14b8c03c090cf6640dbf";
                CLANG_VERSION = "r377782d";
                CLANG_BRANCH = null;
                CLANG_SHA256 = "1z4icr0qkvhf6hvg3ybf10zllvr5p6sqnkf17vz1gd4ms7d7ik3q";
              };
            };
          };
        };
    };
}
