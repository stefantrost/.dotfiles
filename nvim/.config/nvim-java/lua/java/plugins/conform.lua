return {
  -- Autoformat
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>ff",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      return {
        timeout_ms = 1000,
        lsp_fallback = true, -- Use jdtls formatting for Java
      }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      -- Java formatting is handled by jdtls LSP
      -- If you prefer google-java-format, uncomment below and install via Mason
      -- java = { "google-java-format" },
    },
  },
}
