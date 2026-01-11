return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      -- Enable terminal integration for Claude Code
      terminal = {},
    })
  end,
}