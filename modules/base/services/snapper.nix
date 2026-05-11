{primary-user, ...}: {
  services.snapper = {
    configs = {
      root = {
        SUBVOLUME = "/root";
        FSTYPE = "btrfs";
        ALLOW_USERS = [primary-user];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "5-10";
        TIMELINE_LIMIT_DAILY = "7-14";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "3";
      };
      home = {
        SUBVOLUME = "/home";
        FSTYPE = "btrfs";
        ALLOW_USERS = [primary-user];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "5";
        TIMELINE_LIMIT_DAILY = "7";
      };
    };
  };
}
