{
  pkgs,
  inputs,
  ...
}:
let
  cudaPkgs = with pkgs.cudaPackages; [
    cudatoolkit
  ];

  helixLSPs = with pkgs; [
    # nil # nix lsp
    nixd # better nix lsp
  ];

  godap = pkgs.buildGoModule rec {
    name = "godap";
    version = "2.10.7";

    src = pkgs.fetchFromGitHub {
      owner = "Macmod";
      repo = "godap";
      tag = "v${version}";
      hash = "sha256-ThN280XriiNXADPvZMwJMAFbAd7rqW8hNs1Fcs1yIAM=";
    };

    vendorHash = "sha256-D5Eq2JFIEmxO/FBGON+nKtGktWPOzXfv8l5akRTpz7Q=";
  };
in
{
  security = {
    sudo.enable = true;
    # sudo-rs.enable = true;
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

  environment.systemPackages =
    with pkgs;
    [
      vim
      helix
      neovim
      bat
      lolcat
      less
      git
      ripgrep
      ripgrep-all
      btop
      nvtopPackages.full
      ffmpeg
      yazi
      ranger
      nushell
      inputs.agenix.packages.x86_64-linux.default
      docker-compose
      nix-output-monitor

      godap
    ]
    ++ cudaPkgs
    ++ helixLSPs;
}
