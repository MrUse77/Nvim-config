-- lua/agustin/plugins/mason.lua
-- Gestor de paquetes LSP/DAP/linters/formatters.

return {
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSPs
          "clangd",
          "ts_ls",
          "jdtls",
          -- DAP Java
          "java-debug-adapter",
          "java-test",
          -- Formatter Java
          "google-java-format",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      })
    end,
  },
}
