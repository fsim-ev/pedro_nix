{
  ...
}:{
  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "10.24.1.2/32"
    ];
  };
}
