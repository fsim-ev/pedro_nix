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

  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 10";
      dates = "daily";
    };

  };

  environment.systemPackages = with pkgs; [
    vim helix neovim
    bat lolcat less
    git
    btop nvtopPackages.full
    ffmpeg
    yazi ranger
    nushell
    inputs.agenix.packages.x86_64-linux.default
    docker-compose
    nix-output-monitor
  ] ++ cudaPkgs ++ helixLSPs;
}
