{
  stdenvNoCC,
  pkgs,
  lib,
  pkg-config,
  glibc,
  gcc,
  wrapCC,
  bc,
  bison,
  coreutils,
  cpio,
  elfutils,
  flex,
  gmp,
  kmod,
  libmpc,
  mpfr,
  nettools,
  openssl,
  pahole,
  perl,
  python3,
  rsync,
  ubootTools,
  which,
  zlib,
  zstd,
  # User args
  clangPrebuilt,
  enableGcc32,
  enableGcc64,
  enableGccCompat,
  enableLLVM,
  enablePython2,
  inputs,
  src,
  arch,
  defconfigs,
  kernelSU,
  susfs,
  makeFlags,
  additionalKernelConfig ? "",
  ...
}:
let
  gcc-aarch64-linux-android = pkgs.callPackage ../pkgs/gcc-aarch64-linux-android.nix { };
  gcc-arm-linux-androideabi = pkgs.callPackage ../pkgs/gcc-arm-linux-androideabi.nix { };
  finalMakeFlags = [
    "ARCH=${arch}"
    "CC=clang"
    "O=$out"
    "LD=ld.lld"
    "CLANG_TRIPLE=aarch64-linux-gnu-"
    (lib.optionalString enableLLVM "LLVM=1")
    (lib.optionalString enableLLVM "LLVM_IAS=1")
    (lib.optionalString enableGcc32 "CROSS_COMPILE_ARM32=arm-linux-androideabi-")
    (lib.optionalString enableGcc64 "CROSS_COMPILE=aarch64-linux-android-")
    (lib.optionalString enableGccCompat "CROSS_COMPILE_COMPAT=arm-linux-android-")
  ] ++ makeFlags;

  defconfig = lib.last defconfigs;
  kernelConfigCmd = pkgs.callPackage ./kernel-config-cmd.nix {
    inherit
      arch
      defconfig
      defconfigs
      additionalKernelConfig
      kernelSU
      susfs
      finalMakeFlags
      ;
  };
in
stdenvNoCC.mkDerivation {
  name = "clang-kernel";
  inherit src;

  nativeBuildInputs =
    [
      gcc
      pkg-config
      glibc
      bc
      bison
      coreutils
      cpio
      elfutils
      flex
      gmp
      kmod
      libmpc
      mpfr
      nettools
      openssl
      pahole
      perl
      python3
      rsync
      ubootTools
      which
      zlib
      zstd
    ]
    ++ (if enableGcc64 then [ gcc-aarch64-linux-android ] else [ ])
    ++ (if enableGcc32 then [ gcc-arm-linux-androideabi ] else [ ])
    ++ (if enablePython2 then [ inputs.nixpkgs-python.packages.${pkgs.system}."2.7" ] else [ ])
    ++ (
      if clangPrebuilt != null then
        if lib.isString clangPrebuilt then
          [
            (wrapCC (pkgs.callPackage (../. + "/pkgs/${clangPrebuilt}.nix") { }))
          ]
        else if lib.isDerivation clangPrebuilt then
          [
            (wrapCC clangPrebuilt)
          ]
        else
          [ ]
      else
        [ ]
    );

  hardeningDisable = [ "all" ];

  buildPhase = ''
    runHook preBuild

    ${kernelConfigCmd}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make -j$(nproc) ${builtins.concatStringsSep " " finalMakeFlags}

    runHook postInstall
  '';

  dontFixup = true;
}
