vim.diagnostic.config {
  virtual_text = true,
  signs = false,
}

local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

if not (vim.uv or vim.loop).fs_stat(pckr_path) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/lewis6991/pckr.nvim",
    pckr_path,
  }
end

vim.opt.rtp:prepend(pckr_path)

local pckr = require("pckr")

pckr.add {
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
          lua = { "stylua" },
          fish = { "fish_indent" },
          nix = { "nixfmt" },
          python = { "ruff_organize_imports", "ruff_format" },
          terraform = { "terraform_fmt" },
        },

        format_on_save = {
          lsp_format = "fallback",
          async = false,
        },
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
        sh = { "shellcheck" },
        nix = { "nix" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
