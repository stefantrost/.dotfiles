-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.3',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({ 'navarasu/onedark.nvim'})

  use({
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = false,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  })

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')
  use('nvim-treesitter/nvim-treesitter-context')
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      --- Uncomment these if you want to manage LSP servers from neovim
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- LSP Support
      {'neovim/nvim-lspconfig'},
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-nvim-lua'},
      {'saadparwaiz1/cmp_luasnip'},
      {'L3MON4D3/LuaSnip'},
    }
  }
  use('folke/neodev.nvim')
  use('airblade/vim-gitgutter')
  use('eslint/eslint')
  use {
    'Equilibris/nx.nvim',
    requires = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("nx").setup {}
    end
  }
  --use('cohama/lexima.vim')
  use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
}
  use "windwp/nvim-ts-autotag"
  use 'nvim-tree/nvim-web-devicons'
  use{'nvim-lualine/lualine.nvim',
  require = { 'nvim-tree/nvim-web-devicons', opt = true }
}
-- Packer
use "sindrets/diffview.nvim"
use 'joeveiga/ng.nvim'
end)
