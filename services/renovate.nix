{
  config,
  ...
}:{
  age.secrets = {
    renovate-token-file = {
      file = ../secrets/renovate-bot-token.age;
    };
    renovate-github-token-file = {
      file = ../secrets/renovate-github-token.age;
    };
  };
  
  services.renovate = {
    enable = true;
    credentials = {
      RENOVATE_TOKEN = config.age.secrets.renovate-token-file.path;
      GITHUB_COM_TOKEN = config.age.secrets.renovate-github-token-file.path;
    };
    settings = {
      platform = "gitlab";
      endpoint = "https://gitlab.oth-regensburg.de/api/v4";
      automerge = true;
      platformAutomerge = true;
      ignoreTests = true;
      baseBranches = [ "/.*?/" ];
      labels = [ "dependency_update" "renovate_bot" ];
      repositories = [ "IM/Lab_fachschaft/docker_image_flake" ];
      prConcurrentLimit = 0;
      prHourlyLimit = 0;
      # customManagers = [
      #   {
      #     customType = "regex";
      #     fileMatch = [ "flake\\.nix" ];
      #     matchStrings = [
      #       ''name\s*?=\s*?"(?<depName>.*?)"\s*?;\s+?tag\s*?=\s*?"(?<currentValue>.*?)"\s*?;''
      #     ];
      #     datasourceTemplate = "docker";
      #   }
      # ];
    };
    schedule = "hourly";
  };
}
