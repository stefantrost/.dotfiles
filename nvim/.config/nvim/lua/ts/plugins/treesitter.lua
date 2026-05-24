return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    local nts = require("nvim-treesitter")
    nts.setup {}

    local ensure_installed = {
      "javascript", "typescript", "tsx", "c", "lua", "vim", "vimdoc",
      "query", "blade", "html", "css", "json", "yaml", "bash",
      "markdown", "markdown_inline",
    }

    local installed = nts.get_installed("parsers")
    local to_install = vim.tbl_filter(function(lang)
      return not vim.tbl_contains(installed, lang)
    end, ensure_installed)
    if #to_install > 0 then
      nts.install(to_install)
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and pcall(vim.treesitter.language.add, lang) then
          pcall(vim.treesitter.start, args.buf, lang)
        end
      end,
    })

    require("treesitter-context").setup {
      enable = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
      on_attach = nil,
    }
  end,
}
