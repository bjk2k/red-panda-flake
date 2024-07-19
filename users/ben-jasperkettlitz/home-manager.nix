{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  manpager = pkgs.writeShellScriptBin "manpager" (
    if isDarwin
    then ''
      sh -c 'col -bx | bat -l man -p'
    ''
    else ''
      cat "$1" | col -bx | bat --language man --style plain
    ''
  );
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full tocbibind;
  };
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
    ];
  home = {
    # Don't change this when you change package input. Leave it alone.
    stateVersion = "23.05";
    # specify my home-manager configs

    xdg.enable = true;

    # --- [ Programs ] ---
    packages = with pkgs;
      [
        # --- [ Shell Utilities ] ---
        ripgrep
        fd
        curl
        zoxide
        less
        kitty
        kitty-themes
        glab
        fastfetch

        fzy

        # --- [ Editors ] ---

        inputs.neve.packages.${system}.default
        zed

        # --- [ UI Applications ] ---

        discord
        spotify

        # -- [ LSP related depenedencies ] --
        alejandra

        bat # previewer for telescope for now
        marksman # lsp for any markdown
        nixd # -- damn good at completions referencing back to nixpkgs, for example

        languagetool # needed by grammarous

        # -- o -- [ Linter ] --
        markdownlint # markdown
        vale # prose
        proselint # prose
        luaformatter # lua
        prisma-engines # schema.prisma files
        statix # nix
        shellcheck
        ruff # python linter used by null-ls

        nodePackages.eslint_d # js/ts
        nodePackages.prettier # js/ts

        # -- o -- [ Formatters ] --
        google-java-format
        alejandra # nix
        lua-language-server
        pyright # python lsp (written in node? so weird)
        black # python formatter
        rustfmt

        # -- o -- [ LSP Node Packages] --
        nodePackages.prisma
        nodePackages.svelte-language-server
        nodePackages.diagnostic-languageserver
        nodePackages.typescript-language-server
        nodePackages.bash-language-server
        nodePackages."@tailwindcss/language-server"
        yaml-language-server

        rust-analyzer # lsp for rust

        mypy # static typing  used by null-ls

        # --- [ RUST ] ---
        cargo
        rustc

        # --- [ PYTHON ] ---
        poetry

        # --- [ LATEX ] ---
        tex

        # --- [ VM  ] ---
        utm
      ]
      ++ (lib.optionals isDarwin [
        # MAC-only packages
        pkgs.cachix
        pkgs.tailscale
      ])
      ++ (lib.optionals isLinux [
        # Linux-only packages
        pkgs.chromium
        pkgs.firefox
        pkgs.rofi
        pkgs.valgrind
        pkgs.zathura
        pkgs.xfce.xfce4-terminal
      ]);

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      PAGER = "less -FirSwX";
      CLICLOLOR = 1;
      EDITOR = "nvim";
      MANPAGER = "${manpager}/bin/manpager";
    };

    # -- [ File System ] --
    file = {
      "red-panda-scripts".source =
        config.lib.file.mkOutOfStoreSymlink ./red-panda-scripts;
      "red-panda-scripts".recursive = true;
      ".inputrc".source = ./dotfiles/inputrc;
      ".gdbinit".source = ./dotfiles/gdbinit;
    };

    activation.name = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p personal $VERBOSE_ARG
      run mkdir -p projects $VERBOSE_ARG
      run mkdir -p work $VERBOSE_ARG
    '';
  };

  xdg.configFile =
    {
      "i3/config".text = builtins.readFile ./i3;
      "rofi/config.rasi".text = builtins.readFile ./rofi;
    }
    // (
      if isLinux
      then {
        "ghostty/config".text = builtins.readFile ./dotfiles/ghostty.linux;
      }
      else {}
    );

  programs = {
    bat = {
      enable = true;
      config.theme = "TwoDark";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        l = "ls --color=auto --classify=auto";
        ls = "ls --color=auto --classify=auto";
        nv = "nvim";
        nixswitch = "darwin-rebuild switch --flake ~/src/red-panda-sys-config/.#";
        nixup = "pushd ~/src/system-config; nix flake update; nixswitch; popd";
      };
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "Ben-Jasper Kettlitz";
      userEmail = "b-jk@gmx.net";
      aliases = {
        # common aliases
        br = "branch";
        co = "checkout";
        st = "status";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        cm = "commit -m";
        ca = "commit -am";
        dc = "diff --cached";
        amend = "commit --amend -m";

        # aliases for submodule
        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };
      extraConfig = {
        branch.autosetuprebase = "always";
        color.ui = true;
        core.askPass = ""; # needs to be empty to use terminal for ask pass
        credential.helper = "store";
        github.user = "bjk2k";
        push.default = "tracking";
        init.defaultBranch = "main";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = pkgs.lib.importTOML ./dotfiles/starship.toml;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };

    kitty = {
      enable = true;
      font = {
        name = "Cascadia Code Nerd Font";
      };
      theme = "Kanagawa_dragon";
      # Catppuccin-Frappe Catppuccin-Latte Catppuccin-Macchiato Catppuccin-Mocha
      extraConfig = ''
        hide_window_decorations yes
      '';
    };

    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
    };

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions;
        [
          vscodevim.vim
          wakatime.vscode-wakatime

          # Python
          ms-python.python
          ms-python.vscode-pylance
          ms-python.black-formatter
          ms-toolsai.jupyter
          ms-python.debugpy

          # Cpp
          ms-vscode.cpptools-extension-pack

          # Remote Development
          ms-vscode-remote.remote-containers
          ms-vscode-remote.remote-ssh

          # Github
          github.copilot
          github.copilot-chat

          # Markdown
          yzhang.markdown-all-in-one
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "kanagawa-black";
            publisher = "lamarcke";
            version = "1.0.5";
            sha256 = "sha256-YDw3tbOSg3k/Sff/GPheb0rK84cPq3Bs3eIJDEBj2j0=";
          }
        ];
    };

    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      shortcut = "q";
      terminal = "tmux-256color";
      historyLimit = 100000;
      keyMode = "vi";
      escapeTime = 10;
      sensibleOnTop = true;
      plugins = with pkgs; [
        # must be before continuum edits right status bar
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
          '';
        }

        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '10'
          '';
        }
        {
          plugin = tmuxPlugins.vim-tmux-navigator;
        }
      ];
      extraConfig = ''
        bind-key -r f run-shell "tmux neww $HOME/red-panda-scripts/tmux-sessioniser"
        bind-key -r h run-shell "tmux neww $HOME/red-panda-scripts/tmux-cht.sh"

      '';
    };

    i3status = {
      enable = isLinux;

      general = {
        colors = true;
        color_good = "#8C9440";
        color_bad = "#A54242";
        color_degraded = "#DE935F";
      };

      modules = {
        ipv6.enable = false;
        "wireless _first_".enable = false;
        "battery all".enable = false;
      };
    };
  };

  services.gpg-agent = {
    enable = isLinux;
    pinentryPackage = pkgs.pinentry-tty;

    # prevent password prompts from appearing
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./dotfiles/Xresources;
}
