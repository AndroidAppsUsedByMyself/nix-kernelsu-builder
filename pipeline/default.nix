{
  lib,
  callPackage,
  runCommand,
  inputs,
  ...
}:
{
  arch,
  anyKernelVariant,
  build-toolchain,
  clangVersion,
  kernelSU,
  kernelConfig,
  gkiVersion ? null,
  clangPrebuilt ? null,
  customGoogleClang ? null,
  enableGcc32 ? false,
  enableGcc64 ? false,
  enableGccCompat ? false,
  enableLLVM ? true,
  enablePython2 ? false,
  kernelDefconfigs,
  kernelImageName,
  kernelMakeFlags,
  kernelPatches,
  kernelSrc,
  oemBootImg,
  susfs,
}:
let
  pipeline = rec {
    patchedKernelSrc = callPackage ./patch-kernel-src.nix {
      inherit kernelSU susfs;
      src = kernelSrc;
      patches = kernelPatches;
    };

    kernelBuildCustom = callPackage ./build-kernel-custom.nix {
      inherit
        arch
        clangPrebuilt
        customGoogleClang
        kernelSU
        susfs
        enableGcc64
        enableGcc32
        enableGccCompat
        enableLLVM
        enablePython2
        inputs
        ;
      src = patchedKernelSrc;
      defconfigs = kernelDefconfigs;
      makeFlags = kernelMakeFlags;
      extraKernelConfigs = kernelConfig;
    };

    kernelBuildClang = callPackage ./build-kernel-clang.nix {
      inherit
        arch
        clangVersion
        kernelSU
        susfs
        ;
      src = patchedKernelSrc;
      defconfigs = kernelDefconfigs;
      makeFlags = kernelMakeFlags;
      extraKernelConfigs = kernelConfig;
    };

    kernelBuildGcc = callPackage ./build-kernel-gcc.nix {
      inherit arch kernelSU susfs;
      src = patchedKernelSrc;
      defconfigs = kernelDefconfigs;
      makeFlags = kernelMakeFlags;
      extraKernelConfigs = kernelConfig;
    };

    kernelBuildGki = callPackage ./build-kernel-gki.nix {
      inherit
        arch
        kernelSU
        susfs
        gkiVersion
        ;
      src = patchedKernelSrc;
      defconfigs = kernelDefconfigs;
      makeFlags = kernelMakeFlags;
      extraKernelConfigs = kernelConfig;
    };

    kernelBuild =
      if build-toolchain == "gcc-only" then
        kernelBuildGcc
      else if build-toolchain == "clang-with-gcc" then
        kernelBuildCustom
      else if clangVersion == "gki" then
        kernelBuildGki
      else if build-toolchain == "clang-with-llvm" then
        kernelBuildClang
      else
        (_: lib.throw "function not implement");

    anykernelZip = callPackage ./build-anykernel-zip.nix {
      inherit arch kernelImageName;
      kernel = kernelBuild;
      variant = anyKernelVariant;
    };

    bootImg = callPackage ./build-boot-img.nix {
      inherit arch kernelImageName;
      bootImg = oemBootImg;
      kernel = kernelBuild;
    };
  };
in
runCommand "kernel-bundle" { passthru = pipeline; } (
  ''
    mkdir -p $out
    cp ${pipeline.kernelBuild}/arch/${arch}/boot/${kernelImageName} $out/
      if [ -f ${pipeline.kernelBuild}/arch/${arch}/boot/dtbo.img ]; then
        cp ${pipeline.kernelBuild}/arch/${arch}/boot/dtbo.img $out/
      fi
    cp ${pipeline.anykernelZip}/anykernel.zip $out/
  ''
  + (lib.optionalString (oemBootImg != null) ''
    cp ${pipeline.bootImg}/boot.img $out/
  '')
)
