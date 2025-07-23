{
  lib,
  config,
  sources,
  pkgs,
  fetchGooglePrebuiltClang,
  ...
}:
let
  inherit (config.packages) emptyFile;
  kernelsuVariants = {
    # builtin variants do not require these fields
    rsuntk = {
      enable = true;
      variant = "rsuntk";
      inherit (sources.kernelsu-rksu) src;
      revision = sources.kernelsu-rksu-revision-code.version;
      subdirectory = "KernelSU";
      susfs_kernelsuPatch = "${sources.susfs-4_19.src}/kernel_patches/KernelSU/10_enable_susfs_for_ksu.patch";
      integrateMethod = "manually_patch_cmd";
      moduleSystemImpl = "magicmount";
    };
    next = {
      enable = true;
      variant = "next";
      inherit (sources.kernelsu-next) src;
      revision = sources.kernelsu-next-revision-code.version;
      subdirectory = "KernelSU";
      susfs_kernelsuPatch = "${sources.susfs-4_19.src}/kernel_patches/KernelSU/10_enable_susfs_for_ksu.patch";
      integrateMethod = "manually_patch_cmd";
      moduleSystemImpl = "magicmount";
    };
    rsuntk-susfs = {
      enable = true;
      variant = "rsuntk-susfs";
      inherit (sources.kernelsu-rksu-susfs) src;
      revision = sources.kernelsu-rksu-susfs-revision-code.version;
      subdirectory = "KernelSU";
      susfs_kernelsuPatch = "${emptyFile}";
      integrateMethod = "manually_patch_cmd";
      moduleSystemImpl = "magicmount";
    };
  };
  mkKernel = lib.makeOverridable (
    {
      susfs ? {
        enable = false;
        inherit (sources.susfs-4_19) src;
        kernelsuPatch = kernelSU.susfs_kernelsuPatch or "${emptyFile}";
        kernelPatch = "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/50_add_susfs_in_kernel-4.19.157.patch";
      },
      kernelSU ? {
        inherit (kernelsuVariants.rsuntk)
          enable
          variant
          src
          revision
          subdirectory
          integrateMethod
          ;
      },
      build-toolchain ? "clang-with-gcc",
      anyKernelVariant ? "osm0sis",
      clangVersion ? "custom",
      enableGcc64 ? true,
      enableGcc32 ? true,
      enableLLVM ? false,
      clangPrebuilt ? config.packages.google_clang_r416183b1,
      kernelDefconfigs ? [
        "vendor/kona-perf_defconfig"
        "vendor/ext_config/moto-kona.config"
        "vendor/ext_config/pstar-default.config"
        "vendor/debugfs.config"
      ],
      kernelImageName ? "Image",
      kernelMakeFlags ? [
        "KCFLAGS=\"-w\""
        "KCPPFLAGS=\"-w\""
        "LOCALVERSION=-rk"
      ],
      kernelSrc ? sources.linux-moto-pstar-lineageos-22_1.src,
      oemBootImg ? sources.lineage-nightly-pstar_bootImg.src,
      kernelPatches ? [
        "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/module.patch"
        "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/0001-BACKPORT-maccess-rename-strncpy_from_unsafe_user-to-.patch"
        "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/0001-Reapply-cred-switch-to-using-atomic_long_t.patch"
        "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/0002-BACKPORT-cred-add-get_cred_rcu.patch"
        "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/path_umount_backport.patch"
      ],
      # without this kernel modules will refuse to be inserted
      kernelConfig ? ''
        CONFIG_MODULE_FORCE_LOAD=y
        CONFIG_MODULE_SIG_FORCE=n
      '',
    }:
    {
      inherit
        build-toolchain
        anyKernelVariant
        clangVersion
        kernelSU
        susfs
        enableGcc64
        enableGcc32
        enableLLVM
        clangPrebuilt
        kernelDefconfigs
        kernelImageName
        kernelMakeFlags
        kernelSrc
        oemBootImg
        kernelPatches
        kernelConfig
        ;
    }
  );

  baseKernel = mkKernel { };
