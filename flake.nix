{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, disko, nixpkgs }: {
    nixosConfigurations.mymachine = nixpkgs.legacyPackages.x86_64-linux.nixos [
      ./configuration.nix
      disko.nixosModules.disko
      {
        disko.devices = {
          disk = {
            main = {
              type = "disk";
              device = "/dev/disk/by-diskseq/1";
              content = {
                type = "gpt";
                partitions = {
                  ESP = {
                    priority = 1;
                    name = "ESP";
                    start = "1M";
                    end = "128M";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                    };
                  };
                  root = {
                    size = "100%";
                    content = {
                      type = "btrfs";
                      extraArgs = [ "-f" ]; # Override existing partition
                      subvolumes = {
                        "/rootfs" = {
                          mountpoint = "/";
                        };
                        "/home" = {
                          mountOptions = [ "compress=zstd" ];
                          mountpoint = "/home";
                        };
                        "/nix" = {
                          mountOptions = [ "compress=zstd" "noatime" ];
                          mountpoint = "/nix";
                        };
                        "/swap" = {
                          mountpoint = "/.swapvol";
                          swap = {
                            swapfile.size = "6G";
                          };
                        };
                      };
                      mountpoint = "/partition-root";
                      swap = {
                        swapfile = {
                          size = "6G";
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      }
    ];
  };
}
