require("ts.remap")
require("ts.set")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "ts.plugins"}, {
  change_detection = {
    notify = false,
  },
})

require("ts.kickstart_configs")

require("ts.trouble")
require("ts.undotree")
require("ts.ng")
require("ts.nx")

