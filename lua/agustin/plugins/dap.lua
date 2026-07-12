-- lua/agustin/plugins/dap.lua
-- Soporte de Debug Adapter Protocol (DAP) para Neovim.
-- El adaptador específico de Java se configura desde nvim-jdtls.

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false,
      })

      -- Abre/cierra dapui automáticamente al iniciar/detener sesiones.
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      local keymap = vim.keymap.set
      local opts = { silent = true }

      keymap("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle Breakpoint" }))
      keymap("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, vim.tbl_extend("force", opts, { desc = "Toggle Conditional Breakpoint" }))
      keymap("n", "<leader>dc", dap.continue, vim.tbl_extend("force", opts, { desc = "Continue" }))
      keymap("n", "<leader>dC", dap.run_to_cursor, vim.tbl_extend("force", opts, { desc = "Run to Cursor" }))
      keymap("n", "<leader>di", dap.step_into, vim.tbl_extend("force", opts, { desc = "Step Into" }))
      keymap("n", "<leader>do", dap.step_over, vim.tbl_extend("force", opts, { desc = "Step Over" }))
      keymap("n", "<leader>dO", dap.step_out, vim.tbl_extend("force", opts, { desc = "Step Out" }))
      keymap("n", "<leader>dr", dap.repl.open, vim.tbl_extend("force", opts, { desc = "Open REPL" }))
      keymap("n", "<leader>dl", dap.run_last, vim.tbl_extend("force", opts, { desc = "Run Last" }))
      keymap("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", opts, { desc = "Toggle DAP UI" }))
      keymap("n", "<leader>dt", dap.terminate, vim.tbl_extend("force", opts, { desc = "Terminate" }))
      keymap("n", "<leader>dP", dap.pause, vim.tbl_extend("force", opts, { desc = "Pause" }))
    end,
  },
}
