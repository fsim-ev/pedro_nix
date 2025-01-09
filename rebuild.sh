sudo -v
sudo nixos-rebuild $1 --flake /etc/nixos --log-format internal-json -v |& nom --json
