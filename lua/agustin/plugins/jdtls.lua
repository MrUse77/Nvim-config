-- lua/agustin/plugins/jdtls.lua
-- Configuración de nvim-jdtls para desarrollo Java / Spring Boot.
-- Este plugin gestiona el LSP de Java de forma independiente a nvim-lspconfig.

return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "williamboman/mason.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local jdtls = require("jdtls")
    local setup = require("jdtls.setup")
    local mason_registry = require("mason-registry")

    -- Marcadores de raíz del proyecto Java.
    local root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "mvnw", "gradlew", ".git" }

    -- Resuelve la ruta de instalación de un paquete Mason de forma defensiva.
    local function mason_pkg_path(name, subpath)
      local ok, pkg = pcall(mason_registry.get_package, name)
      if not ok or not pkg:is_installed() then
        return nil
      end
      return pkg:get_install_path() .. (subpath or "")
    end

    -- Construye la configuración de nvim-jdtls para el buffer actual.
    local function make_config()
      local root_dir = setup.find_root(root_markers) or vim.fn.getcwd()
      local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

      local jdtls_path = mason_pkg_path("jdtls")
      if not jdtls_path then
        vim.notify("[jdtls] jdtls no está instalado. Ejecuta :MasonInstall jdtls", vim.log.levels.WARN)
        return nil
      end

      -- Determina el launcher jar de Eclipse JDTLS.
      local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
      if launcher_jar == "" then
        vim.notify("[jdtls] No se encontró el launcher jar de jdtls", vim.log.levels.ERROR)
        return nil
      end

      -- Selecciona el directorio de configuración de la plataforma.
      local platform_config
      if vim.fn.has("mac") == 1 then
        platform_config = "config_mac"
      elseif vim.fn.has("unix") == 1 then
        platform_config = "config_linux"
      else
        platform_config = "config_win"
      end

      local cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher_jar,
        "-configuration", jdtls_path .. "/" .. platform_config,
        "-data", workspace_dir,
      }

      -- Recolecta los bundles de debug y test si están instalados.
      local bundles = {}

      local debug_path = mason_pkg_path("java-debug-adapter", "/extension/server")
      if debug_path then
        local debug_jar = vim.fn.glob(debug_path .. "/com.microsoft.java.debug.plugin-*.jar", true)
        if debug_jar ~= "" then
          table.insert(bundles, debug_jar)
        end
      end

      local test_path = mason_pkg_path("java-test", "/extension/server")
      if test_path then
        local test_jars = vim.fn.glob(test_path .. "/*.jar", true, true)
        for _, jar in ipairs(test_jars) do
          table.insert(bundles, jar)
        end
      end

      -- Capabilities extendidas recomendadas por nvim-jdtls.
      local extendedClientCapabilities = vim.deepcopy(jdtls.extendedClientCapabilities)
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

      return {
        cmd = cmd,
        root_dir = root_dir,
        settings = {
          java = {
            configuration = {
              updateBuildConfiguration = "interactive",
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            inlayHints = {
              parameterNames = {
                enabled = "all",
              },
            },
            format = {
              enabled = true,
            },
            signatureHelp = {
              enabled = true,
              description = {
                enabled = true,
              },
            },
            completion = {
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
              },
              filteredTypes = {
                "com.sun.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
                "jdk.*",
                "sun.*",
              },
              importOrder = {
                "java",
                "javax",
                "com",
                "org",
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}",
              },
              hashCodeEquals = {
                useJava7Objects = true,
              },
              useBlocks = true,
            },
          },
        },
        init_options = {
          bundles = bundles,
          extendedClientCapabilities = extendedClientCapabilities,
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        flags = {
          allow_incremental_sync = true,
        },
        on_attach = function(_, bufnr)
          -- Habilita el adaptador DAP de Java y los comandos extra de jdtls.
          jdtls.setup_dap({ hotcodereplace = "auto" })
          jdtls.setup.add_commands()

          -- Atajos útiles específicos de Java.
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>co", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Organize Imports" }))
          vim.keymap.set("n", "<leader>cv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Extract Variable" }))
          vim.keymap.set("n", "<leader>cc", jdtls.extract_constant, vim.tbl_extend("force", opts, { desc = "Extract Constant" }))
          vim.keymap.set("v", "<leader>cm", function()
            jdtls.extract_method(true)
          end, vim.tbl_extend("force", opts, { desc = "Extract Method" }))
        end,
      }
    end

    local group = vim.api.nvim_create_augroup("AgustinJdtls", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "java",
      callback = function()
        local config = make_config()
        if config then
          jdtls.start_or_attach(config)
        end
      end,
    })

    -- Si ya hay un buffer Java abierto al cargar el plugin, adjúntalo ahora.
    if vim.bo.filetype == "java" then
      local config = make_config()
      if config then
        jdtls.start_or_attach(config)
      end
    end
  end,
}
