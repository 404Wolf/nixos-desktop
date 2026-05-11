{pkgs, ...}: {
  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  environment = {
    variables = {
      PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
      FZF_BASE = "${pkgs.fzf}/bin/fzf";
    };
    sessionVariables = {
      TERM = "xterm-256color";
    };
    systemPackages = [
      pkgs.man-pages
      pkgs.man-pages-posix
      pkgs.waypipe
    ];
  };

  programs = {
    nix-index-database.comma.enable = true;
    zsh.enable = true;
    mtr.enable = true;
  };

  documentation = {
    enable = true;
    man = {
      enable = true;
      cache.enable = true;
    };
    dev.enable = true;
  };

  security.pki.certificates = pkgs.lib.mkDefault [];
  security.pki.certificateFiles = [
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  ];

  boot.kernel.sysctl."vm.swappiness" = 30;
  systemd.services.sshd.serviceConfig.OOMScoreAdjust = -1000;

  zramSwap = {
    enable = true;
    memoryPercent = 20;
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    extraArgs = [
      "-r"
      "60"
      "--ignore"
      "(^|/)(sshd|systemd|dbus-daemon)$"
      "--avoid"
      "(^|/)(Xorg|Hyprland|waybar)$"
    ];
  };
}
