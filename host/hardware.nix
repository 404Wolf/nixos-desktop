{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Kernel modules to be loaded in the initial ramdisk
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
    "ahci"
  ];

  # Kernel modules to be loaded by the kernel
  boot.kernelModules = ["usbserial" "ftdi_sio" "tcp_highspeed" "kvm-amd"];

  # Boot loader configuration
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      memtest86.enable = true;
      configurationLimit = 10;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
