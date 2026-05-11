{pkgs, ...}: {
  fonts = {
    fontconfig.enable = true;
    packages =
      [
        pkgs.fira-code
        pkgs.fira-code-symbols
        pkgs.font-awesome
        pkgs.liberation_ttf
        pkgs.mplus-outline-fonts.githubRelease
        pkgs.noto-fonts
        pkgs.noto-fonts-color-emoji
        pkgs.proggyfonts
        pkgs.cartographcf
      ]
      ++ builtins.filter pkgs.lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
}
