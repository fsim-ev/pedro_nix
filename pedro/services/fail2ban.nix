{
  ...
}:{
  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "10.24.1.2/32"
    ];

    jails = {
      nginx = {
        enable = true;
      };

      sshd = {
        enable = true;
        maxretry = 5;
      };
    };
  };
}
