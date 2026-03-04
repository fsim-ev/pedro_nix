{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  ipkgs = inputs.infoscreen-ng.packages.x86_64-linux;
  infoscreen-timetable = lib.getExe ipkgs.infoscreen-timetable;
  infoscreen-todo-list = lib.getExe ipkgs.infoscreen-todo-list;
  infoscreen-bus-schedule = lib.getExe ipkgs.infoscreen-bus-schedule;
in
{
  age.secrets = {
    timetable-toml.file = ./secrets/stundenplan-toml.age;
    todo-toml.file = ./secrets/todo-toml.age;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };
      exec-once = lib.filter (a: a != "") (
        lib.splitString "\n" ''
          [workspace 1 silent; fullscreen 2 1] sleep 10s && ${infoscreen-bus-schedule} -C ${../configs/config_bus.toml}
          [workspace 2 silent; fullscreen 2 0] sleep 10s && ${infoscreen-timetable} -C ${config.age.secrets.timetable-toml.path}
          [workspace 3 silent; fullscreen 2 2] sleep 10s && ${infoscreen-todo-list} -C ${config.age.secrets.todo-toml.path}
          [workspace 4 silent; fullscreen 2 2] sleep 10s && ${pkgs.firefox}/bin/firefox --kiosk --new-window strichliste.fsim-ev.de
        ''
      );
      # instead waiting for network-online.target hangs up the touch diisplay

      workspace = [
        "1, monitor:DP-4" # left
        "2, monitor:DP-3" # middle
        "3, monitor:DP-2" # right
        "4, monitor:DP-1" # Strichliste
        "r[1-4], gapsin:0, gapsout:0"
      ];
      monitor = [
        "DP-1,preferred, auto, 1, transform, 1"
        "DP-4 ,preferred, auto, 1, transform, 1"
        "DP-2,preferred, auto, 1, transform, 1"
        "DP-3,preferred, auto, 1, transform, 1"
      ];
      input = {
        touchdevice = [
          {
            transform = 1;
            output = "DP-1";
          }
        ];
      };

    };
  };
}
