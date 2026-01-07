{
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # A bit unsure about these but FIXME: later
  # Bootloader stuff
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "fi_FI.UTF-8";
  };
  console.keyMap = "fi";
  services.xserver.xkb.layout = "fi";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
    ];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBdlBStN2bXXCgoF3BfkclTEPYukxeAYlo7YhtxFMeUAjX0uSwAqVRgwbMCroQwEd2HrdIoG42F3582LYM+1pfU= gynther@secretive.MacBook-Air.local"
    ];
  };

  nix.settings = {
    trusted-users = ["${username}"];
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Set zsh as default. It is configured with home-manager
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Also enable tailscale for SSH
  services.tailscale.enable = true;

  # Patching Python
  # https://wiki.nixos.org/wiki/Python#Running_Python_packages_which_requires_compilation_and/or_contains_libraries_precompiled_without_nix
  /*
  programs.nix-ld = {
  enable = true;
  libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    cudaPackages.cudatoolkit
    glibc
  ];
  };
  */

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
