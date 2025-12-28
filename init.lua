require("agustin.core.options")
require("agustin.core.keymaps")
require("agustin.core.autocmds")

-- Bootstrap de lazy.nvim (Instalación automática si no existe)
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
-- Cargar plugins
require("lazy").setup("agustin.plugins")
