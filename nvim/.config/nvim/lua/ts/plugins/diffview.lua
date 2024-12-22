return {
  "sindrets/diffview.nvim",
  config = function()
    local map = vim.keymap
    map.set("n", "<leader>do", ":DiffviewOpen<CR>")
    map.set("n", "<leader>dc", ":DiffviewClose<CR>")
    map.set("n", "<leader>db", ":DiffviewOpen  HEAD<Left><Left><Left><Left><Left>")
  end,
}
