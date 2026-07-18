{
  lib,
  pkgs,
  username,
  inputs,
  config,
  ...
}: {
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
    python315
    pyrefly
    ruff

    # dev
    clang
    inputs.fenix.packages.${stdenv.hostPlatform.system}.complete.toolchain # rust
    bun
    go
    nodejs_26
    sqlite
    duckdb
    awscli2
    opentofu
    hcloud
    jujutsu
    claude-code

    # Niri
    swaybg
    xwayland-satellite
    nautilus
    blueman
    pwmenu
  ];

  xdg = {
    enable = true;
    configFile."niri/config.kdl".source = ./niri/config.kdl; # Niri
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Berkeley Mono";
      };
      colors = {
        background = "1e1e2ee6";
        text = "cdd6f4ff";
        match = "b4befeff";
        selection = "313244ff";
        selection-text = "cdd6f4ff";
        selection-match = "b4befeff";
        border = "6c7086ff";
        prompt = "cdd6f4ff";
        input = "cdd6f4ff";
      };
    };
  };

  services.mako.enable = true;

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };

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
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      ".." = "cd ..";
      zed = "zeditor";
      z = "zed .";
      nixos = "zeditor ~/nixos";
      rebuild = "nh os switch /etc/nixos";
      ls = "eza -F always";
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
      font-family = "Berkeley Mono";
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
      format_on_save = "on";
      prettier = {
        allowed = false;
      };

      lsp = {
        oxlint.initialization_options.settings = {
          run = "onType";
          typeAware = true;
        };
      };

      languages =
        {
          "Nix" = {
            language_servers = ["!nil" "nixd"];
            formatter.external = {
              command = "alejandra";
            };
          };
          "TypeScript" = {
            language_servers = ["!eslint" "tsgo" "vtsls"];
            formatter = [{language_server.name = "oxfmt";}];
          };
        }
        // lib.genAttrs [
          "JavaScript"
          "TSX"
          "Markdown"
          "HTML"
          "JSON"
          "CSS"
        ] (_: {
          formatter = [
            {
              language_server.name = "oxfmt";
            }
          ];
        });

      theme = "Catppuccin Mocha";

      ui_font_family = "Berkeley Mono";
      ui_font_size = 16;

      buffer_font_family = "Berkeley Mono";
      buffer_font_size = 16;
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "catppuccin_mocha";
      editor = {
        auto-format = true;
        auto-save = {
          after-delay.enable = true;
          focus-lost = true;
        };
      };
    };

    languages = {
      language-server.pyrefly = {
        command = "pyrefly";
        args = ["lsp"];
      };

      language-server.ruff = {
        command = "ruff";
        args = ["server"];
      };

      language = [
        {
          name = "c";
          auto-format = true;
        }
        {
          name = "python";
          language-servers = ["pyrefly" "ruff"];
        }
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
