# manually packing custom clang example
{
  stdenv,
  callPackage,
  autoPatchelfHook,
  python39,
  libz,
  ...
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  stdenv.mkDerivation {
    inherit (sources.AAAAA_android_prebuilts_clang_kernel_linux-x86_clang-r416183b) pname version src;

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
