return {
	"nvim-telescope/telescope.nvim",
	event="VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = 'make',
		},
	},
	opts = {
		defaults = {
			layout_strategy = "horizontal",
			layout_config = { prompt_position = "top" },
			sorting_strategy = "ascending",
			winblend = 0,
		},
		extensions = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	},
	config = function(opts)
		require('telescope').setup(opts)
		require('telescope').load_extension('fzf')
	end,
	keys = {
		-- add a keymap to browse plugin files
		-- stylua: ignore
		{
			"<leader>fp",
			function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
			desc = "Find Plugin File",
		},
		{
			"<leader>pp",
			function()
				require('telescope.builtin').git_files({ show_untracked = true })
			end,
			desc = "Telescope Git Files",
		},
		{
			"<leader>pe",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Telescope buffers",
		},
		{
			"<leader>gs",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "Telescope Git status",
		},
		{
			"<leader>gc",
			function()
				require("telescope.builtin").git_bcommits()
			end,
			desc = "Telescope Git status",
		},
		{
			"<leader>gb",
			function()
				require("telescope.builtin").git_branches()
			end,
			desc = "Telescope Git branches",
		},
		{
			"<leader>rp",
			function()
				require("telescope.builtin").find_files({
					prompt_title = "Plugins",
					cwd = vim.fn.stdpath("config") .. "/lua/agustin/plugins",
					attach_mappings = function(_, map)
						local actions = require("telescope.actions")
						local action_state = require("telescope.actions.state")
						map("i", "<c-y>", function(prompt_bufnr)
							local new_plugin = action_state.get_current_line()
							actions.close(prompt_bufnr)
							vim.cmd(string.format("edit ~/.config/nvim/lua/agustin/plugins/%s.lua", new_plugin))
						end)
						return true
					end
				})
			end
		},
		{
			"<leader>pf",
			function()
				require('telescope.builtin').find_files()
			end,
			desc = "Telescope Find Files",
		},
		{
			"<leader>ph",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Telescope Help"
		},
		{
			"<leader>bb",
			function()
				require("telescope").extensions.file_browser.file_browser({ path = "%:h:p", select_buffer = true })
			end,
			desc = "Telescope file browser"
		}
	},
}
