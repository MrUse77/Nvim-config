return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- 1. Setup Básico de dependencias
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "ts_ls"},
    })

    -- 2. Definición de Capabilities (común para todos)
		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Definimos la función de detección de raíz por fuera para que sea limpia
		local custom_root_dir = function(fname)
			-- Buscamos los archivos de CodeBlocks o el .clangd de la raíz
			return util.root_pattern('.clangd', 'workspace.cbp', 'Algoritmos.workspace', '.git')(fname)
				or util.path.dirname(fname) -- Si no hay nada, la carpeta del archivo
		end
    ----------------------------------------------------------------------
    -- CONFIGURACIÓN DE CLANGD (C++)
    ----------------------------------------------------------------------
    local clangd_opts = {
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-16" }, -- Fix crítico de encoding
      }),
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--completion-style=detailed",
        "--fallback-style=llvm",
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    }

    ----------------------------------------------------------------------
    -- CONFIGURACIÓN DE TYPESCRIPT (TS_LS)
    ----------------------------------------------------------------------
    local ts_opts = {
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
      },
    }


    ----------------------------------------------------------------------
    -- REGISTRO (API NEOVIM 0.11)
    ----------------------------------------------------------------------
    vim.lsp.config("clangd", clangd_opts)
    vim.lsp.config("ts_ls", ts_opts)


    vim.lsp.enable("clangd")
    vim.lsp.enable("ts_ls")
  end,
}
