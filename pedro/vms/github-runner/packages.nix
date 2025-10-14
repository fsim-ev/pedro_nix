{
  pkgs,
  ...
}:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
    };
  };

  environment.systemPackages = with pkgs; [
    btop
  ];
}
