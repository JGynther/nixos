{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Minecraft
    jdk21
    prismlauncher

    # Morrowind
    openmw
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
