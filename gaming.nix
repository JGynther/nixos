{pkgs, ...}: let
  # momw-tools = pkgs.callPackage ./packages/momw-tools {};
in {
  environment.systemPackages = with pkgs; [
    # Minecraft
    jdk21
    prismlauncher

    # Morrowind
    #inputs.openmw-nix.packages."${system}".openmw-dev
    #inputs.openmw-nix.packages."${system}".umo
    #p7zip-rar
    #momw-tools.tes3cmd
    #momw-tools.others

    # FFXIV
    xivlauncher

    # POE
    rusty-path-of-building
  ];

  programs.steam.enable = true;
}
