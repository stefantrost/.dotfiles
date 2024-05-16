local lspconfig = require('lspconfig')
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
local lsp = vim.lsp

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
  init_options = {
    preferences = {
      -- other preferences... 
      importModuleSpecifierPreference = 'relative',
      importModuleSpecifierEnding = 'minimal',
    },
  },
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
