return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      -- Configuramos el comando específico de clang-format
      ["clang-format"] = {
        -- Argumento clave: -style=file:<ruta_absoluta>
        -- vim.fn.stdpath("config") devuelve ~/.config/nvim (o donde esté tu config)
        prepend_args = { "-style=file:" .. vim.fn.stdpath("config") .. "/.clang-format" },
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      c = { "clang-format" },
      java = { "clang-format" },
    },
  },
}
