{
  flake-parts-lib,
  inputs,
  ...
}:
{
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      pipeline = pkgs.callPackage ../pipeline { inherit inputs; };
      sources = pkgs.callPackage ../_sources/generated.nix { };

      kernelOptions =
        { config, ... }:
        {
          options = {
            override = lib.mkOption {
              type = lib.types.nullOr lib.types.function;
              description = "We will ignore this";
              default = null;
            };
            overrideDerivation = lib.mkOption {
              type = lib.types.nullOr lib.types.function;
              description = "We will ignore this";
              default = null;
            };
            arch = lib.mkOption {
              type = lib.types.str;
              description = "Kernel architecture, usually `arm64`";
              default = "arm64";
            };
            anyKernelVariant = lib.mkOption {
              type = lib.types.enum [
                "osm0sis"
                "kernelsu"
              ];
              description = "Architecture of the kernel";
              default = "osm0sis";
            };
            build-toolchain = lib.mkOption {
              type = lib.types.enum [
                "gcc-only"
                "clang-with-llvm"
                "clang-with-gcc"
                "gki"
              ];
              description = "Toolchains used in kernel build, the build workflow will depend on it";
              default = null;
            };
            clangVersion = lib.mkOption {
              type = lib.types.nullOr (lib.types.either lib.types.str lib.types.int);
              description = "Version of clang used in kernel build. Can be set to any version present in [nixpkgs](https://github.com/NixOS/nixpkgs). Currently the value can be 8 to 17. If set to `latest`, will use the latest clang in nixpkgs. If set to `null`, uses Google's GCC 4.9 toolchain instead.";
              default = null;
            };

            kernelSU = {
              enable = lib.mkOption {
                type = lib.types.bool;
                description = "Whether to apply KernelSU patch";
                default = true;
              };
              variant = lib.mkOption {
                type = lib.types.either lib.types.str (
                  lib.types.enum [
                    "official"
                    "rsuntk"
                    "next"
                    "custom"
                  ]
                );
                description = "Architecture of the kernel";
                default = "official";
              };
              src = lib.mkOption {
                type = lib.types.nullOr lib.types.package;
                description = "Source of KernelSU patches";
                default = null;
              };
              revision = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "Revision number of KernelSU patches";
                default = null;
              };
              subdirectory = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "Subdirectory in kernel source directory where KernelSU will be extracted to";
                default = null;
              };
            };

            susfs = {
              enable = lib.mkOption {
                type = lib.types.bool;
                description = "Whether to apply SusFS patch";
                default = false;
              };
              src = lib.mkOption {
                type = lib.types.nullOr lib.types.package;
                description = "Source of SusFS patches. Since SusFS has too many different branches, we do not provide default variants.";
                default = null;
              };
              kernelPatch = lib.mkOption {
                type = lib.types.either lib.types.str lib.types.path;
                description = "Path to SusFS's kernel patch. Used for overriding patch to adapt to different kernel versions.";
                default = "${config.susfs.src}/kernel_patches/50_add_susfs*.patch";
              };
              kernelsuPatch = lib.mkOption {
                type = lib.types.either lib.types.str lib.types.path;
                description = "Path to SusFS's KernelSU patch. Used for overriding patch to adapt to different KernelSU versions.";
                default = "${config.susfs.src}/kernel_patches/KernelSU/10_enable_susfs_for_ksu.patch";
              };
            };

            kernelConfig = lib.mkOption {
              type = lib.types.lines;
              description = "Additional kernel config to be applied during build";
              default = "";
            };
            kernelDefconfigs = lib.mkOption {
              type = lib.types.nonEmptyListOf lib.types.str;
              description = "List of kernel config files applied during build";
            };
            kernelImageName = lib.mkOption {
              type = lib.types.str;
              description = "Generated kernel image name at end of compilation process";
              default = "Image";
            };
            kernelMakeFlags = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "Additional make flags passed to kernel build process. Can be used to ignore some compiler warnings.";
              default = [ ];
            };
            kernelPatches = lib.mkOption {
              type = lib.types.listOf (lib.types.either lib.types.str lib.types.path);
              description = "List of patch files to be applied to kernel";
              default = [ ];
            };
            kernelSrc = lib.mkOption {
              type = lib.types.either lib.types.str lib.types.path;
              description = "Source code of the kernel";
            };
            oemBootImg = lib.mkOption {
              type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
              description = "Optional, a working boot image for your device, either from official OS or a third party OS (like LineageOS). If this is provided, a `boot.img` will be generated, which can be directly flashed onto your device.";
              default = null;
            };
            gkiVersion = lib.mkOption {
              type = lib.types.nullOr (lib.types.either lib.types.str lib.types.int);
              description = "Version of gki used in kernel build.";
              default = null;
            };
            clangPrebuilt = lib.mkOption {
              type = lib.types.nullOr (lib.types.either lib.types.str lib.types.package);
              description = "Clang prebuilt to be used in kernel build. Can be set to any clang package.";
              default = null;
            };
            enableLLVM = lib.mkOption {
              type = lib.types.bool;
              description = "Whether to use LLVM backend";
              default = true;
            };
            enableGcc32 = lib.mkOption {
              type = lib.types.bool;
              description = "Whether to use gcc-32 backend";
              default = true;
            };
            enableGcc64 = lib.mkOption {
              type = lib.types.bool;
              description = "Whether to use gcc-64 backend";
              default = true;
            };
            enableGccCompat = lib.mkOption {
              type = lib.types.bool;
              description = "Whether to use gcc-64 backend";
              default = true;
            };
            enablePython2 = lib.mkOption {
              type = lib.types.bool;
              description = "Whether to use python2";
              default = false;
            };
          };
          config = lib.mkMerge [
            (lib.mkIf (config.kernelSU.variant == "official") {
              kernelSU.src = lib.mkForce sources.kernelsu-stable.src;
              kernelSU.revision = lib.mkForce sources.kernelsu-stable-revision-code.version;
              kernelSU.subdirectory = lib.mkForce "KernelSU";
            })
            (lib.mkIf (config.kernelSU.variant == "next") {
              kernelSU.src = lib.mkForce sources.kernelsu-next.src;
              kernelSU.revision = lib.mkForce sources.kernelsu-next-revision-code.version;
              kernelSU.subdirectory = lib.mkForce "KernelSU-Next";
            })
            (lib.mkIf (config.kernelSU.variant == "rsuntk") {
              kernelSU.src = lib.mkForce sources.kernelsu-rksu.src;
              kernelSU.revision = lib.mkForce sources.kernelsu-rksu-revision-code.version;
              kernelSU.subdirectory = lib.mkForce "KernelSU";
            })
          ];
        };
    in
    {
      options.kernelsu = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule kernelOptions);
        description = "Android kernels to be built with KernelSU";
        default = { };
      };

      config.packages = lib.mapAttrs (_k: pipeline) config.kernelsu;
    }
  );
}
