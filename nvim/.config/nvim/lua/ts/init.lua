require("ts.remap")
require("ts.set")
require("ts.packer")

-- Populate Quickfixlist with all files in directory of current file
vim.keymap.set("n", "<leader>qd", ":set errorformat=%f | cexpr glob(expand('%:p:h')..'/*')<CR>")
