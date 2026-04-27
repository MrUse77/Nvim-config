-- Arbol de Sintaxis
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Comando post-instalación para compilar los parsers
  branch = "master",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects" },
  },
  event = "VeryLazy",
  lazy = false, -- Carga inmediata para disponer de comandos TS
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "lua",
      "luadoc",
      "c",
      "javascript",
      "typescript",
      "sql",
      "java",
    },
    highlight = {
      additional_vim_regex_highlighting = { "org" },
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "c", "javascript", "typescript" },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
        },
      },
    },
  },
}
