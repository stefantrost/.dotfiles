require "ts.remap"
require "ts.set"
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "ts.plugins" }, {
  change_detection = {
    notify = false,
  },
})

require "ts.kickstart_configs"

vim.diagnostic.config {
  virtual_text = {
    source = true,
    format = function(diagnostic)
      return string.format("%s %s %s", diagnostic.user_data.code, diagnostic.message, diagnostic.source)
    end,
  },
  signs = true,
  float = {
    header = "Here's what's wrong",
    source = true,
    border = "rounded",
  },
}
