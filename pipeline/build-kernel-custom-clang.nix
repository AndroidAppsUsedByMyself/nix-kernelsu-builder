{
  stdenv,
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
  clangPrebuilt,
  customGoogleClang,
  src,
  arch,
  defconfigs,
  enableKernelSU,
  makeFlags,
  additionalKernelConfig ? "",
  ...
}: let
  inherit customGoogleClang;
  finalMakeFlags =
    [
      "ARCH=${arch}"
      "CC=clang"
      "O=$out"
      "LD=ld.lld"
      "LLVM=1"
      "LLVM_IAS=1"
      "CLANG_TRIPLE=aarch64-linux-gnu-"
    ]
    ++ makeFlags;

  defconfig = lib.last defconfigs;
in
  stdenv.mkDerivation {
    name = "clang-kernel-${clangPrebuilt}";
    inherit src;

    nativeBuildInputs =
      [
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
      ]
      ++ (
        if customGoogleClang.CLANG_VERSION != null && customGoogleClang.CLANG_BRANCH != null
        then [
          (pkgs.callPackage ../pkgs/android_prebuilts_clang_custom.nix {inherit customGoogleClang;})
        ]
        else []
      )
      ++ (
        if clangPrebuilt != null
        then [(pkgs.callPackage (../. + "/pkgs/${clangPrebuilt}.nix") {})]
        else []
      );

    hardeningDisable = ["all"];

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
