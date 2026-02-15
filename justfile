default:
    @just --list

rebuild:
    nh os switch /etc/nixos

update:
    sudo nix flake update --flake /etc/nixos

gc:
    sudo nix-collect-garbage --delete-old
