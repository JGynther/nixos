{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    # terminal go brr
    fastfetch
    btop
    ripgrep
    eza
    bat

    # misc
    wl-clipboard

    # nix
    nixd
    nixfmt-rfc-style

    # python
    uv
  ];

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    userName = "Joona Gynther";
    userEmail = "joona@gynther.xyz";
    extraConfig.init.defaultBranch = "main";
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ".." = "cd ..";
      zed = "zeditor";
      z = "zed .";
      nixos = "zeditor ~/nixos";
      rebuild = "sudo nixos-rebuild switch";
      ls = "eza -F";
      cat = "bat";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      font-size = 14;
      background-opacity = 0.95;
      background-blur-radius = 20;
      window-padding-x = 30;
      window-padding-y = 10;
      window-height = 40;
    };
  };

  programs.zed-editor = {
    enable = true;
    # FIXME: to be configured
  };

  # Let Home Manager manage itself
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
