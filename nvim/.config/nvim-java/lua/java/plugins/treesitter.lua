return {
  -- Main treesitter plugin
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "java",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "json",
          "yaml",
          "xml",
          "bash",
          "markdown",
          "markdown_inline"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      }

      -- Treesitter context setup
      local ok_context, treesitter_context = pcall(require, "treesitter-context")
      if ok_context then
        treesitter_context.setup {
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
      end
    end,
  },

  -- Textobjects as separate plugin with explicit dependency
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy", -- Load after startup
    config = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      }
    end,
  },
}
