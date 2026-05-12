{...}: {
  imports = [
    ./hardware.nix
    ./disko.nix
    ./users.nix
  ];

  networking.hostName = "desktop";

  environment.sessionVariables.EDITOR = "zeditor --wait";

  # Point root's SSH client at wolf's key for the server so the nix daemon
  # can connect without a password prompt.
  programs.ssh.extraConfig = ''
    Host server
      User wolf
      Port 2223
      IdentityFile /home/wolf/.ssh/id_rsa
      IdentitiesOnly yes
  '';

  # Remote builds via wolf@server over Tailscale.
  # Uses wolf's existing SSH key — its public half is already in wolf's
  # authorized_keys on the server via shared.wolfSshKey.
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
  nix.buildMachines = [
    {
      hostName = "server";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      sshUser = "wolf";
      sshKey = "/home/wolf/.ssh/id_rsa";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    }
  ];

  services.tailscale.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve.DNSStubListener = "yes";
  };

  swapDevices = [{
    device = "/swapfile";
    size = 32768; # 32GB
  }];

  system.stateVersion = "23.11";
}
