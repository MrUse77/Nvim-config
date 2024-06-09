-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options hereby

vim.opt.pumblend = 0

vim.opt.background = "dark"
vim.opt.relativenumber = false -- Wrap lines at convenient points
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.softtabstop = 2
vim.cmd([[
  highlight NormalFloat guibg=#1e222a
  highlight FloatBorder guifg=white guibg=#1e222a
]])
