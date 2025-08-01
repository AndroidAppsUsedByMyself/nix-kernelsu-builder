# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  android_kernel_samsung_lykanlte = {
    pname = "android_kernel_samsung_lykanlte";
    version = "c7e14de69d0124bf1827325aba013ec7b25e5bcb";
    src = fetchFromGitHub {
      owner = "DataEraserC";
      repo = "android_kernel_samsung_lykanlte";
      rev = "c7e14de69d0124bf1827325aba013ec7b25e5bcb";
      fetchSubmodules = true;
      sha256 = "sha256-AP9m+TwFJXQ1AusKl6ZuNK9Jv+D5B/akaZ/6La3Z+t8=";
    };
    date = "2025-03-17";
  };
  android_kernel_samsung_sm8250_TabS7 = {
    pname = "android_kernel_samsung_sm8250_TabS7";
    version = "a06a3c6904d3a7c7fd4d09769d18a44053fcca7e";
    src = fetchFromGitHub {
      owner = "DataEraserC";
      repo = "android_kernel_samsung_sm8250_TabS7";
      rev = "a06a3c6904d3a7c7fd4d09769d18a44053fcca7e";
      fetchSubmodules = true;
      sha256 = "sha256-dHwai7E/e4Y/V4SnGwNJchRjkbS01IKuDZQmiT9ifyI=";
    };
    date = "2025-03-15";
  };
  android_prebuilts_clang_kernel_linux-x86_clang-r416183b = {
    pname = "android_prebuilts_clang_kernel_linux-x86_clang-r416183b";
    version = "54220fd601050b350b2af7adc913089ebf0e7aed";
    src = fetchFromGitHub {
      owner = "LineageOS";
      repo = "android_prebuilts_clang_kernel_linux-x86_clang-r416183b";
      rev = "54220fd601050b350b2af7adc913089ebf0e7aed";
      fetchSubmodules = false;
      sha256 = "sha256-o9e5VRR6s2T9NDwDY8XuG2GYUKbZQF1s687gPlE0+RY=";
    };
    date = "2022-11-01";
  };
  anykernel-kernelsu = {
    pname = "anykernel-kernelsu";
    version = "ac6360f6fc1895cbd218246f12a771f63d0e5e4f";
    src = fetchFromGitHub {
      owner = "Kernel-SU";
      repo = "AnyKernel3";
      rev = "ac6360f6fc1895cbd218246f12a771f63d0e5e4f";
      fetchSubmodules = false;
      sha256 = "sha256-lWqFsucmu6tyLJd4JbNxbBPDRcArQ2KaSUeaqFH73cA=";
    };
    date = "2025-05-17";
  };
  anykernel-osm0sis = {
    pname = "anykernel-osm0sis";
    version = "6f88dff82b786e879b255a8e1523547c4f62d031";
    src = fetchFromGitHub {
      owner = "osm0sis";
      repo = "AnyKernel3";
      rev = "6f88dff82b786e879b255a8e1523547c4f62d031";
      fetchSubmodules = false;
      sha256 = "sha256-0BRHE7O3rcgLa6wg8GVPu9R0MDsA87D6jGbA7bHZ7N0=";
    };
    date = "2025-05-18";
  };
  gcc-aarch64-linux-android = {
    pname = "gcc-aarch64-linux-android";
    version = "5797d7f622321e734558bd3372a9ab5ad6e6a48e";
    src = fetchFromGitHub {
      owner = "kindle4jerry";
      repo = "aarch64-linux-android-4.9-bakup";
      rev = "5797d7f622321e734558bd3372a9ab5ad6e6a48e";
      fetchSubmodules = false;
      sha256 = "sha256-ZrQmFyiDOKg+qcgdpZqtz+LgDDaao2W27kdZZ2As8XU=";
    };
    date = "2020-02-22";
  };
  gcc-arm-linux-androideabi = {
    pname = "gcc-arm-linux-androideabi";
    version = "3ecb542702c2ca0e502533c3f6d02f0f06f584f1";
    src = fetchFromGitHub {
      owner = "KudProject";
      repo = "arm-linux-androideabi-4.9";
      rev = "3ecb542702c2ca0e502533c3f6d02f0f06f584f1";
      fetchSubmodules = false;
      sha256 = "sha256-5aF2Pl+h6J8/5TfQf2ojp3FCnoKakWH6KBCkWdy5ho8=";
    };
    date = "2019-11-25";
  };
  kernelsu-next = {
    pname = "kernelsu-next";
    version = "v1.0.9";
    src = fetchgit {
      url = "https://github.com/rifsxd/KernelSU-Next.git";
      rev = "v1.0.9";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-tNSNZQcpogTm/veYKCoA9Y5FrdsQSZCNgw+DzkuqN80=";
    };
  };
  kernelsu-next-revision-code = {
    pname = "kernelsu-next-revision-code";
    version = "12797";
    src = fetchurl {
      url = "https://example.com";
      sha256 = "sha256-6o+sfGX7WJsNU1YPUlH3T56bJDR43Laz6nm142RJyNk=";
    };
  };
  kernelsu-rksu = {
    pname = "kernelsu-rksu";
    version = "v1.0.5-10-legacy";
    src = fetchgit {
      url = "https://github.com/rsuntk/KernelSU.git";
      rev = "v1.0.5-10-legacy";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-O9mwIIxRo0P2ijxOfC68gVT1zNpLzJyBOC+E6G8jnLg=";
    };
  };
  kernelsu-rksu-revision-code = {
    pname = "kernelsu-rksu-revision-code";
    version = "12164";
    src = fetchurl {
      url = "https://example.com";
      sha256 = "sha256-6o+sfGX7WJsNU1YPUlH3T56bJDR43Laz6nm142RJyNk=";
    };
  };
  kernelsu-rksu-susfs = {
    pname = "kernelsu-rksu-susfs";
    version = "e96aca34ffca2c78c2fdf8537d9c466887f358b0";
    src = fetchFromGitHub {
      owner = "rsuntk";
      repo = "KernelSU";
      rev = "e96aca34ffca2c78c2fdf8537d9c466887f358b0";
      fetchSubmodules = false;
      sha256 = "sha256-WcLiF57fiQGUg/nEL79J7YTK6LdGrmlxIJ3O9pQcJ38=";
    };
    date = "2025-03-15";
  };
  kernelsu-rksu-susfs-revision-code = {
    pname = "kernelsu-rksu-susfs-revision-code";
    version = "12164";
    src = fetchurl {
      url = "https://example.com";
      sha256 = "sha256-6o+sfGX7WJsNU1YPUlH3T56bJDR43Laz6nm142RJyNk=";
    };
  };
  kernelsu-stable = {
    pname = "kernelsu-stable";
    version = "v0.9.5";
    src = fetchgit {
      url = "https://github.com/tiann/KernelSU.git";
      rev = "v0.9.5";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-pvaL6KEB7X3s8zyLQSPhBhoXaNdVDthH7HnAZRE9JYk=";
    };
  };
  kernelsu-stable-revision-code = {
    pname = "kernelsu-stable-revision-code";
    version = "11872";
    src = fetchurl {
      url = "https://example.com";
      sha256 = "sha256-6o+sfGX7WJsNU1YPUlH3T56bJDR43Laz6nm142RJyNk=";
    };
  };
  lineage-nightly-pstar_bootImg = {
    pname = "lineage-nightly-pstar_bootImg";
    version = "20250728";
    src = fetchurl {
      url = "https://mirrorbits.lineageos.org/full/pstar/20250728/boot.img";
      sha256 = "sha256-6T4mYQyxzaEn7wXVaXMD7X7bAjbiSCmQkcsRj8JMlTM=";
    };
  };
  linux-amazon-karnak = {
    pname = "linux-amazon-karnak";
    version = "e22c713c7c4f0c8d08267f6bba98b8c4cde8310f";
    src = fetchFromGitHub {
      owner = "mt8163";
      repo = "android_kernel_amazon_karnak_4.9";
      rev = "e22c713c7c4f0c8d08267f6bba98b8c4cde8310f";
      fetchSubmodules = false;
      sha256 = "sha256-viqlQBPd2SuiAphFKiwjtckC3gDTGkbLv2dgZKMP3Oc=";
    };
    date = "2023-10-09";
  };
  linux-moto-pstar-lineageos-22_1 = {
    pname = "linux-moto-pstar-lineageos-22_1";
    version = "8a06559e98bb6685033d8771865bac00e9618cce";
    src = fetchFromGitHub {
      owner = "AndroidAppsUsedByMyself";
      repo = "android_kernel_motorola_sm8250";
      rev = "8a06559e98bb6685033d8771865bac00e9618cce";
      fetchSubmodules = false;
      sha256 = "sha256-yrjP65l1U5DwEdhyuu1AsJdfa78qXaqHqt53gBOvWEQ=";
    };
    date = "2025-03-15";
  };
  linux-moto-rtwo-lineageos-21 = {
    pname = "linux-moto-rtwo-lineageos-21";
    version = "1bdeb4f5c8d2b98ef5f2bedaa5d704032dffd676";
    src = fetchFromGitHub {
      owner = "LineageOS";
      repo = "android_kernel_motorola_sm8550";
      rev = "1bdeb4f5c8d2b98ef5f2bedaa5d704032dffd676";
      fetchSubmodules = false;
      sha256 = "sha256-ZK/DH5N5LdkLe48cANESjw1x74aXoZLFoMAwEDvzEk4=";
    };
    date = "2024-12-21";
  };
  linux-moto-rtwo-lineageos-22_1 = {
    pname = "linux-moto-rtwo-lineageos-22_1";
    version = "e12cc3a36c10596aced0e84a0e08072161c45f63";
    src = fetchFromGitHub {
      owner = "LineageOS";
      repo = "android_kernel_motorola_sm8550";
      rev = "e12cc3a36c10596aced0e84a0e08072161c45f63";
      fetchSubmodules = false;
      sha256 = "sha256-KZSIus0Ws7FM4O9zyxmdPvGcYsXv/rubwnOuwgo7yHw=";
    };
    date = "2025-03-28";
  };
  linux-oneplus-13 = {
    pname = "linux-oneplus-13";
    version = "f9c1a38fe1bf6bf39f25e4167e8322813c7707b9";
    src = fetchFromGitHub {
      owner = "OnePlusOSS";
      repo = "android_kernel_common_oneplus_sm8750";
      rev = "f9c1a38fe1bf6bf39f25e4167e8322813c7707b9";
      fetchSubmodules = false;
      sha256 = "sha256-AuuEp9d8LCIjfeIPMFd0sIjet+koH1ffjZr45X4gyVY=";
    };
    date = "2025-04-21";
  };
  linux-oneplus-8t-blu-spark = {
    pname = "linux-oneplus-8t-blu-spark";
    version = "64c109e3f3ba97fa7aed730ab7b4238b91df028b";
    src = fetchFromGitHub {
      owner = "engstk";
      repo = "op8";
      rev = "64c109e3f3ba97fa7aed730ab7b4238b91df028b";
      fetchSubmodules = false;
      sha256 = "sha256-KWLtY7KWhHmk6LVYpvIz6XT93+yjteex/250crk9Lxw=";
    };
    date = "2024-12-26";
  };
  linux-xiaomi-gauguin-lineageos-22_1 = {
    pname = "linux-xiaomi-gauguin-lineageos-22_1";
    version = "8d52ff9a898e05001383345eb882a488be38f59a";
    src = fetchFromGitHub {
      owner = "LineageOS";
      repo = "android_kernel_xiaomi_gauguin";
      rev = "8d52ff9a898e05001383345eb882a488be38f59a";
      fetchSubmodules = false;
      sha256 = "sha256-/6K3MBk7R/YCgKq7aW0vxxcn0pDMETZOjHx20XvA/ig=";
    };
    date = "2025-04-02";
  };
  llvm-arm-toolchain-ship-10_0 = {
    pname = "llvm-arm-toolchain-ship-10_0";
    version = "c6aaf7026bd49a06e12ec0551285ffded148d186";
    src = fetchFromGitHub {
      owner = "proprietary-stuff";
      repo = "llvm-arm-toolchain-ship-10.0";
      rev = "c6aaf7026bd49a06e12ec0551285ffded148d186";
      fetchSubmodules = false;
      sha256 = "sha256-PwJj4yZv/FotEncyw5nZmw5upUz7gx35TdDCVkb0+xU=";
    };
    date = "2020-09-27";
  };
  los-pstar-kernel-patches = {
    pname = "los-pstar-kernel-patches";
    version = "9ae66533892ed7bb8262cf4a49fa986e14c3e0f8";
    src = fetchFromGitHub {
      owner = "AndroidAppsUsedByMyself";
      repo = "kernel_patches";
      rev = "9ae66533892ed7bb8262cf4a49fa986e14c3e0f8";
      fetchSubmodules = false;
      sha256 = "sha256-lDor+o7BKpYeWI16oX+I0Etwgi0bv0n2HuPWiGjChQA=";
    };
    date = "2025-04-11";
  };
  oneplus-13-sched-ext = {
    pname = "oneplus-13-sched-ext";
    version = "7ab1d04d5cb622d6c32c932add617803074ec5a7";
    src = fetchFromGitHub {
      owner = "HanKuCha";
      repo = "sched_ext";
      rev = "7ab1d04d5cb622d6c32c932add617803074ec5a7";
      fetchSubmodules = false;
      sha256 = "sha256-GamqRqQDjssYudTAfpwXuVbdEZfwWVOLBipagn9WkHw=";
    };
    date = "2025-06-14";
  };
  sukisu = {
    pname = "sukisu";
    version = "7c4d8da7d1144cb9072ba7a1d4779b099998f39c";
    src = fetchFromGitHub {
      owner = "SukiSU-Ultra";
      repo = "SukiSU-Ultra";
      rev = "7c4d8da7d1144cb9072ba7a1d4779b099998f39c";
      fetchSubmodules = false;
      sha256 = "sha256-nfnzY7x8O7NGh3QcFWEXe55X/N2LaypOEbbvSQ1govE=";
    };
    date = "2025-07-31";
  };
  sukisu-nongki = {
    pname = "sukisu-nongki";
    version = "51c0ba02e1c034ce3d782c280580259f1c4036bc";
    src = fetchFromGitHub {
      owner = "SukiSU-Ultra";
      repo = "SukiSU-Ultra";
      rev = "51c0ba02e1c034ce3d782c280580259f1c4036bc";
      fetchSubmodules = false;
      sha256 = "sha256-MNRgItAm85R2I98LPSKT7oCzfr2nzBjDA+3yu+VO6DU=";
    };
    date = "2025-07-29";
  };
  sukisu-patch = {
    pname = "sukisu-patch";
    version = "4493b2405563bcb3a8f459e32dd66b9e11aefcd9";
    src = fetchFromGitHub {
      owner = "SukiSU-Ultra";
      repo = "SukiSU_patch";
      rev = "4493b2405563bcb3a8f459e32dd66b9e11aefcd9";
      fetchSubmodules = false;
      sha256 = "sha256-ILLFShPcyq0HYIZPAvPmLjYtFhaM6RPHr1y/0koDx1A=";
    };
    date = "2025-07-03";
  };
  sukisu-revision-code = {
    pname = "sukisu-revision-code";
    version = "13250";
    src = fetchurl {
      url = "https://example.com";
      sha256 = "sha256-6o+sfGX7WJsNU1YPUlH3T56bJDR43Laz6nm142RJyNk=";
    };
  };
  sukisu-susfs = {
    pname = "sukisu-susfs";
    version = "323a8d4b39ec92ea82d10ffb740d0d9492c000d3";
    src = fetchFromGitHub {
      owner = "SukiSU-Ultra";
      repo = "SukiSU-Ultra";
      rev = "323a8d4b39ec92ea82d10ffb740d0d9492c000d3";
      fetchSubmodules = false;
      sha256 = "sha256-+4dLJX3ma/92zCiz3u045ohRpEtVgDTL9Ipf7sAZWFw=";
    };
    date = "2025-07-29";
  };
  susfs-4_19 = {
    pname = "susfs-4_19";
    version = "001e69919c6271f690fd00b17e4c721c9e599152";
    src = fetchgit {
      url = "https://gitlab.com/simonpunk/susfs4ksu.git";
      rev = "001e69919c6271f690fd00b17e4c721c9e599152";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-j4OIvgOE64nm67NyGsEnSRNygVVZaF5uhMx8ju+p6fQ=";
    };
    date = "2025-02-23";
  };
  susfs-android13-5_15 = {
    pname = "susfs-android13-5_15";
    version = "b7d8da20160bf6ad550226b40e2aad6bb48f415c";
    src = fetchgit {
      url = "https://gitlab.com/simonpunk/susfs4ksu.git";
      rev = "b7d8da20160bf6ad550226b40e2aad6bb48f415c";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-t9pneRj+T8ndqvnhOimR5FhKr4xrBNZcs76XDx4a6p4=";
    };
    date = "2025-07-26";
  };
  susfs-android15-6_6 = {
    pname = "susfs-android15-6_6";
    version = "1969c6e4a8982bf405df452b187992950680779c";
    src = fetchgit {
      url = "https://gitlab.com/simonpunk/susfs4ksu.git";
      rev = "1969c6e4a8982bf405df452b187992950680779c";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-APjI95KaahNxoSBnruQewHRLBgAG/K5kD+5OK+RoBb8=";
    };
    date = "2025-07-26";
  };
  wildplus-kernel-patches = {
    pname = "wildplus-kernel-patches";
    version = "6ebdb68e9343f2d111b79991853c5e36336f653c";
    src = fetchFromGitHub {
      owner = "WildPlusKernel";
      repo = "kernel_patches";
      rev = "6ebdb68e9343f2d111b79991853c5e36336f653c";
      fetchSubmodules = false;
      sha256 = "sha256-zCTg4pBQYgJfKgZaV81QBuQHwTEPDtJ0GiP+mqFQugw=";
    };
    date = "2025-07-28";
  };
  ztc1997-android_gki_kernel_5-10_common = {
    pname = "ztc1997-android_gki_kernel_5-10_common";
    version = "e13b3ac615cf019c36fa0d1f0b1f2e14ba3885ce";
    src = fetchFromGitHub {
      owner = "ztc1997";
      repo = "android_gki_kernel_5.10_common";
      rev = "e13b3ac615cf019c36fa0d1f0b1f2e14ba3885ce";
      fetchSubmodules = false;
      sha256 = "sha256-tZWaP+q8p7gCHBbZdcdzqIGT051eoTnR3gPWzGlp7+c=";
    };
    date = "2025-01-21";
  };
  ztc1997-android_gki_kernel_5-15_common = {
    pname = "ztc1997-android_gki_kernel_5-15_common";
    version = "0615c0e0cab9d7b1f5c24c7687f23c9d5bac0117";
    src = fetchFromGitHub {
      owner = "ztc1997";
      repo = "android_gki_kernel_5.15_common";
      rev = "0615c0e0cab9d7b1f5c24c7687f23c9d5bac0117";
      fetchSubmodules = false;
      sha256 = "sha256-uJNVK/kJgWCBUxHurKAedokKz2WtYaZ17Ib0yp7N9WI=";
    };
    date = "2024-09-03";
  };
}
