{
  ...
}:{

  nixpkgs.config.allowUnfree = true;
  
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_LLM_LIBRARY = "cuda";
      LD_LIBRARY_PATH = "run/opengl-driver/lib";
    };
  };
}
