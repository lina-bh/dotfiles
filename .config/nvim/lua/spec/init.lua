return {
  {
    "Darazaki/indent-o-matic",
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup {}

      require("mason-tool-installer").setup {
        ensure_installed = { "stylua" },
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "hcl" },
        highlight = { enable = true },
      })
    end
  }
}
