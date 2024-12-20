{
  stdenv,
  pkgs,
  lib,
  pkg-config,
  glibc,
  gcc,
  gcc-unwrapped,
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
  enableKernelSU,
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
    (lib.optionalString enableGcc32 "${gcc-arm-linux-androideabi}/bin/arm-linux-androideabi-")
    (lib.optionalString enableGcc64 "i${gcc-aarch64-linux-android}/bin/aarch64-linux-android-")
  ] ++ makeFlags;

  defconfig = lib.last defconfigs;
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

  buildPhase =
    ''
      runHook preBuild

      export CFG_PATH=arch/${arch}/configs/${defconfig}
      cat >>$CFG_PATH <<EOF
      ${additionalKernelConfig}
      EOF
    ''
    + (lib.optionalString enableKernelSU ''
      # Inject KernelSU options
      echo "CONFIG_MODULES=y" >> $CFG_PATH
      echo "CONFIG_KPROBES=y" >> $CFG_PATH
      echo "CONFIG_HAVE_KPROBES=y" >> $CFG_PATH
      echo "CONFIG_KPROBE_EVENTS=y" >> $CFG_PATH
      echo "CONFIG_OVERLAY_FS=y" >> $CFG_PATH
    '')
    + ''

      export LD_LIBRARY_PATH=${gcc-aarch64-linux-android}/lib:${gcc-arm-linux-androideabi}/lib:${gcc-unwrapped}/lib:$LD_LIBRARY_PATH
      export LIBRARY_PATH=${gcc-aarch64-linux-android}/lib:${gcc-arm-linux-androideabi}/lib:${gcc-unwrapped}/lib:$LIBRARY_PATH

      mkdir -p $out
      make ${builtins.concatStringsSep " " (finalMakeFlags ++ defconfigs)}

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    make -j$(nproc) ${builtins.concatStringsSep " " finalMakeFlags}

    runHook postInstall
  '';

  dontFixup = true;
}
