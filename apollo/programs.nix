{
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.uwsm.enable = true;

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "autologin";
    };

    sddm = {
      enable = true;

      wayland.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    helix
    vim
  ];
}
