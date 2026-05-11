{pkgs, ...}: {
  programs.npm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  programs.ssh = {
    enableAskPassword = true;
    askPassword = "QT_QPA_PLATFORM=\"wayland\" ${pkgs.kdePackages.ksshaskpass}";
  };

  security.rtkit.enable = true;
  programs.dconf.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.captive-browser = {
    enable = true;
    interface = "wlp1s0";
  };
}
