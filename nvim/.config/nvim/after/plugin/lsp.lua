local lsp = require('lsp-zero')

lsp.on_attach(function(client,bufnr)
  lsp.default_keymaps({buffer = bufnr})
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definition<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

  vim.keymap.set('n', '<leader>nd', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
  vim.keymap.set('n', '<leader>pd', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)

  -- for OrganizeImports
  vim.keymap.set("n", "<leader>i", ":OrganizeImports<CR>")
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp.default_setup,
  },
})

local lua_opts = lsp.nvim_lua_ls()
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup(lua_opts)

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})

local configs = require('lspconfig/configs')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  filetypes = { "css", "html", "javascript", "vue", "scss", "templ"},
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
      },
    },
  }
})


--[[
local dot_git_path = vim.fn.finddir(".git", ".;")
local project_library_path = vim.fn.fnamemodify(dot_git_path, ":h")
local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}

require'lspconfig'.angularls.setup{
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
}
]]--

--[[
local cmd = {"node", languageServerPath.."/node_modules/@angular/language-server/index.js", "--stdio", "--tsProbeLocations", languageServerPath, "--ngProbeLocations", languageServerPath}

require'lspconfig'.angularls.setup{
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
}
]]
local function get_node_modules()
  local root_node = "/Users/stefantrost/.nvm/versions/node/v18.14.2/lib/node_modules"
  local stats = vim.loop.fs_stat(root_node)
  if stats == nil then
    return ''
  else
    return root_node
  end
end

local languageServerPath = get_node_modules()
local util = require "lspconfig.util"
local cmd = {"ngserver", "--stdio", "--tsProbeLocations", languageServerPath , "--ngProbeLocations", languageServerPath}

lspconfig.angularls.setup{
    on_attach = lsp.on_attach,
    capabilities = lsp.capabilities,
    root_dir = util.root_pattern("angular.json", "project.json"),
    cmd = cmd,
    on_new_config = function(new_config, new_root_dir)
        new_config.cmd = cmd
    end,
}


require('lspconfig').eslint.setup{}

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

-- OrganizeImports
lspconfig.tsserver.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports"
    }
  }
}

lspconfig.sqls.setup{
  on_attach = function (client, bufnr)
    require('sqls').on_attach(client, bufnr)
  end
}

lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

lsp.setup()

