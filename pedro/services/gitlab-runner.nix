{
  config,
  ...
}:
{
  age.secrets = {
    gitlab-runner-token-file-website = {
      file = ../secrets/gitlab-runner-token-website.age;
    };
    gitlab-runner-token-file-erstiguide = {
      file = ../secrets/gitlab-runner-token-erstiguide.age;
    };
  };

  services.gitlab-runner = {
    enable = true;

    services = {
      website = {
        # dockerImage = "nixos/nix";
        executor = "shell";
        authenticationTokenConfigFile = config.age.secrets.gitlab-runner-token-file-website.path;
      };
      Erstiguide = {
        executor = "shell";
        authenticationTokenConfigFile = config.age.secrets.gitlab-runner-token-file-erstiguide.path;
      };
    };
  };
}
