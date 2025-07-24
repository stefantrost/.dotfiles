-- Set leader
vim.g.mapleader = " "

-- Open file tree
vim.keymap.set("n", "<leader>fe", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- move highlighted lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in position, when appending next line to this line
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor mid screen when moving up/down half page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- show found word mid screen when jumping to next/prev
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- keep word in paste buffer when replacing other word
vim.keymap.set("x", "<leader>p", '"_dP')

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- delete into void, ie not into paste buffer
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- quickfix list???
vim.keymap.set("n", "<leader>qf", ":copen<CR>")
vim.keymap.set("n", "<leader>qc", ":cclose<CR>")
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-e>", "<cmd>cprev<CR>zz")
-- location list
--vim.keymap.set("n", "<leader>e", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>n", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.keymap.set("n", "<leader>pp", "ma :silent %!prettier --stdin-filepath %<CR> `azz")

vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-N>")

-- Populate Quickfixlist with all files in directory of current file
vim.keymap.set("n", "<leader>qd", ":set errorformat=%f | cexpr glob(expand('%:p:h')..'/*')<CR>")

-- accept left/right in merge confict view
vim.keymap.set("n", "<leader>g", ":diffget //2<CR>")
vim.keymap.set("n", "<leader>m", ":diffget //3<CR>")

-- restart lsp
vim.keymap.set("n", "<leader>ls", ":LspRestart<CR>")
-- Organize Imports needs tsserver config
vim.keymap.set(
  "n",
  "<leader>oi",
  ':lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})<CR>'
)
