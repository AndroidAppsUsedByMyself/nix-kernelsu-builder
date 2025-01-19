{
  pkgs,
  lib,
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
  gkiVersion,
  src,
  arch,
  enableKernelSU,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "gki-kernel-${builtins.toString gkiVersion}";
  inherit src;

  nativeBuildInputs = [
    bc
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

  ];

  hardeningDisable = [ "all" ];

  buildPhase =
    ''
      runHook preBuild

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
      mkdir -p $out

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    if [[ "${gkiVersion}" == "android16-6.12" ]]; then
      if [ "${arch}" = "aarch64" ] || [ "${arch}" = "arm64" ]; then
        tools/bazel run --config=fast --lto=thin //common:kernel_aarch64_dist
      elif [ "${arch}" = "x86_64" ]; then
        tools/bazel run --config=fast --lto=thin //common:kernel_x86_64_dist
      fi
    else
      if [ "${arch}" = "aarch64" ] || [ "${arch}" = "arm64" ]; then
        if [ -e build/build.sh ]; then
          LTO=thin BUILD_CONFIG=common/build.config.gki.aarch64 build/build.sh CC="/usr/bin/ccache clang"
        else
          tools/bazel run --config=fast --lto=thin //common:kernel_aarch64_dist -- --dist_dir=dist
        fi
      elif [ "${arch}" = "x86_64" ]; then
        if [ -e build/build.sh ]; then
          LTO=thin BUILD_CONFIG=common/build.config.gki.x86_64 build/build.sh CC="/usr/bin/ccache clang"
        else
          tools/bazel run --config=fast --lto=thin //common:kernel_x86_64_dist -- --dist_dir=dist
        fi
      fi
    fi

    mv dist/* $out

    runHook postInstall
  '';

  dontFixup = true;
}
