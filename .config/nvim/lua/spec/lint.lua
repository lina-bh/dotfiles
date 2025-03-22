return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      sh = { "shellcheck" },
    }

    local augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
