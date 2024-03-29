-- Set leader
vim.g.mapleader = " "
-- Colemak remappings
vim.keymap.set({"n", "v"}, "m", "h")
vim.keymap.set({"n", "v"}, "n", "j")
vim.keymap.set({"n", "v"}, "e", "k")
vim.keymap.set({"n", "v"}, "i", "l")
vim.keymap.set({"n", "v"}, "l", "i")
vim.keymap.set({"n", "v"}, "L", "I")

-- Open file tree
vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)

-- move highlighted lines up/down
vim.keymap.set("v", "N", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "E", ":m '<-2<CR>gv=gv")


-- keep cursor in position, when appending next line to this line
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor mid screen when moving up/down half page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- show found word mid screen when jumping to next/prev
vim.keymap.set("n", "<leader>n", "nzzzv")
vim.keymap.set("n", "<leader>N", "Nzzzv")

-- keep word in paste buffer when replacing other word
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- delete into void, ie not into paste buffer
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

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
vim.keymap.set("n", "<leader>t", ":diffget //2<CR>")
vim.keymap.set("n", "<leader>n", ":diffget //3<CR>")

-- restart lsp
vim.keymap.set("n", "<leader>ls" ,":LspRestart<CR>")
