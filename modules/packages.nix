{
  inputs,
  pkgs,
}:
with pkgs; [
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
  jq

  # --- [ Editors ] ---

  inputs.neve.packages.${system}.default

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
  # markdownlint # markdown
  vale # prose
  proselint # prose
  luaformatter # lua
  statix # nixrsrsrs
  shellcheck
  ruff # python linter used by null-ls
  nixfmt

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

  # --- [ University  ] ---
  anki-bin

  vfkit
  neovide

  # --- [ Zig  ] ---
  inputs.zig.packages.${pkgs.system}.master
]
