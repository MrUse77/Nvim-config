vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- 1. Verificar si el primer argumento es un directorio
    local stats = vim.uv.fs_stat(vim.fn.argv(0))
    if stats and stats.type == "directory" then
      -- 2. Abrir Neo-tree
      Snacks.explorer({ path = vim.fn.argv(0) })
    end
  end,
})
