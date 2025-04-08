{
  lib,
  pkgs,
  config,
  sources,
  ...
}:
let
  emptyFile = pkgs.writeText {
    name = "empty";
    text = "";
  };
  kernelsuVariants = {
    # builtin variants do not require these fields
    rsuntk = {
      enable = true;
      variant = "rsuntk";
      src = null;
      revision = null;
      subdirectory = null;
    };
    next = {
      enable = true;
      variant = "next";
      src = null;
      revision = null;
      subdirectory = null;
    };

    rsuntk-susfs = {
      enable = true;
      variant = "rsuntk-susfs";
      inherit (sources.kernelsu-rksu-susfs) src;
      revision = sources.kernelsu-rksu-susfs-revision-code.version;
      subdirectory = "KernelSU";
      susfs_kernelsuPatch = emptyFile;
    };
  };

  kernelsuMagicVariants = [
    "rsuntk-susfs"
    "rsuntk"
    "next"
  ];
  mkKernel = lib.makeOverridable (
    {
      susfs ? {
        enable = false;
        inherit (sources.susfs-4_19) src;
        kernelsuPatch = kernelSU.susfs_kernelsuPatch or emptyFile;
        kernelPatch = "${sources.los-pstar-kernel-patches.src}/patches/4.19.157/50_add_susfs_in_kernel-4.19.157.patch";
      },
      kernelSU ? kernelsuVariants.rsuntk,
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
      kernelConfig ?
        ''
          CONFIG_MODULE_FORCE_LOAD?y
          CONFIG_MODULE_SIG_FORCE?n
        ''
        + (
          if (susfs.enable && (builtins.elem kernelSU.variant kernelsuMagicVariants)) then
            ''
              KSU_SUSFS_HAS_MAGIC_MOUNT?y
            ''
          else
            ""
        ),
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

  moto-pstar-lineageos-22_1-kernelsu-rsuntk = baseKernel.override (_old: {
    kernelSU = kernelsuVariants.rsuntk;
  });

  moto-pstar-lineageos-22_1-kernelsu-next = baseKernel.override (_old: {
    kernelSU = kernelsuVariants.next;
  });

  moto-pstar-lineageos-22_1-kernelsu-rsuntk-susfs = baseKernel.override (old: {
    kernelSU = kernelsuVariants.rsuntk-susfs;
    susfs = old.susfs // {
      enable = true;
      kernelsuPatch = emptyFile;
    };
  });
}
