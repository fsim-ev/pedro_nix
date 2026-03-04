{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
    ./hyprland.nix
    ./agenix.nix
  ];
  home.stateVersion = "24.05";

}
