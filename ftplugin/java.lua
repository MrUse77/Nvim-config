-- ftplugin/java.lua
local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end -- Evita errores si el plugin no cargó

-- A. Detección automática de rutas (Para que no falle al actualizar Mason)
local mason_registry = require("mason-registry")
local jdtls_pkg = mason_registry.get_package("jdtls")
local jdtls_path = jdtls_pkg:get_install_path()

local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config_path = jdtls_path .. "/config_linux" -- Linux explícito
local lombok_path = jdtls_path .. "/lombok.jar"

-- B. Workspace Dinámico: Una carpeta de datos por cada proyecto
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

-- C. Configuración del Servidor
local config = {
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
    "-javaagent:" .. lombok_path, -- CRÍTICO para Spring Boot
    "-jar",
    launcher_jar,
    "-configuration",
    config_path,
    "-data",
    workspace_dir,
  },
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml" }),

  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },

  on_attach = function(client, bufnr)
    -- Mapeos básicos para que K funcione
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Java Hover" })
    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buffer = bufnr, desc = "Organize Imports" })
    -- Habilitar Inlay Hints si usas Neovim 0.10+
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
}

-- D. Arrancar el servidor
jdtls.start_or_attach(config)
