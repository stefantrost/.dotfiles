return {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'onsails/lspkind.nvim',
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
    config = function ()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      vim.opt.shortmess:append "c"

      local lspkind = require "lspkind"
      lspkind.init {}

      local cmp = require "cmp"

      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        },
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
          },
          { "i", "c" }
        ),
        },

        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        -- for more cmp and snippet config: https://youtu.be/22mrSjknDHI?si=_C9OOZ3JXR1MQifM&t=182
      }
    end,
  }
