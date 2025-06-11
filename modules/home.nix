{ pkgs, lib, config, inputs, ... }:
let
  currentUser = config.people.myself;
  manpager = pkgs.writeShellScriptBin "manpager"
    (if pkgs.stdenvNoCC.isDarwin then ''
      sh -c 'col -bx | bat -l man -p'
    '' else ''
      cat "$1" | col -bx | bat --language man --style plain
    '');
in {
  home = {
    # Don't change this when you change package input. Leave it alone.
    stateVersion = "23.05";
    packages = import ./packages.nix { inherit pkgs inputs; }
      ++ lib.optionals pkgs.stdenvNoCC.isDarwin

      (import ./macos_packages.nix { inherit pkgs; });

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
      ".inputrc".source = ./dotfiles/inputrc;
      ".gdbinit".source = ./dotfiles/gdbinit;
    };
  };

  xdg = { enable = true; };

  programs = {
    bat = {
      enable = true;
      config.theme = "TwoDark";
    };
    home-manager = { enable = true; };

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
        l = "ls --color=auto";
        ls = "ls --color=auto";
        nv = "nvim";
        neo = "neovide --frame transparent";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = { enable = true; };
    };

    git = {
      enable = true;
      lfs.enable = true;
      package = pkgs.git;
      userName = config.people.users.${currentUser}.name;
      userEmail = config.people.users.${currentUser}.email;
      aliases = {
        # common aliases
        br = "branch";
        co = "checkout";
        st = "status";
        ls = ''
          log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'';
        ll = ''
          log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
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

    lazygit = { enable = true; };

    yazi = { enable = true; };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    # kitty = {
    #   enable = false;
    #   # font = { name = "Cascadia Code Nerd Font"; };
    #   themeFile = "kanagawa_dragon";
    #   # themeFile = "rose-pine";
    #   # Catppuccin-Frappe Catppuccin-Latte Catppuccin-Macchiato Catppuccin-Mocha
    #   extraConfig = ''
    #     hide_window_decorations titlebar-only
    #   '';
    # };

    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
    };
    zed-editor = {
      enable = true;
      extensions = [ "nix" "toml" "github-theme" "latex" "nix" ];
      userSettings = {

        buffer_font_family = "JetBrainsMono Nerd Font";
        buffer_font_fallbacks = [ "FiraCode Nerd Font" ];
        buffer_font_size = 14;
        ui_font_family = "Helvetica";
        ui_font_fallbacks = [ "Helvetica" "FiraCode Nerd Font" ];
        theme = {
          "mode" = "system";
          "dark" = "Github Dark";
          "light" = "Github Light";
        };
        load_direnv = "shell_hook";
        terminal = {
          alternate_scroll = "off";
          blinking = "off";
          copy_on_select = false;
          dock = "bottom";
          detect_venv = {
            on = {
              directories = [ ".env" "env" ".venv" "venv" ];
              activate_script = "default";
            };
          };
          env = { TERM = "xterm-ghostty"; };
          font_family = "JetBrainsMono Nerd Font";
          font_features = null;
          font_size = null;
          line_height = "comfortable";
          option_as_meta = false;
          button = false;
          shell = "system";
          toolbar.title = true;
          working_directory = "current_project_directory";
        };
        vim_mode = true;
        vim.toggle_relative_line_numbers = true;
      };

      installRemoteServer = true;
      userKeymaps =
        builtins.fromJSON (builtins.readFile ./dotfiles/zed_keymap.json);
    };

    neovide = {
      enable = true;
      settings = {
        frame = "transparent";
        fork = true;
        title-hidden = true;

      };

    };
    vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions;
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
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "kanagawa-black";
          publisher = "lamarcke";
          version = "1.0.5";
          sha256 = "sha256-YDw3tbOSg3k/Sff/GPheb0rK84cPq3Bs3eIJDEBj2j0=";
        }];
    };
  };
}
