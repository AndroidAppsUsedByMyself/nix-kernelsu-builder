_: {
  perSystem =
    { pkgs, config, ... }:
    let
      sources = pkgs.callPackage _sources/generated.nix { };
      fetchGooglePrebuiltClang = pkgs.callPackage pkgs/android_prebuilts_clang_custom.nix;
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
          kernelConfig = ''
            CONFIG_STACKPROTECTOR=n
            CONFIG_LTO_CLANG=y
          '';
        };

        moto-pstar-lineageos-22_1 = {
          build-toolchain = "clang-with-gcc";
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
          clangPrebuilt = config.packages.android_prebuilts_clang_r416183b1;
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
          kernelSrc = sources.linux-moto-pstar-lineageos-22_1.src;
          oemBootImg = sources.lineage-nightly-pstar_bootImg.src;
          kernelPatches = [
            "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/module.patch"
          ];
          kernelConfig = ''
            CONFIG_MODULE_FORCE_LOAD=y
            CONFIG_MODULE_SIG_FORCE=n
          '';
        };

        xiaomi-gauguin-lineageos-22_1 = {
          build-toolchain = "clang-with-gcc";
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
          clangPrebuilt = config.packages.android_prebuilts_clang_r416183b1;
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
          kernelSrc = sources.linux-xiaomi-gauguin-lineageos-22_1.src;
          kernelPatches = [
            "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/module.patch"
          ];
          kernelConfig = ''
            CONFIG_MODULE_FORCE_LOAD=y
            CONFIG_MODULE_SIG_FORCE=n
          '';
        };

        # this workflow require python2 which is removed from nixpkgs
        _android_kernel_samsung_sm8250_TabS7 = {
          build-toolchain = "clang-with-gcc";
          enablePython2 = true;
          anyKernelVariant = "kernelsu";
          # We already have integrated it
          kernelSU.enable = false;
          enableGcc64 = true;
          enableGccCompat = true;
          enableLLVM = true;
          clangPrebuilt = config.packages.google_clang_r377782d;
          kernelSrc = sources.android_kernel_samsung_sm8250_TabS7.src;
          kernelDefconfigs = [
            "gts7xl_eur_openx_defconfig"
          ];
          kernelMakeFlags = [
            "LOCALVERSION=-Kokuban-Hua-S5DXA1"
            "DTC_EXT=${sources.android_kernel_samsung_sm8250_TabS7.src}/tools/dtc"
            "CONFIG_BUILD_ARM64_DT_OVERLAY=y"
            "CLANG_TRIPLE=aarch64-linux-gnu-"
            "-C ${sources.android_kernel_samsung_sm8250_TabS7.src}"
          ];
          kernelConfig = ''
            KSU=y

            UH=n
            RKP=n
            KDP=n
            SECURITY_DEFEX=n
            INTEGRITY=n
            FIVE=n
            TRIM_UNUSED_KSYMS=n
            PROCA=n
            PROCA_GKI_10=n
            PROCA_S_OS=n
            PROCA_CERTIFICATES_XATTR=n
            PROCA_CERT_ENG=n
            PROCA_CERT_USER=n
            GAF_V6=n
            FIVE=n
            FIVE_CERT_USER=n
            FIVE_DEFAULT_HASH=n

            # LTO_CLANG_THIN=y
            # LTO_CLANG_FULL=n
          '';
        };

        _android_kernel_samsung_lykanlte = {
          build-toolchain = "clang-with-gcc";
          anyKernelVariant = "kernelsu";
          kernelSU = {
            enable = false;
            variant = "next";
          };
          enableGcc64 = true;
          enableGcc32 = true;
          enableLLVM = false;
          # clangPrebuilt = "android_prebuilts_clang_kernel_linux-x86_clang-r416183b";
          clangPrebuilt = fetchGooglePrebuiltClang {
            customGoogleClang = {
              CLANG_VERSION = "r416183b1";
              CLANG_BRANCH = "android12-release";
              CLANG_SHA256 = "1zg1cm8zn8prawgz3h1qnapxrgkmj894pl10i1q11nfcv3ycic41";
            };
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
            "lykanlte_chn_open_defconfig"
          ];
          kernelImageName = "Image";
          kernelMakeFlags = [
            "KCFLAGS=\"-w\""
            "KCPPFLAGS=\"-w\""
          ];
          kernelSrc = sources.android_kernel_samsung_lykanlte.src;
          kernelConfig = ''
            CONFIG_MODULE_FORCE_LOAD=y
            CONFIG_MODULE_SIG_FORCE=n
          '';
        };

        ztc1997-android_gki_kernel_5-10_common = {
          build-toolchain = "gki";
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
          build-toolchain = "gki";
          anyKernelVariant = "osm0sis";
          clangVersion = "gki";
          gkiVersion = "android13-5.15";
          kernelDefconfigs = [ "gki_defconfig" ];
          kernelImageName = "Image";
          kernelSrc = sources.ztc1997-android_gki_kernel_5-15_common.src;
          kernelConfig = ''
            CONFIG_LTO_CLANG=y
          '';
        };
      };
    };
}
