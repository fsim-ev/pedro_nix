{ pkgs, ... }:
let
  script = pkgs.writeShellScript "script" ''
    #${pkgs.quickemu}/bin/quickget windows 10
    pwd
    cd /var/lib/windows-10-dynamics
    ${pkgs.quickemu}/bin/quickemu --vm windows-10.conf 
  '';
  port = 5930;
in
{
  systemd.services."windows-vm-10" = {
    enable = false;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      StateDirectory = "/var/lib/windows-10-dynamics";
      WorkingDirectory = "/var/lib/windows-10-dynamics";
      ExecStart = "${script}";
    };
  };
  services.spice-vdagentd.enable = true;
  #environment.etc."qemu-bridge" = {
  # target = "qemu/bridge.conf";
  # text =
  #};
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = false;
      swtpm.enable = true;
    };
    allowedBridges = [
      "br0"
    ];
  };
  services.nginx = {
    streamConfig = ''
      server {
          listen 9999;
          proxy_pass dynamics-forward;
      }
      upstream dynamics-forward {
          server 127.0.0.1:${toString port};
      }


    '';
  };
  networking.firewall.allowedTCPPorts = [ 9999 ];
  #networking.interfaces."br0" = {
  #  ipv4.addresses = [
  #    {
  #      address = "10.101.0.2";
  #      prefixLength = 24;
  #    }
  #  ];
  # useDHCP = false;
  # };
  #networking.interfaces."vm-win-10".useDHCP = false;
  #networking.bridges."br0".interfaces = [
  #  "vm-win-10"
  #];

}
