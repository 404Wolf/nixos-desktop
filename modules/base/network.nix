{options, ...}: {
  services.resolved.enable = true;

  # Max out our networking options, like using super large window sizes, etc
  boot.kernel.sysctl = {
    "net.ipv4.tcp_adv_win_scale" = "4";
    "net.ipv4.tcp_congestion_control" = "highspeed";
    "net.core.wmem_max" = 16777216;
    "net.core.rmem_max" = 16777216;
    "net.ipv4.tcp_wmem" = "4096 87380 16777216"; # min, default, max
    "net.ipv4.tcp_rmem" = "4096 87380 16777216"; # min, default, max
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_window_scaling" = 1;
    "net.core.netdev_max_backlog" = 250000;
    "net.ipv4.tcp_initial_cwnd" = 10;
    "net.ipv4.tcp_max_syn_backlog" = 8192;
    "net.ipv4.tcp_max_tw_buckets" = 2000000;
    "fs.file-max" = 2097152;
  };

  # Configure general network settings
  networking = {
    networkmanager.enable = true;
    hosts = {
      "127.0.0.1" = ["localdomain"];
    };
    # hostname is set per-host in hosts/<name>/default.nix
    timeServers = options.networking.timeServers.default ++ ["time.google.com"];
  };

  # Enable tailscale
  services.tailscale.enable = true;
}
