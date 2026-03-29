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
-- Esto hace que la ventana de LazyGit use bordes redondeados si tu terminal lo soporta
vim.g.lazygit_floating_window_winblend = 0 -- Transparencia (0 a 100)
vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'}
vim.opt.rtp:prepend(lazypath)
-- Cargar plugins
require("lazy").setup("agustin.plugins")
