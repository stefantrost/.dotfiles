-- ftplugin/java.lua - Java Language Server configuration using nvim-jdtls

local jdtls = require('jdtls')

-- Find root directory for the Java project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require('jdtls.setup').find_root(root_markers)

-- Workspace directory (project-specific to avoid conflicts)
-- Each project gets its own workspace folder
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java-workspaces/' .. project_name

-- Get paths from Mason registry
local mason_registry = require('mason-registry')

-- Function to get Mason package path
local function get_mason_path(package_name)
  if mason_registry.is_installed(package_name) then
    return mason_registry.get_package(package_name):get_install_path()
  end
  vim.notify('Mason package not installed: ' .. package_name, vim.log.levels.WARN)
  return nil
end

-- Get jdtls installation path
local jdtls_path = get_mason_path('jdtls')
if not jdtls_path then
  vim.notify('jdtls not found. Please install via :Mason', vim.log.levels.ERROR)
  return
end

-- Get platform-specific config path
local system = vim.loop.os_uname().sysname
local config_name = 'config_mac'
if system == 'Linux' then
  config_name = 'config_linux'
elseif system:find('Windows') then
  config_name = 'config_win'
end

-- Path to jdtls configuration
local config_path = jdtls_path .. '/' .. config_name

-- Path to plugins jar
local plugins_path = jdtls_path .. '/plugins'
local launcher_jar = vim.fn.glob(plugins_path .. '/org.eclipse.equinox.launcher_*.jar')

-- Path to lombok jar (if you use Lombok in your projects)
local lombok_path = jdtls_path .. '/lombok.jar'

-- Bundles for java-debug and vscode-java-test (for debugging and testing)
local bundles = {}

-- Add java-debug adapter
local java_debug_path = get_mason_path('java-debug-adapter')
if java_debug_path then
  local java_debug_jar = vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar')
  if java_debug_jar ~= '' then
    table.insert(bundles, java_debug_jar)
  end
end

-- Add vscode-java-test
local java_test_path = get_mason_path('java-test')
if java_test_path then
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. '/extension/server/*.jar'), '\n'))
end

-- jdtls command
local cmd = {
  'java',
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xmx1g',
  '--add-modules=ALL-SYSTEM',
  '--add-opens', 'java.base/java.util=ALL-UNNAMED',
  '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

  -- Add lombok agent if it exists
  vim.fn.filereadable(lombok_path) == 1 and '-javaagent:' .. lombok_path or nil,

  '-jar', launcher_jar,
  '-configuration', config_path,
  '-data', workspace_dir,
}

-- Remove nil values from cmd
cmd = vim.tbl_filter(function(val)
  return val ~= nil
end, cmd)

-- Java Language Server settings
local settings = {
  java = {
    eclipse = {
      downloadSources = true,
    },
    configuration = {
      updateBuildConfiguration = "interactive",
      runtimes = {
        -- Add your Java runtimes here if needed
        -- {
        --   name = "JavaSE-17",
        --   path = "/path/to/jdk-17",
        -- },
      }
    },
    maven = {
      downloadSources = true,
    },
    implementationsCodeLens = {
      enabled = true,
    },
    referencesCodeLens = {
      enabled = true,
    },
    references = {
      includeDecompiledSources = true,
    },
    format = {
      enabled = true,
      settings = {
        url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
        profile = "GoogleStyle",
      },
    },
    signatureHelp = { enabled = true },
    contentProvider = { preferred = 'fernflower' },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org"
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },
}

-- Extended capabilities from nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- LSP keymaps (set when LSP attaches to buffer)
local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- LSP navigation
  map('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  map('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('n', 'gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  map('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- LSP actions
  map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
  map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Java-specific commands
  map('n', '<leader>jo', jdtls.organize_imports, '[J]ava [O]rganize Imports')
  map('n', '<leader>jv', jdtls.extract_variable, '[J]ava Extract [V]ariable')
  map('v', '<leader>jv', function() jdtls.extract_variable(true) end, '[J]ava Extract [V]ariable')
  map('n', '<leader>jc', jdtls.extract_constant, '[J]ava Extract [C]onstant')
  map('v', '<leader>jc', function() jdtls.extract_constant(true) end, '[J]ava Extract [C]onstant')
  map('v', '<leader>jm', function() jdtls.extract_method(true) end, '[J]ava Extract [M]ethod')

  -- Test commands
  map('n', '<leader>tn', jdtls.test_nearest_method, '[T]est [N]earest method')
  map('n', '<leader>tc', jdtls.test_class, '[T]est [C]lass')

  -- DAP (debugging) commands
  map('n', '<leader>df', jdtls.test_nearest_method, '[D]ebug Test [F]unction')
  map('n', '<leader>dc', jdtls.test_class, '[D]ebug Test [C]lass')

  -- Update imports on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })
end

-- DAP configuration (setup after jdtls starts)
local function setup_dap()
  jdtls.setup_dap({ hotcodereplace = 'auto' })
  require('jdtls.dap').setup_dap_main_class_configs()
end

-- Extended init_options for jdtls
local init_options = {
  bundles = bundles,
  extendedClientCapabilities = jdtls.extendedClientCapabilities,
}

-- jdtls configuration
local config = {
  cmd = cmd,
  root_dir = root_dir,
  settings = settings,
  init_options = init_options,
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    setup_dap()
  end,
}

-- Start or attach to jdtls
jdtls.start_or_attach(config)
