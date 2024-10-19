{
  pkgs,
  ...
}:let 
  cudaPkgs = with pkgs.cudaPackages; [
    cudatoolkit
  ];
in {
  security = {
    sudo.enable = true;
    doas.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim helix neovim
    bat lolcat less
    git
    btop nvtopPackages.full
  ] ++ cudaPkgs;
}
