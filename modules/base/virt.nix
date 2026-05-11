{pkgs, ...}: {
  virtualisation = {
    podman.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    docker-compose
    podman-compose
  ];
}
