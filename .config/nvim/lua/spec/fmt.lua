return {
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>f",
      function(...)
        require("conform").format()
      end,
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" }
    },
  },
  config = function()
    local augroup = vim.api.nvim_create_augroup("conform", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      callback = function()
        require("conform").format()
       end
    })
  end
}
