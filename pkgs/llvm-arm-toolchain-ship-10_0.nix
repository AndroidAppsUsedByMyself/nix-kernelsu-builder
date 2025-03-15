# manually packing custom clang example
{
  stdenv,
  callPackage,
  autoPatchelfHook,
  python39,
  libz,
  ...
}:
let
  sources = callPackage ../_sources/generated.nix { };
in
stdenv.mkDerivation {
  inherit (sources.llvm-arm-toolchain-ship-10_0) pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];
  autoPatchelfIgnoreMissingDeps = [ "liblog.so" ];
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
