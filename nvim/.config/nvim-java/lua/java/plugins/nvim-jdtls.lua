return {
  "mfussenegger/nvim-jdtls",
  ft = "java", -- Only load for Java files
  dependencies = {
    "mfussenegger/nvim-dap", -- Required for debugging support
  },
}