in
{
  
        _moto-pstar-lineageos-22_1 =
          let
            susfs_enable = true;
            emptyFile = pkgs.writeText {
              text = '''';
            };
            KernelSU = rec {
              rsuntk_susfs = {
                variant = "rsuntk-susfs";
                inherit (sources.kernelsu-rksu-susfs) src;
                revision = sources.kernelsu-rksu-susfs-revision-code.version;
                subdirectory = "KernelSU";
                susfs_kernelsuPatch = emptyFile;
              };
              default = rsuntk_susfs;
            };
          in
          {
            build-toolchain = "clang-with-gcc";
            anyKernelVariant = "osm0sis";
            clangVersion = "custom";
            kernelSU = {
              enable = true;
              inherit (KernelSU.default)
                variant
                src
                revision
                subdirectory
                ;
            };
            susfs = {
              enable = susfs_enable;
              inherit (sources.susfs-4_19) src;
              kernelsuPatch = KernelSU.default.susfs_kernelsuPatch;
              kernelPatch = "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/50_add_susfs_in_kernel-4.19.157.patch";
            };
            enableGcc64 = true;
            enableGcc32 = true;
            enableLLVM = false;
            # clangPrebuilt = "android_prebuilts_clang_kernel_linux-x86_clang-r416183b";
            clangPrebuilt = config.packages.google_clang_r416183b1;
            kernelDefconfigs = [
              # separated configs
              "vendor/kona-perf_defconfig"
              "vendor/ext_config/moto-kona.config"
              "vendor/ext_config/pstar-default.config"
              "vendor/debugfs.config"
              # the one which need to be generated before build
              #"lineageos_pstar_defconfig"
              # the one which extract from a real device
              #"lineageos_pstar_stock_defconfig"
            ];
            kernelImageName = "Image";
            kernelMakeFlags = [
              "KCFLAGS=\"-w\""
              "KCPPFLAGS=\"-w\""
              "LOCALVERSION=-rk"
            ];
            kernelSrc = sources.linux-moto-pstar-lineageos-22_1.src;
            oemBootImg = sources.lineage-nightly-pstar_bootImg.src;
            kernelPatches = [
              "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/module.patch"
              "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/0001-BACKPORT-maccess-rename-strncpy_from_unsafe_user-to-.patch"
              "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/0001-Reapply-cred-switch-to-using-atomic_long_t.patch"
              "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/0002-BACKPORT-cred-add-get_cred_rcu.patch"
              "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/path_umount_backport.patch"
            ];
            kernelConfig = ''
              CONFIG_MODULE_FORCE_LOAD=y
              CONFIG_MODULE_SIG_FORCE=n
            '';
          };

        xiaomi-gauguin-lineageos-22_1 = {
          build-toolchain = "clang-with-gcc";
          anyKernelVariant = "osm0sis";
          clangVersion = "custom";
          kernelSU = {
            enable = true;
            variant = "next";
          };
          enableGcc64 = true;
          enableGcc32 = true;
          enableLLVM = false;
          # clangPrebuilt = "android_prebuilts_clang_kernel_linux-x86_clang-r416183b";
          clangPrebuilt = config.packages.google_clang_r383902;
          kernelDefconfigs = [
            "vendor/lito-perf_defconfig"
            "gauguin_defconfig"
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
          anyKernelVariant = "osm0sis";
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
          anyKernelVariant = "osm0sis";
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
          anyKernelVariant = "kernelsu";
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
          anyKernelVariant = "kernelsu";
          clangVersion = "gki";
          gkiVersion = "android13-5.15";
          kernelDefconfigs = [ "gki_defconfig" ];
          kernelImageName = "Image";
          kernelSrc = sources.ztc1997-android_gki_kernel_5-15_common.src;
          kernelConfig = ''
            CONFIG_LTO_CLANG=y
          '';
        };
}
