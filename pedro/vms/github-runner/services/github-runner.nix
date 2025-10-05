{
  config,
  ...
}:
{
  age.secrets = {
    github-runner-token.file = ../secrets/github-runner_pat.age;
  };

  services.github-runners."strichliste-rs" = {
    enable = true;
    name = "fs-pedro";
    url = "https://github.com/strichliste-rs";
    tokenFile = config.age.secrets.github-runner-token.path;
    replace = true;

    user = null;
    group = null;
  };
}
