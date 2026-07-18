{pkgs, ...}: {
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
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
}
