return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio", -- Required for dap-ui
  },
  keys = {
    -- DAP keymaps
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
    { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Debug: Set Conditional Breakpoint" },
  },
  config = function()
    local dap = require("dap")

    -- DAP signs/icons
    vim.fn.sign_define('DapBreakpoint', { text='🔴', texthl='', linehl='', numhl='' })
    vim.fn.sign_define('DapBreakpointCondition', { text='🟡', texthl='', linehl='', numhl='' })
    vim.fn.sign_define('DapBreakpointRejected', { text='🚫', texthl='', linehl='', numhl='' })
    vim.fn.sign_define('DapLogPoint', { text='📝', texthl='', linehl='', numhl='' })
    vim.fn.sign_define('DapStopped', { text='▶️', texthl='', linehl='', numhl='' })

    -- Java DAP configuration is done in ftplugin/java.lua via jdtls
  end,
}
