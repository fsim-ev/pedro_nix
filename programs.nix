{
  pkgs,
  ...
}:{
  security = {
    sudo.enable = true;
    doas.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim helix neovim
    bat lolcat less
    git
  ];
}
