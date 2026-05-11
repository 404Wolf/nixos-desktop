{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      glib
      xcb-util-cursor
      openssl
      zlib
      bzip2
      libxml2
      readline
      ncurses
      cairo
      freetype
      fontconfig
      libffi
    ];
  };
}
