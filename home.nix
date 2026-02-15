{
  pkgs,
  username,
  inputs,
  ...
}: let
  python312WithForcedTorch = pkgs.python312.override {
    packageOverrides = pyFinal: pyPrev: {
      torch = pyPrev.torch-bin;
      torchvision = pyPrev.torchvision-bin;
      triton = pyPrev.torch-bin.triton;
    };
  };
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    # terminal go brr
    fastfetch
    btop # top
    ripgrep # grep
    eza # ls
    bat # cat
    just # command runner

    ffmpeg_8-headless

    # nix
    nixd
    alejandra # nixfmt-rfc-style

    # python
    uv
    (python312WithForcedTorch.withPackages (
      python-pkgs:
        with python-pkgs; [
          # torch
        ]
    ))

    # dev
    clang
    inputs.fenix.packages.${stdenv.hostPlatform.system}.complete.toolchain # rust
    bun
    nodejs_25
    sqlite
    duckdb
    awscli2
    opentofu
    hcloud
    jujutsu
  ];

  programs.firefox.enable = true;

  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Joona Gynther";
        email = "joona@gynther.xyz";
      };
    };
    maintenance.enable = true;
  };

  programs.delta.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      ".." = "cd ..";
      zed = "zeditor";
      z = "zed .";
      nixos = "zeditor ~/nixos";
      rebuild = "nh os switch /etc/nixos";
      ls = "eza -F";
      cat = "bat";
      grep = "rg";
      help = ''
        grep 'alias -- ' ~/.zshrc | sed "s/alias -- //; s/'//g" | awk -F'=' '{printf "\033[1;36m%-10s\033[0m %s\n", $1, $2}'
      '';
    };

    completionInit = ''
      autoload bashcompinit && bashcompinit
      autoload -U compinit && compinit
      complete -C '${pkgs.awscli2}/bin/aws_completer' aws
    '';
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-size = 14;
      background-opacity = 0.95;
      background-blur-radius = 20;
      window-padding-x = 30;
      window-padding-y = 10;
      window-height = 40;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$username$directory$git_branch$git_metrics$time$cmd_duration$line_break$character";

      username = {
        show_always = true;
      };

      character = {
        success_symbol = "[>](bold fg:green)";
        error_symbol = "[x](bold fg:red)";
      };

      time = {
        disabled = false;
        time_format = "%H:%M:%S%.6f";
        style = "bold fg:blue";
      };

      cmd_duration = {
        min_time = 0;
        show_milliseconds = true;
      };

      git_branch = {
        symbol = " ";
      };

      git_metrics = {
        disabled = false;
      };
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = ["catppuccin"];
    userSettings = {
      languages = {
        "Nix" = {
          language_servers = ["!nil" "nixd"];
          formatter.external = {
            command = "alejandra";
          };
        };
      };

      theme = "Catppuccin Mocha";

      ui_font_size = 16;
      buffer_font_size = 16;
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # Discord
  programs.vesktop.enable = true;

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  # Let Home Manager manage itself
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
