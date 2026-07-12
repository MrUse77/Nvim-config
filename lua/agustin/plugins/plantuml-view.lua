return {
  -- Sintaxis y detección de archivos PlantUML (.puml, .plantuml, .iuml, etc.)
  {
    'aklt/plantuml-syntax',
    ft = { 'plantuml', 'puml' },
  },

  -- Preview en navegador — funciona dentro de Zellij/tmux sin problema
  {
    'weirongxu/plantuml-previewer.vim',
    dependencies = { 'tyru/open-browser.vim' },
    cmd = { 'PlantumlOpen', 'PlantumlStart', 'PlantumlStop', 'PlantumlSave' },
    keys = {
      { '<leader>pv', '<cmd>PlantumlOpen<CR>',  desc = 'PlantUML: abrir preview en navegador' },
      { '<leader>ps', '<cmd>PlantumlSave<CR>',  desc = 'PlantUML: exportar diagrama (PNG)' },
    },
    config = function()
      -- Usa el binario plantuml del sistema por defecto.
      -- Si necesitás apuntar a un .jar manualmente, descomentá:
      -- vim.g['plantuml_previewer#plantuml_jar_path'] = vim.fn.expand('~/tools/plantuml/plantuml.jar')
    end,
  },
}
