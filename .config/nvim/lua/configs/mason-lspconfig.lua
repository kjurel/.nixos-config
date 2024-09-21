local lspconfig = require "lspconfig"

local config = require "nvchad.configs.lspconfig"

local on_attach = function(client, bufnr)
  config.on_attach(client, bufnr)
end
local capabilities = config.capabilities

return { -- uses lspconfig server names
  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
  --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  ---@type boolean
  automatic_installation = true,

  -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
  -- This setting has no relation with the `automatic_installation` setting.
  ---@type string[]
  ensure_installed = {
    "lua_ls",
    -- bash
    "bashls",
    -- config
    "jsonls",
    "yamlls",
    "taplo",
    -- webdev
    "html",
    "cssls",
    "ts_ls",
    -- python
    "pyright",
    "ruff_lsp",
    -- rust
    "rust_analyzer",
  },

  -- See `:h mason-lspconfig.setup_handlers()`
  ---@type table<string, fun(server_name: string)>?
  handlers = {
    function(server_name)
      if server_name ~= "lua_ls" then
        lspconfig[server_name].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end
    end,
    ["jsonls"] = function(server_name)
      lspconfig[server_name].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
    ["yamlls"] = function(server_name)
      lspconfig[server_name].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      }
    end,
    ["ts_ls"] = function(server_name)
      lspconfig[server_name].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
          preferences = {
            disableSuggestions = true,
          },
        },
        commands = {
          OrganizeImports = {
            function()
              local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
              }
              vim.lsp.buf.execute_command(params)
            end,
            description = "Organize Imports",
          },
        },
      }
    end,
    ["ruff_lsp"] = function()
      lspconfig.ruff_lsp.setup {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          client.server_capabilities.hoverProvider = false
        end,
        capabilities = capabilities,
        filetypes = { "python" },
      }
    end,
    ["rust_analyzer"] = function()
      lspconfig.rust_analyzer.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            diagnostics = { enable = true },
            cargo = { features = "all" },
            completion = { privateEditable = { enable = true } },
            check = { command = "clippy" },
          },
        },
      }
    end,
  },
}
