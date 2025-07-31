# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    tmp.useTmpfs = true;
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.enableRedistributableFirmware = true;

  # Backup service
  services.borgbackup.repos = {
    "infra-examia" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/examia";
      user = "examia";
      quota = "200G";
    };
   "infra-zulip" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/zulip";
      user = "zulip";
      quota = "100G";
    };
    "infra-nextcloud" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/nextcloud";
      user = "nextcloud";
      quota = "1024G";
    };
    "infra-hedgedoc" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/hedgedoc";
      user = "hedgedoc";
      quota = "10G";
    };

    "game-minecraft" = {
      authorizedKeysAppendOnly = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxGYg/SMtF/fb79pZQMN0UC3t1R7/HSqXuD0IbKtzYV root@ori"
      ];
      path = "/mnt/storage/backup/infra/minecraft";
      user = "minecraft";
      quota = "100G";
    };    
  };

  services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      
      virtualHosts = {
        "site.fsim" = {
          root = "/var/lib/www/grav";
          locations."/".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.grav.socket};
            include ${pkgs.nginx}/conf/fastcgi.conf;
          '';
        };
        "wiki.fsim" = {
          locations."/".proxyPass = "http://${config.services.wiki-js.settings.bindIP}:${toString config.services.wiki-js.settings.port}";
        };
      };
  };

  services.phpfpm = {
    phpOptions = ''
      date.timeZone = "Europe/Berlin";
    '';
    pools = {
      grav = {
        user = config.services.nginx.user;
        group = config.services.nginx.group;
        settings = {
          "pm" = "ondemand";
          "pm.max_children" = 10;
          "pm.max_requests" = 500;
          # dump hacks
          "listen.mode" = "0600";
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        };        
      };
    };
  };
  
  services.postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      
      ensureDatabases = [
        config.services.wiki-js.settings.db.db        
      ];
      ensureUsers = [
        {
          name = config.services.wiki-js.settings.db.db;
          ensureDBOwnership = true;
        }
      ];
    };

  services.wiki-js = {
      enable = false;
      settings = {
        bindIP = "127.0.0.1";
        port = 9001;
        logLevel = "silly";
        db.host = "localhost";
        db.pass = "$(DB_PASS)";
        db.db = "wiki";
        db.user = "wiki";
      };
      environmentFile = ./secrets/wiki-js;
  };
  
  services.samba = {
    enable = true;
    settings = {
      global = {
        "workgroup" = "FSIM";

        "map to guest" = "bad user";
        "guest account" = "guest";

        "hosts allow" = ["10.24." "127."];
        "use sendfile" = true;
      };
      webcam = {
        "path" = "/mnt/storage/webcam";
        "comment" = "OTH Webcam archive";
        "read only" = true;
        "browseable" = true;
        "guest ok" = true;
        "public" = true;
      };
      stash = {
        "path" = "/mnt/storage/stash";
        "comment" = "Temporary data stash";
        "read only" = false;
        "browseable" = true;
        "guest ok" = true;
        "public" = true;
        "create mask" = "0644";
        "directory mask" = "0777";
        "force user" = "guest";
        "force group" = "nobody";
      };
    };
  };

  

  # DANGER ZONE! 
  #############################################################

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  networking = {
    hostName = "monolith"; # Define your hostname.
    domain = "fsim";
    hostId = "77ea661f";
    hosts = {
      "10.24.0.1" = [
        "fsim"
        "site.fsim"
        "wiki.fsim"
      ];
    };
    useDHCP = false;
    interfaces = {
      enp7s0 = {
        #name = "uplink";
        useDHCP = true;
        macAddress = "00:1e:4f:a4:ed:0c"; # for now
      };
      enp5s0 = {
        #name = "lan";
        ipv4.addresses = [{
          address = "10.24.0.1";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "f510:1024::1";
          prefixLength = 64;
        }];
      };
    };

    firewall = {
      enable = false;
      interfaces."enp7s0" = { };
      trustedInterfaces = [ "enp5s0" ];
    };
  };

  # DHCP+DNS server
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      interface = "enp5s0";
      #listen-address=10.24.0.1
      # DHCP
      dhcp-authoritative = true;
      dhcp-range = [
        "10.24.0.10, 10.24.0.200, 30d"
        "f510:1024::10, f510:1024::ffff:ffff:ffff:ffff, 64, 30d"
      ];
      #dhcp-hostsfile=/etc/dnsmasq/
      enable-ra = true;
      ra-param = "en,0,0";
      quiet-ra = true;
      # DNS
      domain = "fsim, 10.24.0.0/24, local";
      expand-hosts = true;
    };
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "enp7s0";
    internalInterfaces = [ "enp5s0" ];
    internalIPs = [ "10.24.0.0/24" ];
    internalIPv6s = [ "f510:1024::/64" ];
  };

  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      privateKeyFile = "/etc/nixos/secrets/wireguard-tunnel.key";
      ips = [ "10.24.1.2/32" ];
      peers = [{
        endpoint = "fsim.othr.de:4422";
        allowedIPs = [ "10.24.1.0/24" ];
        publicKey = "2gCIu3m6C198/+V3XNAO2rBqOTidLc9UKf+Jy0teNk0=";
        persistentKeepalive = 10;
        dynamicEndpointRefreshSeconds = 60;
      }];
    };
  };
  

  services = {
    openssh.enable = true;
    netdata = {
      enable = true;
      config.web."bind to" = "10.24.0.1 10.24.1.1";
    };
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCZSVF6GnRarMgJ5yCv7fBDPQCnqvBJutyJF4KSDNz4 root@pedro"
    ];

    utz = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdsma74LYn5VdICUm1KgPte4rO563sWXJQfoVGGdfe6 engi"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKy1pBbnSgIihWZg4PozI26NUTARrBVrziaV2fXNNZY9 hyperspace"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxvuuNWDRxO3LuyQX2MaD2NYygqWN5wMVCClSPb4M0Q base"
      ];
    };
    benno = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpGkSrZmFtUpWy9TyZQkS9P3th8MiB9EUI+JAnHPwpv bib48218@othr.de"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPvGKZjMtQKsEp6NM+KoSztwxTldoz7y2ykXrvMi51GV cardno:18_173_666"
      ];
    };

    thanh = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJAS3KXEQoQp0C0c2sZNVwYu+yUoo43doN1hFyKTBCi archMain"
      ];
    };
    ole = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIS6xrMgqANcI0fvDKoT8eOj5mXejbHgtCsmTV1xjAfL ole@wattson" 
      ];
    };
    hannes = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESektBIV5CX5KuloRo5jytU8dM7PCpPmpHm2ER4Sm8X"
      ];
    };
    guest = {
      isSystemUser = true;
      uid = 10000;
      group = "users";
      description = "For anonymous file access (e.g. in Samba)";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim helix bat
    htop btop strace zellij
    ethtool pciutils smartmontools lm_sensors dmidecode
    lf ncdu fd ripgrep rmlint
    curl croc rsync nmap iperf
    git tig lazygit
    nix-output-monitor
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    fish.enable = true;
    zsh.enable = true;
    tmux.enable = true;
    less.enable = true;
    nh.enable = true;
  };

  # Use zeh Internet!
  # (saves disk space)
  documentation.enable = false;


  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@wheel" ];
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}

