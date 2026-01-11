-- Alternative: Simple terminal-based integration
-- Uncomment to use this instead of the official claudecode.nvim
--[[
return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("claude-code").setup({
      -- Terminal window settings
      window = {
        split_ratio = 0.3,
        position = "botright", -- or "float" for floating window
        enter_insert = true,
        hide_numbers = true,
        hide_signcolumn = true,
        
        -- Floating window configuration (only if position = "float")
        float = {
          width = "90%",
          height = "90%",
          row = "center",
          col = "center",
          relative = "editor",
          border = "double",
        },
      },
      -- File refresh settings
      refresh = {
        enable = true,
        updatetime = 100,
        timer_interval = 1000,
        show_notifications = true,
      },
      -- Git project settings
      git = {
        use_git_root = true,
      },
      -- Command settings
      command = "claude",
      command_variants = {
        continue = "--continue",
        resume = "--resume",
        verbose = "--verbose",
      },
      -- Keymaps
      keymaps = {
        toggle = {
          normal = "<leader>cc",
          terminal = "<C-,>",
          variants = {
            continue = "<leader>cC",
            verbose = "<leader>cV",
          },
        },
        window_navigation = true,
        scrolling = true,
      }
    })
  end
}
--]]

-- This file is disabled by default. To use this integration instead:
-- 1. Remove or rename claude-code.lua 
-- 2. Uncomment the above configuration
-- 3. Restart Neovim

return {}