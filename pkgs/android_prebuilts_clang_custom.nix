{
  stdenv,
  autoPatchelfHook,
  python39,
  libz,
  libtinfo,
  ncurses,
  customGoogleClang,
  ...
}:
let
  useClangRev =
    customGoogleClang ? CLANG_REV
    && customGoogleClang.CLANG_REV != ""
    && customGoogleClang.CLANG_REV != null;

  ClangSource =
    if useClangRev then
      {
        pname = "clang-rev=${customGoogleClang.CLANG_REV}-version=${customGoogleClang.CLANG_VERSION}";
        version = customGoogleClang.CLANG_VERSION;
        src = fetchTarball {
          url = "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/${customGoogleClang.CLANG_REV}/clang-${customGoogleClang.CLANG_VERSION}.tar.gz";
          sha256 = customGoogleClang.CLANG_SHA256;
        };
      }
    else
      {
        pname = "clang-branch=${customGoogleClang.CLANG_BRANCH}-version=${customGoogleClang.CLANG_VERSION}";
        version = customGoogleClang.CLANG_VERSION;
        src = fetchTarball {
          url = "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/${customGoogleClang.CLANG_BRANCH}/clang-${customGoogleClang.CLANG_VERSION}.tar.gz";
          sha256 = customGoogleClang.CLANG_SHA256;
        };
      };
in
stdenv.mkDerivation {
  inherit (ClangSource) pname version src;
  nativeBuildInputs = [ autoPatchelfHook ];
  autoPatchelfIgnoreMissingDeps = [
    "liblog.so"
    "libtinfo.so.5"
    "libpython3.8.so.1.0"
    "libncurses.so.5"
    "libtinfo.so.5"
    "libpanel.so.5"
    "libform.so.5"
  ];
  buildInputs = [
    python39
    libz
    libtinfo
    ncurses
  ];

  postPatch = ''
    rm -r python3  # 移除冲突的Python目录
  '';

  installPhase = ''
    mkdir -p $out
    cp -r . $out/  # 安装所有内容到输出目录
  '';
}
