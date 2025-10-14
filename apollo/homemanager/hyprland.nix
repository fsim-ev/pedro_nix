{
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "[workspace 1 silent; fullscreenstate 2 2] ${lib.getExe pkgs.firefox} --new-window demo.strichliste.rs"
      ];
      ecosystem = {
        no_update_news = true;
      };
      workspace = [
        "1, monitor:DP-4"
        "2, monitor:DP-1"
        "3, monitor:DP-2"
        "4, monitor:DP-3"
      ];

    };
  };

}
