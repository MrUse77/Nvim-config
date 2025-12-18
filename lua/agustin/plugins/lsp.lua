return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
  },
	config = function()
		local capabilities = {
			offsetEncoding = { "utf-8", "utf-16" },
			textDocument = {
				completion = {
					editsNearCursor = true,
				},
			},
		}
		local on_attach = function(_,bufnr)
			vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
			vim.keymap.set('n','K', vim.lsp.buf.hover,{buffer= bufnr})
		end

		local optsClangd = {
			capabilities = capabilities,
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
			},
			filetypes = { "c" },
			init_options = {
				usePlaceholders = true,
				completeUnimported = true,
				clangdFileStatus = true,
			},
			on_attach = on_attach,
		}
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local optsTS={      
			capabilities = capabilities,
			filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
			settings = {
				typescript = {
					inlayHints = { -- Nombre correcto (no "inlayNints")
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
					suggest = {
						includeCompletionsWithSnippetText = true,
						includeAutomaticOptionalChainCompletions = true,
					},
				},
				completions = {
					completeFunctionCalls = true,
				},
			},
        },

		vim.lsp.config("clangd", optsClangd)
		vim.lsp.config("ts_ls",optsTS)
	end,
	vim.lsp.enable("clangd"),
	vim.lsp.enable("ts_ls")
}
