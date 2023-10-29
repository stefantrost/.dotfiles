local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format()

cmp.setup {
  sources = {
    {name = 'nvim_lsp'},
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    }
  },
  formatting = cmp_format,
}
