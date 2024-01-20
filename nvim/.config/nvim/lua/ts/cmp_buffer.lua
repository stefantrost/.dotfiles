local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format()

cmp.setup {
  sources = {
    {name = 'nvim_lsp'},
  },
  formatting = cmp_format,
}
