{
  pkgs,
  inputs,
  ...
}:let 
  cudaPkgs = with pkgs.cudaPackages; [
    cudatoolkit
  ];

  helixLSPs = with pkgs; [
    nil # nix lsp
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
    ffmpeg
    yazi ranger
    inputs.agenix.packages.x86_64-linux.default
  ] ++ cudaPkgs ++ helixLSPs;
}
