{
  fetchFromGitHub,
  stdenv,
  callPackage,
  autoPatchelfHook,
  python39,
  libz,
  zlib,
  ncurses5,
  libedit,
  customGoogleClang,
  ...
}: let
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
      zlib
      ncurses5
      libedit
      stdenv.cc.cc.lib # For libstdc++.so.6
      python39 # LLDB links against this particular version of python
    ];

    postPatch = ''
      rm -r python3
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  }
