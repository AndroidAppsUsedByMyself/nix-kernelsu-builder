_: {
  perSystem =
    { pkgs, ... }:
    let
      sources = pkgs.callPackage _sources/generated.nix { };
    in
    {
      kernelsu = {
        amazon-fire-hd-karnak = {
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
          anyKernelVariant = "kernelsu";
          clangVersion = "latest";

          kernelSU.variant = "next";
          susfs = {
            enable = true;
            inherit (sources.susfs-android13-5_15) src;
            kernelsuPatch = "${sources.wildplus-kernel-patches.src}/KernelSU-Next-Implement-SUSFS-v1.5.5-Universal.patch";
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
          anyKernelVariant = "kernelsu";
          clangVersion = "latest";

          kernelSU.variant = "next";
          susfs = {
            enable = true;
            inherit (sources.susfs-android13-5_15) src;
            kernelsuPatch = "${sources.wildplus-kernel-patches.src}/KernelSU-Next-Implement-SUSFS-v1.5.5-Universal.patch";
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
          anyKernelVariant = "osm0sis";
          clangVersion = "latest";
          kernelSU.variant = "next";
          kernelDefconfigs = [ "blu_spark_defconfig" ];
          kernelImageName = "Image";
          kernelSrc = sources.linux-oneplus-8t-blu-spark.src;
          kernelConfig = ''
            CONFIG_STACKPROTECTOR=n
            CONFIG_LTO_CLANG=y
          '';
        };

        moto-pstar-lineageos-22_0 = {
          anyKernelVariant = "kernelsu";
          clangVersion = "custom";
          kernelSU = {
            enable = true;
            variant = "next";
          };
          enableGcc64 = true;
          enableGcc32 = true;
          enableLLVM = false;
          # clangPrebuilt = "android_prebuilts_clang_kernel_linux-x86_clang-r416183b";
          customGoogleClang = {
            CLANG_VERSION = "r416183b1";
            CLANG_BRANCH = "android12-release";
            CLANG_SHA256 = "1zg1cm8zn8prawgz3h1qnapxrgkmj894pl10i1q11nfcv3ycic41";
          };
          kernelDefconfigs = [
            # separated configs
            #"vendor/kona-perf_defconfig"
            #"vendor/ext_config/moto-kona.config"
            #"vendor/ext_config/pstar-default.config"
            #"vendor/debugfs.config"
            # the one which need to be generated before build
            #"lineageos_pstar_defconfig"
            # the one which extract from a real device
            "lineageos_pstar_stock_defconfig"
          ];
          kernelImageName = "Image";
          kernelMakeFlags = [
            "KCFLAGS=\"-w\""
            "KCPPFLAGS=\"-w\""
            "LOCALVERSION=-official-kernelsu"
          ];
          kernelSrc = sources.linux-moto-pstar-lineageos-22_0.src;
          oemBootImg = sources.lineage-nightly-pstar_bootImg.src;
        };

        ztc1997-android_gki_kernel_5-10_common = {
          anyKernelVariant = "osm0sis";
          clangVersion = "gki";
          gkiVersion = "android12-5.10";
          kernelDefconfigs = [ "gki_defconfig" ];
          kernelImageName = "Image";
          kernelSrc = sources.ztc1997-android_gki_kernel_5-10_common.src;
          kernelConfig = ''
            CONFIG_LTO_CLANG=y
          '';
        };

        ztc1997-android_gki_kernel_5-15_common = {
          anyKernelVariant = "osm0sis";
          clangVersion = "gki";
          gkiVersion = "android13-5.15";
          kernelDefconfigs = [ "gki_defconfig" ];
          kernelImageName = "Image";
          kernelSrc = sources.ztc1997-android_gki_kernel_5-15_common;
          kernelConfig = ''
            CONFIG_LTO_CLANG=y
          '';
        };
      };
    };
}
