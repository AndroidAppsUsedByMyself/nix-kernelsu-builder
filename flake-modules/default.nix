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
              type = lib.types.nullOr (
                lib.either lib.types.anything (
                  lib.either lib.types.function (
                    lib.types.either (lib.types.attrsOf lib.types.anything) lib.types.submodule {
                      freeformType = lib.types.attrsOf lib.types.anything;

                      options = {
                        __functionArgs = lib.mkOption {
                          type = lib.types.str;
                          description = "We will ignore this";
                        };
                      };
                    }
                  )
                )
              );
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
                type = lib.types.enum [
                  "official"
                  "next"
                  "sukisu"
                  "sukisu-nongki"
                  "sukisu-susfs"
                  "custom"
                  "rsuntk"
                ];
                description = "Architecture of the kernel";
                default = "official";
              };
              moduleSystemImpl = lib.mkOption {
                type = lib.types.either lib.types.str (
                  lib.types.enum [
                    "overlayfs"
                    "magicmount"
                  ]
                );
                description = "the method that kernelsu variant uses to make modules system work";
                default = "overlayfs";
              };
              integrateMethod = lib.mkOption {
                type = lib.types.enum [
                  "kprobe"
                  "manually_patch_cmd"
                ];
                description = "Method to integrate KernelSU into the kernel";
                default = "kprobe";
              };
              integrateManuallyPatchCmd = lib.mkOption {
                type = lib.types.str;
                description = "Command to apply KernelSU patch manually";
                default = ''
                  # Patches author: weishu <twsxtd@gmail.com>
                  # Shell authon: xiaoleGun <1592501605@qq.com>
                  #               bdqllW <bdqllT@gmail.com>
                  # Tested kernel versions: 5.4, 4.19, 4.14, 4.9
                  # 20240123
                  echo "Applying KernelSU patch manually"
                  patch_files=(
                      fs/exec.c
                      fs/open.c
                      fs/read_write.c
                      fs/stat.c
                      drivers/input/input.c
                  )

                  for i in "''${patch_files[@]}"; do

                      if grep -q "ksu" "$i"; then
                          echo "Warning: $i contains KernelSU"
                          continue
                      fi

                      case $i in

                      # fs/ changes
                      ## exec.c
                      fs/exec.c)
                          sed -i '/static int do_execveat_common/i\#ifdef CONFIG_KSU\nextern bool ksu_execveat_hook __read_mostly;\nextern int ksu_handle_execveat(int *fd, struct filename **filename_ptr, void *argv,\n			void *envp, int *flags);\nextern int ksu_handle_execveat_sucompat(int *fd, struct filename **filename_ptr,\n				 void *argv, void *envp, int *flags);\n#endif' fs/exec.c
                          if grep -q "return __do_execve_file(fd, filename, argv, envp, flags, NULL);" fs/exec.c; then
                              sed -i '/return __do_execve_file(fd, filename, argv, envp, flags, NULL);/i\	#ifdef CONFIG_KSU\n	if (unlikely(ksu_execveat_hook))\n		ksu_handle_execveat(&fd, &filename, &argv, &envp, &flags);\n	else\n		ksu_handle_execveat_sucompat(&fd, &filename, &argv, &envp, &flags);\n	#endif' fs/exec.c
                          else
                              sed -i '/if (IS_ERR(filename))/i\	#ifdef CONFIG_KSU\n	if (unlikely(ksu_execveat_hook))\n		ksu_handle_execveat(&fd, &filename, &argv, &envp, &flags);\n	else\n		ksu_handle_execveat_sucompat(&fd, &filename, &argv, &envp, &flags);\n	#endif' fs/exec.c
                          fi
                          ;;

                      ## open.c
                      fs/open.c)
                          if grep -q "long do_faccessat(int dfd, const char __user \*filename, int mode)" fs/open.c; then
                              sed -i '/long do_faccessat(int dfd, const char __user \*filename, int mode)/i\#ifdef CONFIG_KSU\nextern int ksu_handle_faccessat(int *dfd, const char __user **filename_user, int *mode,\n			 int *flags);\n#endif' fs/open.c
                          else
                              sed -i '/SYSCALL_DEFINE3(faccessat, int, dfd, const char __user \*, filename, int, mode)/i\#ifdef CONFIG_KSU\nextern int ksu_handle_faccessat(int *dfd, const char __user **filename_user, int *mode,\n			 int *flags);\n#endif' fs/open.c
                          fi
                          sed -i '/if (mode & ~S_IRWXO)/i\	#ifdef CONFIG_KSU\n	ksu_handle_faccessat(&dfd, &filename, &mode, NULL);\n	#endif\n' fs/open.c
                          ;;

                      ## read_write.c
                      fs/read_write.c)
                          sed -i '/ssize_t vfs_read(struct file/i\#ifdef CONFIG_KSU\nextern bool ksu_vfs_read_hook __read_mostly;\nextern int ksu_handle_vfs_read(struct file **file_ptr, char __user **buf_ptr,\n		size_t *count_ptr, loff_t **pos);\n#endif' fs/read_write.c
                          sed -i '/ssize_t vfs_read(struct file/,/ssize_t ret;/{/ssize_t ret;/a\
                          #ifdef CONFIG_KSU\
                          if (unlikely(ksu_vfs_read_hook))\
                              ksu_handle_vfs_read(&file, &buf, &count, &pos);\
                          #endif
                          }' fs/read_write.c
                          ;;

                      ## stat.c
                      fs/stat.c)
                          if grep -q "int vfs_statx(int dfd, const char __user \*filename, int flags," fs/stat.c; then
                              sed -i '/int vfs_statx(int dfd, const char __user \*filename, int flags,/i\#ifdef CONFIG_KSU\nextern int ksu_handle_stat(int *dfd, const char __user **filename_user, int *flags);\n#endif' fs/stat.c
                              sed -i '/unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;/a\\n	#ifdef CONFIG_KSU\n	ksu_handle_stat(&dfd, &filename, &flags);\n	#endif' fs/stat.c
                          else
                              sed -i '/int vfs_fstatat(int dfd, const char __user \*filename, struct kstat \*stat,/i\#ifdef CONFIG_KSU\nextern int ksu_handle_stat(int *dfd, const char __user **filename_user, int *flags);\n#endif\n' fs/stat.c
                              sed -i '/if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |/i\	#ifdef CONFIG_KSU\n	ksu_handle_stat(&dfd, &filename, &flag);\n	#endif\n' fs/stat.c
                          fi
                          ;;

                      # drivers/input changes
                      ## input.c
                      drivers/input/input.c)
                          sed -i '/static void input_handle_event/i\#ifdef CONFIG_KSU\nextern bool ksu_input_hook __read_mostly;\nextern int ksu_handle_input_handle_event(unsigned int *type, unsigned int *code, int *value);\n#endif\n' drivers/input/input.c
                          sed -i '/int disposition = input_get_disposition(dev, type, code, &value);/a\	#ifdef CONFIG_KSU\n	if (unlikely(ksu_input_hook))\n		ksu_handle_input_handle_event(&type, &code, &value);\n	#endif' drivers/input/input.c
                          ;;
                      esac

                  done

                  # Patches author: backslashxx @Github
                  # Shell authon: JackA1ltman <cs2dtzq@163.com>
                  # Tested kernel versions: 5.4, 4.19, 4.14, 4.9, 4.4
                  # 20250323

                '';
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
                type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
                description = "Path to SusFS's kernel patch. Used for overriding patch to adapt to different kernel versions. If set to null, will disable patching kernel.";
                default = "${config.susfs.src}/kernel_patches/50_add_susfs*.patch";
              };
              kernelsuPatch = lib.mkOption {
                type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
                description = "Path to SusFS's KernelSU patch. Used for overriding patch to adapt to different KernelSU versions. If set to null, will disable patching KernelSU.";
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

            prePatch = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Command to run before patching kernel source code";
            };
            postPatch = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Command to run after patching kernel source code";
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
          };
          config = lib.mkMerge [
            # do not set these value to null or they will be overridden
            (lib.mkIf (config.kernelSU.variant == "official") {
              kernelSU.src = lib.mkDefault sources.kernelsu-stable.src;
              kernelSU.revision = lib.mkDefault sources.kernelsu-stable-revision-code.version;
              kernelSU.subdirectory = lib.mkDefault "KernelSU";
              kernelSU.moduleSystemImpl = lib.mkDefault "overlayfs";
            })
            (lib.mkIf (config.kernelSU.variant == "next") {
              kernelSU.src = lib.mkDefault sources.kernelsu-next.src;
              kernelSU.revision = lib.mkDefault sources.kernelsu-next-revision-code.version;
              kernelSU.subdirectory = lib.mkDefault "KernelSU-Next";
              kernelSU.moduleSystemImpl = lib.mkDefault "magicmount";
            })
            (lib.mkIf (config.kernelSU.variant == "rsuntk") {
              kernelSU.src = lib.mkDefault sources.kernelsu-rksu.src;
              kernelSU.revision = lib.mkDefault sources.kernelsu-rksu-revision-code.version;
              kernelSU.subdirectory = lib.mkDefault "KernelSU";
              kernelSU.moduleSystemImpl = lib.mkDefault "magicmount";
            })
            (lib.mkIf (config.kernelSU.variant == "sukisu") {
              kernelSU.src = sources.sukisu.src;
              kernelSU.revision = sources.sukisu-revision-code.version;
              kernelSU.subdirectory = "KernelSU";
            })
            (lib.mkIf (config.kernelSU.variant == "sukisu-nongki") {
              kernelSU.src = sources.sukisu-nongki.src;
              kernelSU.revision = sources.sukisu-revision-code.version;
              kernelSU.subdirectory = "KernelSU";
            })
            (lib.mkIf (config.kernelSU.variant == "sukisu-susfs") {
              kernelSU.src = sources.sukisu-susfs.src;
              kernelSU.revision = sources.sukisu-revision-code.version;
              kernelSU.subdirectory = "KernelSU";
              # SukiSU already has SusFS patch
              susfs.enable = true;
              susfs.kernelsuPatch = null;
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
