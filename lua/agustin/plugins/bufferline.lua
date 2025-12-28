return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<Cr>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<Cr>", desc = "Delete Non-Pinned Buffers" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },
  opts = {
    options = {
      mode = "buffers", -- Aquí le decimos que muestre buffers, no tabs reales
      separator_style = "thin", -- Estética de las pestañas
      show_buffer_close_icons = true,
      show_close_icon = true,
    },
    highlights = {
      fill = {
        bg = "NONE",
      },
      separator = {
        fg = "NONE", -- Esto quita el borde de color
        bg = "NONE", -- Esto quita el fondo blanco que te molesta
      },
      separator_selected = {
        bg = "NONE",
      },
      separator_visible = {
        bg = "NONE",
      },
    },
  },
}
