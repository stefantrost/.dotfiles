return {
  dir = vim.fn.stdpath "config" .. "/lua/context-collector",
  name = "context-collector",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Optional but recommended
  },
  config = function()
    require("context-collector").setup {
      -- Optional configuration
    }
  end,
}
