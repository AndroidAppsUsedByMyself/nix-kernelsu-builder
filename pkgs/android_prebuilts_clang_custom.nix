{
  fetchFromGitHub,
  stdenv,
  callPackage,
  autoPatchelfHook,
  python39,
  libz,
  gcc,
  customGoogleClang,
  ...
}: let
  gcc-aarch64-linux-android = callPackage ../pkgs/gcc-aarch64-linux-android.nix {};
  gcc-arm-linux-androideabi = callPackage ../pkgs/gcc-arm-linux-androideabi.nix {};
  inherit (customGoogleClang) CLANG_BRANCH CLANG_VERSION CLANG_SHA256;
in
  stdenv.mkDerivation {
    pname = "clang-${CLANG_BRANCH + CLANG_VERSION}";
    version = CLANG_VERSION;
    src = fetchTarball {
      url = "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/${CLANG_BRANCH}/clang-${CLANG_VERSION}.tar.gz";
      sha256 = CLANG_SHA256;
    };
    nativeBuildInputs = [autoPatchelfHook];
    autoPatchelfIgnoreMissingDeps = ["liblog.so"];
    buildInputs = [
      python39
      libz
    ];

    postPatch = ''
      rm -r python3
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  }
