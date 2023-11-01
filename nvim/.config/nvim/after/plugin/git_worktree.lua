require("telescope").load_extension("git_worktree")

local map = vim.keymap


map.set("n", "<leader>ww", ":lua require('telescope').extensions.git_worktree.git_worktrees()<cr>")
map.set("n", "<leader>cw", ":lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>")
