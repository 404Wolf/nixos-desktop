{
  pkgs,
  config,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      ReconnectAttempts = 0; # don't reconnect disconnected devices
    };
  };

  services.blueman.enable = true;

  systemd.user.services.airpods-librepods = {
    description = "LibrePods for AirPods";
    serviceConfig = {
      Type = "simple";
      ExecStart = let
        startScript = pkgs.writeShellApplication {
          name = "airpods-librepods-start";
          runtimeInputs = [pkgs.bluez];
          text = ''
            device_name=$(bluetoothctl info | grep -i "Name:" | cut -d: -f2 | xargs)
            if [[ "$device_name" == "AirPods Pro"* ]]; then
              exec ${pkgs.librepods}/bin/librepods --start-minimized
            fi
          '';
        };
      in "${startScript}/bin/airpods-librepods-start";
      Restart = "no";
      KillMode = "control-group";
    };
    wantedBy = ["graphical-session.target"];
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="bluetooth", DEVPATH=="/devices/*/bluetooth/hci0/hci0:*", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="airpods-librepods.service"
    ACTION=="remove", SUBSYSTEM=="bluetooth", DEVPATH=="/devices/*/bluetooth/hci0/hci0:*", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="airpods-librepods.service", RUN+="${pkgs.systemd}/bin/systemctl --user stop airpods-librepods.service"
  '';
}
