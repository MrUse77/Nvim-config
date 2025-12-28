---@diagnostic disable: missing-fields
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

local M = {}

function M.setup()
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-n>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.choice_active and luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-y>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "luasnip" },
      { name = "buffer" },
    }),
    window = {
      completion = cmp.config.window.bordered({
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        -- Esto ayuda a que la ventana se sienta más espaciosa
        col_offset = -3,
        side_padding = 0,
      }),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      format = function(entry, item)
        -- 1. Definimos los iconos manualmente (ya que no usamos el objeto LazyVim)
        local icons = {
          Text = "󰉿 ",
          Method = "󰆧 ",
          Function = "󰊕 ",
          Constructor = " ",
          Field = "󰜢 ",
          Variable = "󰀫 ",
          Class = "󰠱 ",
          Interface = " ",
          Module = " ",
          Property = "󰜢 ",
          Unit = "󰑭 ",
          Value = "󰎟 ",
          Enum = " ",
          Keyword = "󰌋 ",
          Snippet = " ",
          Color = "󰏘 ",
          File = "󰈙 ",
          Reference = "󰈇 ",
          Folder = "󰉋 ",
          EnumMember = " ",
          Constant = "󰏿 ",
          Struct = "󰙅 ",
          Event = " ",
          Operator = "󰆕 ",
          TypeParameter = " ",
        }

        -- 2. Añadir el icono al nombre del "Kind"
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end

        -- 3. Lógica dinámica para el origen (sustituye al [LSP] genérico)
        local content = entry.completion_item.detail
        if content and content:match("import") then
          item.menu = content:gsub("Auto import from ", "")
        else
          item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            buffer = "[Buf]",
            path = "[Path]",
          })[entry.source.name]
        end

        -- 4. Truncar el texto (La lógica de "widths" de LazyVim)
        local width = 500 -- Ancho máximo para el menú
        if item.menu and vim.fn.strdisplaywidth(item.menu) > width then
          item.menu = vim.fn.strcharpart(item.menu, 0, width - 1) .. "…"
        end

        return item
      end,
    },
  })
end

return M
