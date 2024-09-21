---@type NvPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "b0o/schemastore.nvim",
    },
    opts = require "configs.mason-lspconfig",
  },
  {
    "zapling/mason-conform.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
    opts = require "configs.mason-formatting",
    config = function(_, opts)
      require("conform").setup(opts)
      require("mason-conform").setup {}
    end,
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = require "configs.mason-linting",
    config = function(_, opts)
      require("lint").linters_by_ft = opts
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = lint_augroup,
        callback = function()
          require("lint").try_lint()
        end,
      })
      require("mason-nvim-lint").setup()
    end,
  },
}
