return {
    "folke/tokyonight.nvim",
    priority = 1000, -- Cargar antes que nada para no ver destellos feos
    config = function()
        vim.cmd([[colorscheme tokyonight-night]])
    end,
}
