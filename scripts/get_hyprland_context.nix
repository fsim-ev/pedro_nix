{ pkgs, lib, ... }:
let
  jq = lib.getExe pkgs.jq;
in
pkgs.writeShellScriptBin "get_hyprland_context" ''
  ins=$(sudo -u autologin hyprctl instances -j | ${jq} ".[]" | ${jq} ".instance")
  echo "export HYPRLAND_INSTANCE_SIGNATURE=$ins"
  sudo -u autologin -i "export HYPRLAND_INSTANCE_SIGNATURE=$ins; sh"
''
