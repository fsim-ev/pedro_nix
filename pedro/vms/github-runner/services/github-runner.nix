{
  config,
  pkgs,
  ...
}:
{
  age.secrets = {
    forgejo-token.file = ../secrets/forgejo-access-token.age;
  };

  # services.github-runners."strichliste-rs" = {
  #   enable = true;
  #   name = "fs-pedro";
  #   url = "https://github.com/strichliste-rs";
  #   tokenFile = config.age.secrets.github-runner-token.path;
  #   replace = true;

  #   user = null;
  #   group = null;
  # };

  services.gitea-actions-runner.instances."ole.blue" = {
    enable = true;
    url = "https://code.ole.blue";
    name = "pedro";
    labels = ["native:host"];
    tokenFile = config.age.secrets.forgejo-token.path;
    hostPackages = with pkgs; [
      nix
      nodejs
      gnutar
      gzip
      bash
      git
    ];
  };
}
