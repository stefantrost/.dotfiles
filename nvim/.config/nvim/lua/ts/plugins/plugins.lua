return {
  'joerdav/templ.vim',
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = false,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  'mbbill/undotree',
  'nvim-treesitter/playground',
  'nvim-treesitter/nvim-treesitter-context',
  'folke/neodev.nvim',
  'eslint/eslint',
  {
    'Equilibris/nx.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("nx").setup {}
    end
  },
  {
    "princejoogie/dir-telescope.nvim",
    -- telescope.nvim is a required dependency
    dependencies = {"nvim-telescope/telescope.nvim"},
    config = function()
      require("dir-telescope").setup({
        -- these are the default options set
        hidden = true,
        no_ignore = false,
        show_preview = true,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },
  "windwp/nvim-ts-autotag",
  'nvim-tree/nvim-web-devicons',
  "sindrets/diffview.nvim",
  'joeveiga/ng.nvim',
}
