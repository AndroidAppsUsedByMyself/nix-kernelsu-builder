# manually packing custom clang example
{
  stdenv,
  callPackage,
  autoPatchelfHook,
  libz,
  libtinfo,
  lib,
  glibc,
  libxml2,
  ...
}:
let
  sources = callPackage ../_sources/generated.nix { };
in
stdenv.mkDerivation {
  inherit (sources.AAAAA_llvm-arm-toolchain-ship-10_0) pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];
  autoPatchelfIgnoreMissingDeps = [
    # TODO:
    # I wonder how to have old library if we do not import a old nixpkgs
    "libclang.so.10"
    "libstdc++.so.6"
    "liblog.so"
    "libgcc_s.so.1"
  ];
  buildInputs = [
    libz
    libtinfo
    (lib.getLib glibc)
    libxml2
  ];

  LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-lgcc_s";
  NIX_CFLAGS_LINK = [
    # to avoid occasional runtime error in finding libgcc_s.so.1
    "-lgcc_s"
  ];
  installPhase = ''
    mkdir -p $out
    cp -r . $out/
    find $out/bin $out/lib -type f -exec sh -c '
      file -b "$1" | grep -q "^ELF " && patchelf --replace-needed libtinfo.so.5 libtinfo.so.6 "$1"
    ' sh {} \;
  '';
}
