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
      inherit (sources.AAAAA_kernelsu-rksu) src;
      revision = sources.AAAAA_kernelsu-rksu-revision-code.version;
      subdirectory = "KernelSU";
      susfs_kernelsuPatch = "${sources.AAAAA_susfs-4_19.src}/kernel_patches/KernelSU/10_enable_susfs_for_ksu.patch";
      integrateMethod = "manually_patch_cmd";
      moduleSystemImpl = "magicmount";
    };
    next = {
      enable = true;
      variant = "next";
      inherit (sources.kernelsu-next) src;
      revision = sources.kernelsu-next-revision-code.version;
      subdirectory = "KernelSU";
      susfs_kernelsuPatch = "${sources.AAAAA_susfs-4_19.src}/kernel_patches/KernelSU/10_enable_susfs_for_ksu.patch";
      integrateMethod = "manually_patch_cmd";
      moduleSystemImpl = "magicmount";
    };
    rsuntk-susfs = {
      enable = true;
      variant = "rsuntk-susfs";
      inherit (sources.AAAAA_kernelsu-rksu-susfs) src;
      revision = sources.AAAAA_kernelsu-rksu-susfs-revision-code.version;
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
        inherit (sources.AAAAA_susfs-4_19) src;
        kernelsuPatch = kernelSU.susfs_kernelsuPatch or "${emptyFile}";
        kernelPatch = "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/50_add_susfs_in_kernel-4.19.157.patch";
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
      kernelSrc ? sources.AAAAA_linux-moto-pstar-lineageos-22_1.src,
      oemBootImg ? sources.AAAAA_lineage-nightly-pstar_bootImg.src,
      kernelPatches ? [
        "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/module.patch"
        "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/0001-BACKPORT-maccess-rename-strncpy_from_unsafe_user-to-.patch"
        "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/0001-Reapply-cred-switch-to-using-atomic_long_t.patch"
        "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/0002-BACKPORT-cred-add-get_cred_rcu.patch"
        "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/path_umount_backport.patch"
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
  moto-pstar-lineageos-22_1-base = baseKernel;

  moto-pstar-lineageos-22_1-kernelsu-rsuntk = baseKernel.override (_: rec {
    kernelSU = {
      inherit (kernelsuVariants.rsuntk)
        enable
        variant
        src
        revision
        subdirectory
        integrateMethod
        moduleSystemImpl
        ;
    };
    susfs = {
      enable = false;
      inherit (sources.AAAAA_susfs-4_19) src;
      kernelsuPatch = kernelsuVariants."${kernelSU.variant}".susfs_kernelsuPatch or "${emptyFile}";
      kernelPatch = "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/50_add_susfs_in_kernel-4.19.157.patch";
    };
  });

  moto-pstar-lineageos-22_1-kernelsu-next = baseKernel.override (_: rec {
    kernelSU = {
      inherit (kernelsuVariants.next)
        enable
        variant
        src
        revision
        subdirectory
        integrateMethod
        moduleSystemImpl
        ;
    };
    susfs = {
      enable = false;
      inherit (sources.AAAAA_susfs-4_19) src;
      kernelsuPatch = kernelsuVariants."${kernelSU.variant}".susfs_kernelsuPatch or "${emptyFile}";
      kernelPatch = "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/50_add_susfs_in_kernel-4.19.157.patch";
    };
  });

  moto-pstar-lineageos-22_1-kernelsu-rsuntk-susfs = baseKernel.override (_: rec {
    kernelSU = {
      inherit (kernelsuVariants.rsuntk-susfs)
        enable
        variant
        src
        revision
        subdirectory
        integrateMethod
        moduleSystemImpl
        ;
    };
    susfs = {
      enable = true;
      inherit (sources.AAAAA_susfs-4_19) src;
      kernelsuPatch = kernelsuVariants."${kernelSU.variant}".susfs_kernelsuPatch or "${emptyFile}";
      kernelPatch = "${sources.AAAAA_los-pstar-kernel-patches.src}/patches/4.19.157/50_add_susfs_in_kernel-4.19.157.patch";
    };
  });
}
