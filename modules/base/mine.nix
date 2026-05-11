{lib, ...}: {
  options.my = {
    variables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Shared general variables";
    };

    go-to-sleep = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the system should suspend on lid close";
    };
  };

  config.my = {
    variables = {
      airpods-mac = "74:15:F5:5B:5E:DE";
    };
  };
}
