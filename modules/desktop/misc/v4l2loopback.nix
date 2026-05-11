{pkgs, ...}: {
  boot.kernelModules = [
    "v4l2loopback"
    "snd-aloop"
  ];

  boot.extraModulePackages = [
    pkgs.linuxPackages.v4l2loopback
  ];

  environment.systemPackages = with pkgs; [v4l-utils];
}
