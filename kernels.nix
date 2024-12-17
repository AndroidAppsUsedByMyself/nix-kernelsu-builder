{ callPackage, sources, ... }:
let
  pipeline = callPackage ./pipeline { };
in
{
  amazon-fire-hd-karnak = pipeline {
    anyKernelVariant = "osm0sis";
    enableKernelSU = false;
    kernelDefconfigs = [ "lineageos_karnak_defconfig" ];
    kernelImageName = "Image.gz-dtb";
    kernelMakeFlags = [
      "KCFLAGS=\"-w\""
      "KCPPFLAGS=\"-w\""
    ];
    kernelSrc = sources.linux-amazon-karnak.src;
    oemBootImg = boot/amazon-fire-hd-karnak.img;
  };

  moto-rtwo-lineageos-21 = pipeline {
    anyKernelVariant = "kernelsu";
    clangVersion = "latest";
    kernelDefconfigs = [
      "gki_defconfig"
      "vendor/kalama_GKI.config"
      "vendor/ext_config/moto-kalama.config"
      "vendor/ext_config/moto-kalama-gki.config"
      "vendor/ext_config/moto-kalama-rtwo.config"
    ];
    kernelImageName = "Image";
    kernelMakeFlags = [
      "KCFLAGS=\"-w\""
      "KCPPFLAGS=\"-w\""
    ];
    kernelSrc = sources.linux-moto-rtwo-lineageos-21.src;
  };

  oneplus-8t-blu-spark = pipeline {
    anyKernelVariant = "osm0sis";
    clangVersion = "latest";
    kernelDefconfigs = [ "blu_spark_defconfig" ];
    kernelImageName = "Image";
    kernelSrc = sources.linux-oneplus-8t-blu-spark.src;
    kernelConfig = ''
      CONFIG_STACKPROTECTOR=n
      CONFIG_LTO_CLANG=y
    '';
  };

  moto-pstar-lineageos-22_0 = pipeline {
    anyKernelVariant = "kernelsu";
    clangVersion = "custom";
    # clangPrebuilt = "android_prebuilts_clang_kernel_linux-x86_clang-r416183b";
    customGoogleClang = {
      CLANG_VERSION = "r416183b1";
      CLANG_BRANCH = "android12-release";
      CLANG_SHA256 = "1zg1cm8zn8prawgz3h1qnapxrgkmj894pl10i1q11nfcv3ycic41";
    };
    kernelDefconfigs = [
      "lineageos_pstar_stock_defconfig"
    ];
    kernelImageName = "Image";
    kernelMakeFlags = [
      "KCFLAGS=\"-w\""
      "KCPPFLAGS=\"-w\""
    ];
    kernelSrc = sources.linux-moto-pstar-lineageos-22_0.src;
  };
}
