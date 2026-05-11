{...}: {
  # Use an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/nix/persist/var/lib/sops-nix/key.txt";

  # Make the key readable by wolf so the HM sops-nix.service can decrypt secrets
  system.activationScripts.sops-key-perms = {
    deps = ["users"];
    text = ''
      key=/nix/persist/var/lib/sops-nix/key.txt
      if [ -f "$key" ]; then
        chown wolf "$key"
        chmod 0400 "$key"
      fi
    '';
  };
}
