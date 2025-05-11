{ inputs, pkgs, ... }:
let
  momw-tools = pkgs.callPackage ./packages/momw-tools { };
in
{
  environment.systemPackages = with pkgs; [
    # Minecraft
    jdk21
    prismlauncher

    # Morrowind
    inputs.openmw-nix.packages."${system}".openmw-dev
    inputs.openmw-nix.packages."${system}".umo
    p7zip-rar
    momw-tools.tes3cmd
    momw-tools.others
  ];

  programs.steam.enable = true;

  # Configure Sunshine
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
    package = pkgs.sunshine.override { cudaSupport = true; };
  };
}
