return {
	"joerdav/templ.vim",
	"nvim-treesitter/playground",
	"nvim-treesitter/nvim-treesitter-context",
	"folke/neodev.nvim",
	"eslint/eslint",
	"windwp/nvim-ts-autotag",
	"nvim-tree/nvim-web-devicons",
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },
	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = "ibl",
		opts = {},
	},
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
