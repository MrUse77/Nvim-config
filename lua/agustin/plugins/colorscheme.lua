return {
  "folke/tokyonight.nvim",
  name = "tokyo",
  priority = 1000,
  opts = {
    style = "night", -- night | storm | moon | day
    transparent = true, -- sin fondo
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      sidebars = "transparent", -- o "dark"
      floats = "transparent",
    },
    sidebars = { "qf", "help", "terminal", "neo-tree" },
    dim_inactive = false,
    lualine_bold = true,
    on_colors = function(colors)
      colors.border = colors.cyan -- ejemplo: borde cian
      colors.bg = "#0f111a" -- fondo base si no usas transparency
    end,
    on_highlights = function(hl, c)
      hl.LineNr = { fg = c.blue, bg = "none" }
      hl.FloatBorder = { fg = c.cyan, bg = "none" }
    end,
  },
  config = function()
    require("tokyonight").setup(require("lazy.core.config").plugins["tokyo"].opts or {})
    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
