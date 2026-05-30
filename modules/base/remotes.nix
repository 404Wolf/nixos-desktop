{...}: {
  services.openssh = {
    enable = true;
    openFirewall = false; # Only expose SSH via Tailscale
    settings = {
      AuthorizedKeysFile = "%h/.ssh/authorized_keys";
      X11Forwarding = true;
    };
  };

  # Allow SSH only on the Tailscale interface
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [22];

  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "server";
    extraUpFlags = ["--advertise-routes=192.168.1.0/24"];
  };

  systemd.services.sshd = {
    serviceConfig = {
      Nice = -10;
      CPUWeight = 1000;
      IOSchedulingClass = "realtime";
      IOSchedulingPriority = 0;
      IOWeight = 1000;
    };
  };
}
