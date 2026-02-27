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

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 10";
      dates = "daily";
    };
  };


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
