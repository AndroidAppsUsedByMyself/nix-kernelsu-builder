{
  stdenvNoCC,
  callPackage,
  autoPatchelfHook,
  python39,
  gcc,
  glibc,
  sqlite,
  openssl,
  libz,
  ...
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  stdenvNoCC.mkDerivation {
    inherit (sources.android_prebuilts_clang_kernel_linux-x86_clang-r416183b) pname version src;

    nativeBuildInputs = [autoPatchelfHook];
    autoPatchelfIgnoreMissingDeps = ["liblog.so"];
    buildInputs = [
      python39
      libz
    ];

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
      rm -rf $out/python3
    '';
  }
