{
  stdenv,
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
  customGoogleClang,
  enableGcc32,
  enableGcc64,
  enableLLVM,
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
  inherit customGoogleClang;
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
stdenv.mkDerivation {
  name = "clang-kernel-${
    if
      customGoogleClang != null
      && customGoogleClang.CLANG_VERSION != null
      && customGoogleClang.CLANG_BRANCH != null
    then
      "${customGoogleClang.CLANG_BRANCH}-${customGoogleClang.CLANG_VERSION}"
    else if clangPrebuilt != null then
      clangPrebuilt
    else
      ""
  }";
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
    ++ (
      if
        customGoogleClang != null
        && customGoogleClang.CLANG_VERSION != null
        && customGoogleClang.CLANG_BRANCH != null
      then
        [
          (wrapCC (
            pkgs.callPackage ../pkgs/android_prebuilts_clang_custom.nix { inherit customGoogleClang; }
          ))
        ]
      else if clangPrebuilt != null then
        if lib.isString clangPrebuilt then
          [
            (wrapCC (pkgs.callPackage (../. + "/pkgs/${clangPrebuilt}.nix") { }))
          ]
        else if lib.isDerivation then
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
