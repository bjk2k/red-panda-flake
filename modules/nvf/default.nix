# nvf (notashelf/nvf) home-manager module
# Provides a configurable Neovim distribution with the nvf maximal build as a baseline.
# Enable per-host with: modules.nvf.enable = true
{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.nvf;
in {
  options.modules.nvf = {
    enable = mkEnableOption "nvf neovim distribution (maximal baseline)";

    theme = {
      name = mkOption {
        type = types.str;
        default = "github";
        description = "nvf theme name (e.g. catppuccin, onedark, tokyonight).";
        example = "tokyonight";
      };
      style = mkOption {
        type = types.str;
        default = "dark_high_contrast";
        description = "Theme style/variant (e.g. mocha, latte, storm).";
        example = "latte";
      };
      transparent = mkOption {
        type = types.bool;
        default = false;
        description = "Enable transparent background.";
      };
    };

    assistant = {
      avante.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable avante.nvim in-editor AI assistant sidebar.";
      };
      copilot.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable GitHub Copilot integration.";
      };
    };

    notes.obsidian = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable obsidian.nvim integration for editing an Obsidian vault.";
      };
      vaultPath = mkOption {
        type = types.str;
        default = "~/personal/vault/";
        description = "Filesystem path to the Obsidian vault workspace.";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.people.myself} = {
      # Pull in the nvf home-manager module so that `programs.nvf` is available.
      imports = [inputs.nvf.homeManagerModules.nvf];

      programs.nvf = {
        enable = true;

        settings.vim = {
          viAlias = true;
          vimAlias = true;

          opts.expandtab = true;

          # ── Leader key ──────────────────────────────────────────────────────
          # Use comma as leader, matching the Zed keymap scheme.
          globals.mapleader = ",";

          # Update which-key label so it shows "," rather than "SPACE".
          binds.whichKey.setupOpts.replace = {
            "<leader>" = ",";
            "<cr>" = "RETURN";
            "<space>" = "SPACE";
            "<tab>" = "TAB";
          };

          # ── Custom keymaps (Zed scheme) ──────────────────────────────────
          # <C-j> is repurposed for terminal toggle; release smart-splits'
          # default binding for that key to avoid a conflict.
          utility.smart-splits.keymaps.move_cursor_down = null;

          keymaps =
            [
              # ── Insert mode ─────────────────────────────────────────────────
              {
                key = "jk";
                mode = ["i"];
                action = "<Esc>";
                desc = "Exit insert mode";
              }

              # ── File tree (, o) ─────────────────────────────────────────────
              {
                key = "<leader>o";
                mode = ["n"];
                action = "<cmd>Neotree toggle<cr>";
                desc = "Toggle file tree";
              }

              # ── File finder (, space) ────────────────────────────────────────
              {
                key = "<leader><space>";
                mode = ["n"];
                action = "<cmd>Telescope find_files<cr>";
                desc = "Find files";
              }

              # ── Search in project (, /) ──────────────────────────────────────
              {
                key = "<leader>/";
                mode = ["n"];
                action = "<cmd>Telescope live_grep<cr>";
                desc = "Search in project (live grep)";
              }

              # ── Code actions (, c a) ─────────────────────────────────────────
              {
                key = "<leader>ca";
                mode = [
                  "n"
                  "v"
                ];
                action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
                desc = "Code actions";
              }

              # ── Rename symbol (, c r) ────────────────────────────────────────
              {
                key = "<leader>cr";
                mode = ["n"];
                action = "<cmd>lua vim.lsp.buf.rename()<cr>";
                desc = "Rename symbol";
              }

              # ── Diagnostics panel (, s D) ────────────────────────────────────
              {
                key = "<leader>sD";
                mode = ["n"];
                action = "<cmd>Trouble diagnostics toggle<cr>";
                desc = "Toggle diagnostics panel (Trouble)";
              }

              # ── Toggle inline diagnostics (, u D) ────────────────────────────
              {
                key = "<leader>uD";
                mode = ["n"];
                action = "<cmd>lua vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_text})<cr>";
                desc = "Toggle inline diagnostics";
              }

              # ── Navigate diagnostics ([ d / ] d) ────────────────────────────
              {
                key = "[d";
                mode = ["n"];
                action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
                desc = "Previous diagnostic";
              }
              {
                key = "]d";
                mode = ["n"];
                action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
                desc = "Next diagnostic";
              }

              # ── Toggle terminal (ctrl-j / ctrl-w t) ─────────────────────────
              {
                key = "<C-j>";
                mode = [
                  "n"
                  "t"
                ];
                action = "<cmd>ToggleTerm<cr>";
                desc = "Toggle terminal";
              }
            ]
            # ── Obsidian notes (, n …) ──────────────────────────────────────
            # Only registered when the vault integration is enabled, so the
            # ":Obsidian" command is guaranteed to exist.
            ++ optionals cfg.notes.obsidian.enable [
              {
                key = "<leader>nn";
                mode = ["n"];
                action = "<cmd>Obsidian new<cr>";
                desc = "Note: new";
              }
              {
                key = "<leader>nu";
                mode = ["n"];
                action = "<cmd>Obsidian unique_note<cr>";
                desc = "Note: new unique (timestamped)";
              }
              {
                key = "<leader>no";
                mode = ["n"];
                action = "<cmd>Obsidian quick_switch<cr>";
                desc = "Note: open / quick switch";
              }
              {
                key = "<leader>ns";
                mode = ["n"];
                action = "<cmd>Obsidian search<cr>";
                desc = "Note: search (grep)";
              }
              {
                key = "<leader>nt";
                mode = ["n"];
                action = "<cmd>Obsidian today<cr>";
                desc = "Note: today's daily note";
              }
            ]; # keymaps

          debugMode = {
            enable = false;
            level = 16;
            logFile = "/tmp/nvim.log";
          };

          spellcheck = {
            enable = true;
            # vim-dirtytalk requires :DirtytalkUpdate on first use to download
            # the spellfile; until then it prints a startup error. Disabled.
            programmingWordlist.enable = false;
          };

          # nvf turns the global 'spell' option on. We only want automatic
          # spellchecking in prose buffers — code files should stay quiet
          # unless spell is toggled on manually (e.g. `:set spell`). A FileType
          # allowlist is more robust than a code-filetype blocklist given the
          # large language set enabled below. Because this only fires on
          # FileType, a later manual `:set spell` in a code buffer still sticks.
          augroups = [{name = "nvf_user_spell";}];
          autocmds = [
            {
              event = ["FileType"];
              group = "nvf_user_spell";
              desc = "Enable spell only in prose filetypes";
              callback = {
                _type = "lua-inline";
                expr = ''
                  function(ev)
                    local prose = {
                      markdown        = true,
                      ["markdown.mdx"] = true,
                      text            = true,
                      gitcommit       = true,
                      gitrebase       = true,
                      tex             = true,
                      plaintex        = true,
                      typst           = true,
                      asciidoc        = true,
                      rst             = true,
                      mail            = true,
                      org             = true,
                    }
                    vim.opt_local.spell = prose[vim.bo[ev.buf].filetype] == true
                  end
                '';
              };
            }
          ];

          # ── LSP ──────────────────────────────────────────────────────────────
          lsp = {
            enable = true;
            formatOnSave = true;
            lspkind.enable = false;
            lightbulb.enable = true;
            lspsaga.enable = false;
            trouble.enable = true;
            # blink-cmp (enabled below) supersedes lspSignature in maximal
            lspSignature.enable = false;
            # otter-nvim eagerly requires nvim-treesitter.ts_utils at startup,
            # which races with lzn-auto-require's lazy loading and causes an
            # E5113 on init. Disabled until nvf resolves the load-order issue.
            otter-nvim.enable = false;
            nvim-docs-view.enable = true;
            # harper-ls emits English spelling/grammar issues as LSP
            # diagnostics, which flood the Trouble panel. Disabled so Trouble
            # only shows real code diagnostics. Prose spellchecking is still
            # provided by Neovim's native `spell` (see the spell autocmd above),
            # which uses underlines and never touches the diagnostics list.
            presets.harper.enable = false;
          };

          # ── Debugger ─────────────────────────────────────────────────────────
          debugger.nvim-dap = {
            enable = true;
            ui.enable = true;
          };

          # ── Languages ────────────────────────────────────────────────────────
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            # Always-on
            nix.enable = true;
            markdown = {
              enable = true;
              # In-buffer markdown rendering (headings, code blocks, tables,
              # checkboxes, callouts) via render-markdown.nvim.
              extensions.render-markdown-nvim.enable = true;
              # nvf defaults render-markdown's `file_types` to null, and the
              # avante module appends "Avante" to it via `lib.mkAfter`. With no
              # base value the list collapses to just ["Avante"], so
              # render-markdown attaches ONLY to avante's AI sidebar and never
              # to real markdown/Obsidian buffers — tables (and everything else)
              # stop rendering. Supply the base filetype explicitly; avante's
              # mkAfter still appends, yielding ["markdown" "Avante"].
              extensions.render-markdown-nvim.setupOpts.file_types = ["markdown"];
            };

            # Maximal set
            bash.enable = true;
            clang = {
              enable = true;
              dap.enable = true;
            };
            cmake.enable = true;
            css.enable = true;
            # some-sass-language-server pulls in keytar which fails to build
            # against Node 24 / newer Clang on nixpkgs-unstable. Re-enable
            # once the upstream keytar compilation issue is resolved.
            scss.enable = false;
            html.enable = true;
            json.enable = true;
            sql.enable = true;
            java.enable = false;
            kotlin.enable = false;
            typescript.enable = false;
            go.enable = true;
            lua.enable = true;
            zig.enable = true;
            python = {
              enable = true;
              dap.enable = true;
            };
            typst.enable = true;
            rust = {
              enable = true;
              dap.enable = true;
              extensions.crates-nvim.enable = true;
            };
            toml.enable = true;
            xml.enable = true;
            tex.enable = true;
            docker.enable = true;
            env.enable = true;

            # Broken on Darwin — keep disabled.
            # See: https://github.com/PMunch/nimlsp/issues/178
            nim.enable = false;
          };

          # ── Visuals ──────────────────────────────────────────────────────────
          visuals = {
            nvim-scrollbar.enable = true;
            nvim-web-devicons.enable = true;
            nvim-cursorline.enable = true;
            cinnamon-nvim.enable = true;
            fidget-nvim.enable = true;
            highlight-undo.enable = true;
            blink-indent.enable = true;
            indent-blankline.enable = true;
          };

          # ── Status / Tab line ────────────────────────────────────────────────
          statusline.lualine = {
            enable = true;
            # Do not set theme explicitly: nvf's default detects catppuccin's
            # lualine integration and wires it up correctly. Setting it to the
            # raw theme name bypasses that check and causes a "not available"
            # warning.
          };

          tabline.nvimBufferline.enable = true;

          # ── Theme ────────────────────────────────────────────────────────────
          theme = {
            enable = true;
            name = cfg.theme.name;
            style = cfg.theme.style;
            transparent = cfg.theme.transparent;
          };

          # ── Editing utilities ────────────────────────────────────────────────
          autopairs.nvim-autopairs.enable = true;
          snippets.luasnip.enable = true;

          # blink-cmp is the maximal-preferred completion engine
          autocomplete.blink-cmp.enable = true;

          treesitter.context.enable = true;

          # ── Treesitter text objects ──────────────────────────────────────────
          # Syntax-aware text objects (select/swap/move) layered on top of the
          # treesitter parsers already pulled in by languages.enableTreesitter.
          # NOTE: the upstream `move.set_jumps`/repeat feature rebinds `;` and
          # `,` in normal/operator mode — `,` is our leader, so we deliberately
          # do NOT enable that remap and rely on `]`/`[` motions instead.
          treesitter.textobjects = {
            enable = true;
            setupOpts = {
              select = {
                enable = true;
                # Jump forward to a text object if the cursor isn't on one.
                lookahead = true;
                keymaps = {
                  "af" = "@function.outer";
                  "if" = "@function.inner";
                  "ac" = "@class.outer";
                  "ic" = "@class.inner";
                  "aa" = "@parameter.outer";
                  "ia" = "@parameter.inner";
                  "ai" = "@conditional.outer";
                  "ii" = "@conditional.inner";
                  "al" = "@loop.outer";
                  "il" = "@loop.inner";
                };
              };
              swap = {
                enable = true;
                swap_next = {
                  "<leader>sa" = "@parameter.inner";
                };
                swap_previous = {
                  "<leader>sA" = "@parameter.inner";
                };
              };
              move = {
                enable = true;
                set_jumps = true;
                goto_next_start = {
                  "]m" = "@function.outer";
                  "]]" = "@class.outer";
                };
                goto_next_end = {
                  "]M" = "@function.outer";
                  "][" = "@class.outer";
                };
                goto_previous_start = {
                  "[m" = "@function.outer";
                  "[[" = "@class.outer";
                };
                goto_previous_end = {
                  "[M" = "@function.outer";
                  "[]" = "@class.outer";
                };
              };
            };
          };

          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          # ── Navigation ───────────────────────────────────────────────────────
          telescope.enable = true;

          filetree.neo-tree.enable = true;

          # ── Git ──────────────────────────────────────────────────────────────
          git = {
            enable = true;
            gitsigns.enable = true;
            # Disabled: throws an annoying debug message upstream
            gitsigns.codeActions.enable = false;
            neogit.enable = true;
          };

          # ── Dashboard / Minimap ──────────────────────────────────────────────
          # Alpha is enabled; luaConfigPost (below) overrides the button hints
          # with the correct "," leader after alpha has been set up.
          dashboard.alpha.enable = true;
          # codewindow calls nvim-treesitter.ts_utils at startup which races
          # with lzn-auto-require's lazy loading and causes an E5113 on init.
          minimap.codewindow.enable = false;

          # ── Notifications ────────────────────────────────────────────────────
          notify.nvim-notify.enable = true;

          # ── Projects ─────────────────────────────────────────────────────────
          projects.project-nvim.enable = true;

          # ── Utility ──────────────────────────────────────────────────────────
          utility = {
            diffview-nvim.enable = true;
            icon-picker.enable = true;
            surround.enable = true;
            leetcode-nvim.enable = true;
            multicursors.enable = true;
            smart-splits.enable = true;
            undotree.enable = true;
            nvim-biscuits.enable = true;
            grug-far-nvim.enable = true;
            motion = {
              hop.enable = true;
              leap.enable = true;
              precognition.enable = true;
            };
            images.img-clip.enable = true;
          };

          # ── Notes ────────────────────────────────────────────────────────────
          notes = {
            todo-comments.enable = true;

            # obsidian.nvim — vault editing. Uses Telescope (enabled above) as
            # its picker. The plugin's own UI rendering is auto-disabled in
            # favour of render-markdown.nvim when that extension is enabled.
            obsidian = {
              enable = cfg.notes.obsidian.enable;
              setupOpts.workspaces = [
                {
                  name = "notes";
                  path = cfg.notes.obsidian.vaultPath;
                }
              ];
            };
          };

          # ── Terminal ─────────────────────────────────────────────────────────
          terminal.toggleterm = {
            enable = true;
            lazygit.enable = true;
          };

          # ── UI chrome ────────────────────────────────────────────────────────
          ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            illuminate.enable = true;
            breadcrumbs = {
              enable = true;
              navbuddy.enable = true;
            };
            smartcolumn = {
              enable = true;
              setupOpts.custom_colorcolumn = {
                nix = "110";
                ruby = "120";
                java = "130";
                go = [
                  "90"
                  "130"
                ];
              };
            };
            fastaction.enable = true;
          };

          # ── AI assistant ─────────────────────────────────────────────────────
          assistant = {
            chatgpt.enable = false;
            copilot = {
              enable = cfg.assistant.copilot.enable;
              cmp.enable = cfg.assistant.copilot.enable;
            };
            codecompanion-nvim.enable = false;
            avante-nvim = {
              enable = cfg.assistant.avante.enable;
              setupOpts = {
                # ACP (Agent Client Protocol) via the claude-agent-acp binary
                # (pkgs.claude-agent-acp from nixpkgs-unstable, installed into
                # PATH via packages.nix). No npx download required.
                provider = "claude-code";
                acp_providers = {
                  "claude-code" = {
                    command = "claude-agent-acp";
                    args = [];
                    env = {
                      NODE_NO_WARNINGS = "1";
                      ANTHROPIC_API_KEY = {
                        _type = "lua-inline";
                        expr = ''os.getenv("ANTHROPIC_API_KEY")'';
                      };
                    };
                  };
                };
              };
            };
          };

          # ── Comments ─────────────────────────────────────────────────────────
          comments.comment-nvim.enable = true;

          # ── avante repo-map UTF-8 guard ──────────────────────────────────────
          # avante's `@codebase` repo map parses files with a native Rust
          # function (`avante_repo_map.stringify_definitions`, via mlua) that
          # raises a hard error on any content that isn't valid UTF-8:
          #   bad argument #2 … invalid utf-8 sequence … from index N
          # The initial map build runs through ripgrep and so honours
          # .gitignore, but the repo map ALSO installs a recursive fs_event
          # watcher (repo_map.lua) that re-parses every changed same-extension
          # file and respects neither .gitignore NOR repo_map.ignore_patterns.
          # In a Python project that means gitignored, non-UTF-8 files (e.g.
          # localisation blobs / compiled artifacts under .venv) reach the
          # parser and abort it. Wrap the function so unparseable files are
          # skipped (returns "") instead of crashing. The guard is installed on
          # the User AvanteInputSubmitted event, which fires before any
          # repo-map call — both the build and the watcher it creates then use
          # the wrapped function.
          # luaConfigPost = ''
          #   vim.api.nvim_create_autocmd("User", {
          #     pattern = "AvanteInputSubmitted",
          #     desc = "Guard avante repo-map parser against non-UTF-8 files",
          #     callback = function()
          #       local ok, core = pcall(require, "avante_repo_map")
          #       if not ok or type(core) ~= "table" or core.__nvf_utf8_guard then
          #         return
          #       end
          #       local orig = core.stringify_definitions
          #       if type(orig) ~= "function" then return end
          #       core.stringify_definitions = function(lang, source)
          #         local ok2, res = pcall(orig, lang, source)
          #         return ok2 and res or ""
          #       end
          #       core.__nvf_utf8_guard = true
          #     end,
          #   })
          # '';

          # ── Alpha dashboard: patch button hints to use "," leader ────────────
          # nvf sets up alpha with the upstream "dashboard" theme which
          # hardcodes "SPC" in every button label. We re-run alpha.setup inside
          # vim.schedule so it fires after VimEnter (and thus after lz.n has
          # already loaded alpha), replacing the button shortcuts with ",".
          # luaConfigPost = ''
          #   vim.schedule(function()
          #     local ok_a, alpha     = pcall(require, "alpha")
          #     local ok_d, dashboard = pcall(require, "alpha.themes.dashboard")
          #     if not (ok_a and ok_d) then return end
          #
          #     dashboard.section.buttons.val = {
          #       dashboard.button(", <space>", "  Find file",    ":Telescope find_files<CR>"),
          #       dashboard.button(",/",        "  Live grep",     ":Telescope live_grep<CR>"),
          #       dashboard.button(",o",        "  File tree",     ":Neotree toggle<CR>"),
          #       dashboard.button(",gs",       "  Git status",    ":Neogit<CR>"),
          #       dashboard.button(",sl",       "  Load session",  ":SessionManager load_last_session<CR>"),
          #       dashboard.button("q",         "  Quit",          ":qa<CR>"),
          #     }
          #
          #     alpha.setup(dashboard.opts)
          #   end)
          # '';
        };
      };
    };
  };
}
