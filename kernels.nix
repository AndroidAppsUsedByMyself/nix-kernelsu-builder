_: {
  perSystem =
    { pkgs, config, ... }:
    let
      sources = pkgs.callPackage _sources/generated.nix { };
      fetchGooglePrebuiltClang = pkgs.callPackage pkgs/android_prebuilts_clang_custom.nix;
      LineageOS_pstar = pkgs.callPackage ./LineageOS_pstar.nix {
        inherit sources;
        inherit config;
        inherit pkgs;
        inherit fetchGooglePrebuiltClang;
      };
      MyOtherDevices = pkgs.callPackage ./MyOtherDevices.nix {
        inherit sources;
        inherit config;
        inherit pkgs;
        inherit fetchGooglePrebuiltClang;
      };
    in
    {
      kernelsu = {
        amazon-fire-hd-karnak = {
          build-toolchain = "gcc-only";
          anyKernelVariant = "osm0sis";
          kernelSU.enable = false;
          kernelDefconfigs = [ "lineageos_karnak_defconfig" ];
          kernelImageName = "Image.gz-dtb";
          kernelMakeFlags = [
            "KCFLAGS=\"-w\""
            "KCPPFLAGS=\"-w\""
          ];
          kernelSrc = sources.linux-amazon-karnak.src;
          oemBootImg = boot/amazon-fire-hd-karnak.img;
        };

        moto-rtwo-lineageos-21 = {
          build-toolchain = "clang-with-llvm";
          anyKernelVariant = "kernelsu";
          clangVersion = "latest";

          kernelSU.variant = "next";
          susfs = {
            enable = true;
            inherit (sources.susfs-android13-5_15) src;
            kernelsuPatch = "${sources.wildplus-kernel-patches.src}/next/0001-kernel-patch-susfs-v1.5.5-to-KernelSU-Next-v1.0.5.patch";
          };

          kernelDefconfigs = [
            "gki_defconfig"
            "vendor/kalama_GKI.config"
            "vendor/ext_config/moto-kalama.config"
            "vendor/ext_config/moto-kalama-gki.config"
            "vendor/ext_config/moto-kalama-rtwo.config"
          ];
          kernelImageName = "Image";
          kernelMakeFlags = [
            "KCFLAGS=\"-w\""
            "KCPPFLAGS=\"-w\""
          ];
          kernelPatches = [
            "${sources.wildplus-kernel-patches.src}/69_hide_stuff.patch"
          ];
          kernelSrc = sources.linux-moto-rtwo-lineageos-21.src;
        };

        moto-rtwo-lineageos-22_1 = {
          build-toolchain = "clang-with-llvm";
          anyKernelVariant = "kernelsu";
          clangVersion = "latest";

          kernelSU.variant = "next";
          susfs = {
            enable = true;
            inherit (sources.susfs-android13-5_15) src;
            kernelsuPatch = "${sources.wildplus-kernel-patches.src}/next/0001-kernel-patch-susfs-v1.5.5-to-KernelSU-Next-v1.0.5.patch";
          };

          kernelDefconfigs = [
            "gki_defconfig"
            "vendor/kalama_GKI.config"
            "vendor/ext_config/moto-kalama.config"
            "vendor/ext_config/moto-kalama-gki.config"
            "vendor/ext_config/moto-kalama-rtwo.config"
          ];
          kernelImageName = "Image";
          kernelMakeFlags = [
            "KCFLAGS=\"-w\""
            "KCPPFLAGS=\"-w\""
          ];
          kernelPatches = [
            "${sources.wildplus-kernel-patches.src}/69_hide_stuff.patch"
          ];
          kernelSrc = sources.linux-moto-rtwo-lineageos-22_1.src;
        };

        oneplus-8t-blu-spark = {
          build-toolchain = "clang-with-llvm";
          anyKernelVariant = "osm0sis";
          clangVersion = "latest";
          kernelSU.variant = "next";
          kernelDefconfigs = [ "blu_spark_defconfig" ];
          kernelImageName = "Image";
          kernelSrc = sources.linux-oneplus-8t-blu-spark.src;
        };

      } // LineageOS_pstar // MyOtherDevices;
    };
}
