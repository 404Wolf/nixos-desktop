{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = [pkgs.gutenprint pkgs.hplip];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}
