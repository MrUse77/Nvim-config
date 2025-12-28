local opt = vim.opt

-- Líneas
opt.relativenumber = true -- Números relativos (vital para movimientos rápidos)
opt.number = true -- Muestra el número de línea actual

-- Comportamiento general
opt.wrap = false -- No ajustar líneas largas automáticamente
opt.ignorecase = true -- Ignorar mayúsculas al buscar...
opt.smartcase = true -- ...a menos que escribas una mayúscula
opt.cursorline = true -- Resalta la línea actual
opt.termguicolors = true -- Colores reales
opt.scrolloff = 8 -- Mantener 8 líneas de margen al hacer scroll
opt.clipboard = "unnamedplus" -- Usar el portapapeles del sistema (Arch)

vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●" }, -- texto en la línea
  signs = true, -- iconos en el gutter
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Configuración global de pliegues
vim.opt.foldmethod = "expr" -- Usa una expresión para definir pliegues
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Usa Treesitter como motor
vim.opt.foldlevel = 99 -- Que los archivos se abran expandidos
vim.opt.foldcolumn = "1" -- Opcional: muestra una columna a la izquierda con los pliegues
