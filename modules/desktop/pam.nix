{
  security.sudo.extraConfig = ''
    Defaults env_keep += "SSH_AUTH_SOCK"
  '';

  security.pam.services = {
    sudo.fprintAuth = true;
    login.fprintAuth = true;
    gdm.fprintAuth = true;
    sshd.fprintAuth = true;
    greetd.enableGnomeKeyring = true;
  };
}
