vim.api.nvim_command("source ~/.vimrc")

vim.diagnostic.config {
  underline = true,
  signs = false,
}

vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"

local my_lua = vim.api.nvim_create_augroup("my.lua", {})

vim.api.nvim_create_autocmd("CursorHold", {
  group = my_lua,
  callback = function()
    local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
    local diagnostics = vim.diagnostic.get(0, { lnum = lnum - 1 })
    if #diagnostics > 0 then
      vim.api.nvim_echo({
        {
          vim
            .iter(diagnostics)
            :filter(function(d)
              return col >= d.col and col < d.end_col
            end)
            :map(function(d)
              return d.message
            end)
            :join("\n"),
          "WarningMsg",
        },
      }, false, {})
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = my_lua,
  pattern = "lua",
  callback = function(args)
    vim.bo.omnifunc = "v:lua.vim.lua_omnifunc"
  end,
})

vim.cmd.colorscheme("vim")

-- vim.api.nvim_create_user_command("Diagnostics")

local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
vim.opt.rtp:prepend(pckr_path)

function plugins()
  if vim.g.my_plugins then
    return
  end

  local pckr_loaded, pckr = pcall(require, "pckr")
  if not pckr_loaded then
    return
  end

  pckr.add {
    {
      "mason-org/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      requires = "mason-org/mason.nvim",
      config = function()
        require("mason-tool-installer").setup {
          ensure_installed = {
            "stylua",
            "shellcheck",
            "bash-language-server",
            "tree-sitter-cli",
          },
        }
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require("nvim-treesitter").install { "go" }
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        vim.lsp.enable("bashls")
        vim.lsp.enable("rust_analyzer")
        vim.lsp.enable("stylua")
      end,
    },
    {
      "stevearc/conform.nvim",
      config = function()
        local conform = require("conform")
        conform.setup {
          formatters = {
            terraform_fmt = {
              command = "tofu",
            },
          },

          formatters_by_ft = {
            fish = { "fish_indent" },
            nix = { "nixfmt" },
            python = { "ruff_organize_imports", "ruff_format" },
            terraform = { "terraform_fmt" },
            ["*"] = { "trim_whitespace" },
          },

          default_format_opts = {
            stop_after_first = true,
          },

          format_on_save = {
            lsp_format = "never",
          },

          format_after_save = {
            lsp_format = "prefer",
            async = true,
          },

          notify_no_formatters = false,
        }

        vim.api.nvim_create_user_command("Format", function(args)
          local range = nil
          if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
              start = { args.line1, 0 },
              ["end"] = { args.line2, end_line:len() },
            }
          end
          conform.format { async = true, range = range }
        end, { range = true })
      end,
    },
    {
      "mfussenegger/nvim-lint",
      config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
          nix = { "nix" },
        }

        vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
          callback = function()
            lint.try_lint(nil, { ignore_errors = true })
          end,
        })
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        local actions = require("telescope.actions")
        require("telescope").setup {
          defaults = {
            mappings = {
              i = {
                ["<Esc>"] = actions.close,
                ["<C-g>"] = actions.close,
              },
              n = {
                ["<C-g>"] = actions.close,
              },
            },
          },
        }

        local builtin = require("telescope.builtin")
        vim.keymap.set("", "<Leader>pf", builtin.find_files)
        vim.keymap.set("", "<Leader>pg", builtin.grep_string)
        vim.keymap.set("", "<Leader>b", builtin.buffers)
        vim.keymap.set("", "<C-h>k", builtin.keymaps)

        vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = { "lua", "vim" },
          callback = function(args)
            vim.keymap.set("n", "<C-h>v", builtin.help_tags, { buffer = args.buf })
            vim.keymap.set("n", "<C-h>f", builtin.help_tags, { buffer = args.buf })
          end,
        })
      end,
    },
    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end,
    },
  }

  vim.g.my_plugins = true
end

local function bootstrap_pckr()
  if not (vim.uv or vim.loop).fs_stat(pckr_path) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/lewis6991/pckr.nvim",
      pckr_path,
    }
  end
  plugins()
end

vim.api.nvim_create_user_command("PckrInstall", function(args)
  bootstrap_pckr()
end, {})

plugins()
