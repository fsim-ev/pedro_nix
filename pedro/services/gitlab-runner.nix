{
  config,
  ...
}:{
  age.secrets = {
    gitlab-runner-token-file = {
      file = ../secrets/gitlab-runner-token.age;
    };
  };

  services.gitlab-runner = {
    enable = true;

    services = {
      website = {
        # dockerImage = "nixos/nix";
        executor = "shell";
        authenticationTokenConfigFile = config.age.secrets.gitlab-runner-token-file.path;
      };
    };
  };
}
