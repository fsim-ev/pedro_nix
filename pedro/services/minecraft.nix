{
  ...
}:
let port = 25565;
in
{
  virtualisation.oci-containers.containers.minecraft = {
    image = "itzg/minecraft-server:latest";
    environment = {
      MOTD = "FSIM Anarchie";
      VIEW_DISTANCE = "16";
      DIFFICULTY = "hard";

      SEED = "1785852800490497919";
      SPAWN_PROTECTION = "15";
      PLAYER_IDLE_TIMEOUT = "30";

      MEMORY = "16G";
      INIT_MEMORY = "8G";
      MAX_MEMORY = "64G";
      MAX_PLAYERS = "128";
      USE_AIKAR_FLAGS = "TRUE";

      RCON_PASSWORD = "8642753";

      TYPE = "PAPER";
      EULA = "TRUE";
      EXISTING_WHITELIST_FILE = "MERGE";
      USE_SIMD_FLAGS = "TRUE";
      UID = toString port;
      GID = toString port;
    };
    volumes = [
      "/var/lib/minecraft:/data:rw"
    ];
    ports = [ "${toString port}:${toString port}" ];
  };

  networking.firewall = {
    allowedUDPPorts = [ port ];
    allowedTCPPorts = [ port];
  };
}
