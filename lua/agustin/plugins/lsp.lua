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
      ensure_installed = { "clangd", "ts_ls", "jdtls" },
    })

    -- 2. Definición de Capabilities (común para todos)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    ----------------------------------------------------------------------
    -- CONFIGURACIÓN DE CLANGD (C++)
    ----------------------------------------------------------------------
    local clangd_opts = {
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-8" }, -- Fix crítico de encoding
      }),
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
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
    -- CONFIGURACIÓN DE JAVA (JDTLS) - La parte difícil
    ----------------------------------------------------------------------
    local function get_jdtls_config()
      -- 1. Calculamos la ruta "a la fuerza" (Hardcoded estándar de Mason)
      -- Esto evita el error de "get_install_path nil"
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local jdtls_path = mason_path .. "/packages/jdtls"

      -- 2. Verificamos si existe el launcher para saber si está instalado
      -- Si no encontramos el jar, asumimos que no está instalado y devolvemos nil
      local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      if launcher_jar == "" then
        return nil
      end

      -- 3. Definimos rutas relativas al path base
      local config_path = jdtls_path .. "/config_linux"
      local lombok_path = jdtls_path .. "/lombok.jar"

      -- 4. Workspace dinámico
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

      return {
        capabilities = capabilities,
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-javaagent:" .. lombok_path,
          "-jar",
          launcher_jar,
          "-configuration",
          config_path,
          "-data",
          workspace_dir,
        },
        root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml" }),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
          },
        },
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>jo", function()
            -- Intentamos usar el comando del plugin si está cargado, o fallback
            local ok, jdtls = pcall(require, "jdtls")
            if ok then
              jdtls.organize_imports()
            end
          end, { buffer = bufnr, desc = "Organize Imports" })
        end,
      }
    end

    ----------------------------------------------------------------------
    -- REGISTRO (API NEOVIM 0.11)
    ----------------------------------------------------------------------
    vim.lsp.config("clangd", clangd_opts)
    vim.lsp.config("ts_ls", ts_opts)

    -- Configuración condicional de Java
    local java_conf = get_jdtls_config()
    if java_conf then
      vim.lsp.config("jdtls", java_conf)
      vim.lsp.enable("jdtls") -- Solo habilitamos si existe configuración
    end

    vim.lsp.enable("clangd")
    vim.lsp.enable("ts_ls")
  end,
}
