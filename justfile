switch:
    sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK nixos-rebuild switch --flake .#laptop

fmt:
    nix fmt
