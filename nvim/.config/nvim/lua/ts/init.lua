require("ts.remap")
require("ts.set")
require("ts.packer")

-- Populate Quickfixlist with all files in directory of current file
vim.keymap.set("n", "<leader>qd", ":set errorformat=%f | cexpr glob(expand('%:p:h')..'/*')<CR>")

-- accept left/right in merge confict view
vim.keymap.set("n", "<leader>t", ":diffget //2<CR>")
vim.keymap.set("n", "<leader>n", ":diffget //3<CR>")

-- restart lsp
  vim.keymap.set("n", "<leader>ls" ,":LspRestart<CR>")
