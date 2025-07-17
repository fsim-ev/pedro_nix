#!/usr/bin/env bash
sudo -v
sudo nixos-rebuild $@ --flake /etc/nixos --log-format internal-json -v |& nom --json
