{
  stdenv,
  callPackage,
  autoPatchelfHook,
  python3,
}:
let
  sources = callPackage ../_sources/generated.nix { };
in
stdenv.mkDerivation {
  inherit (sources.android_prebuilts_clang_kernel_linux-x86_clang-r416183b) pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
}
