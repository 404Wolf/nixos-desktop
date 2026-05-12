{
  description = "NixOS configuration for desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    cartographcf.url = "github:404Wolf/CartographCF";
    zed-editor.url = "github:zed-industries/zed";
    hyprland.url = "github:hyprwm/Hyprland";
    shared-nixos-modules.url = "git+ssh://git@github.com/404wolf/shared-nixos-modules";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    primary-user = "wolf";

    mkPkgs = overlays:
      import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "electron-25.9.0"
            "electron-32.3.3"
          ];
        };
      };

    baseOverlays = [
      (final: prev: {
        cartographcf = inputs.cartographcf.packages.${system}.default;
      })
      inputs.shared-nixos-modules.overlays.default
    ];

    desktopOverlays =
      baseOverlays
      ++ [
        (final: prev: {
          zed-editor = inputs.zed-editor.packages.${system}.default;
          hyprland = inputs.hyprland.packages.${system}.hyprland;
        })
        inputs.shared-nixos-modules.overlays.laptop
      ]
      ++ (import ./overlays/desktop.nix);

    pkgs = mkPkgs desktopOverlays;
    helpers = pkgs.callPackage ./utils.nix {};
  in {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit inputs system primary-user;
        helpers = helpers;
      };
      modules = [
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        (inputs.nix-index-database.nixosModules.nix-index)
        ./modules/base
        ./sops.nix
        ./modules/desktop
        ./host
        {_module.args.disks = ["/dev/nvme0n1"];}
      ];
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [pkgs.just];
    };

    formatter.${system} = let
      pkgs' = import nixpkgs {inherit system;};
      treefmtconfig = inputs.treefmt-nix.lib.evalModule pkgs' {
        projectRootFile = "flake.nix";
        programs.alejandra.enable = true;
        programs.shellcheck.enable = true;
        settings.formatter.shellcheck.excludes = [".envrc"];
      };
    in
      treefmtconfig.config.build.wrapper;
  };
}
