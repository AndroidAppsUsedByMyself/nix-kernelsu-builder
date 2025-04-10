{
  stdenv,
  # User args
  kernel,
  ...
}:
stdenv.mkDerivation {
  name = "kernelConfigOutput";
  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp ${kernel}/.config $out/kernelConfigOutput

    runHook postInstall
  '';

  dontFixup = true;
}
