# nixos-config

`git clone` to /tmp/

  Identify
  block
  device
  using `lsblk`

  Install

  `sudo nix run 'github:nix-community/disko#disko-install' -- --flake '/tmp/nixos-config#mymachine' --disk main /dev/sda`

  Persist
  EFI
  boot
  entries

  `sudo nix run 'github:nix-community/disko#disko-install' -- --write-efi-boot-entries --flake '/tmp/nixos-config#mymachine' --disk main /dev/sda`
