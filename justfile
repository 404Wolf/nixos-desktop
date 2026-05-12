switch:
    sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK nixos-rebuild switch --flake .#desktop

fmt:
    nix fmt
