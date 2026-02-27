{
  pkgs,
  lib,
  ...
}:
  let
    host = "0.0.0.0";
    port = 7854;
    in
  {
    systemd.services."remote-shutdown" = {
      script = ''
        ${lib.getExe pkgs.shell2http} -shell ${lib.getExe' pkgs.bash "bash"} -host "${host}" -port ${toString port} /shutdown "shutdown now"
      '';

      wantedBy = ["multi-user.target"];
    };

    networking.firewall.allowedTCPPorts = [port];
  }
