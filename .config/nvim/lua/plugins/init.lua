require "configs.telescope"

---@type NvPluginSpec[]
return {
  { "nvim-treesitter/nvim-treesitter", opts = require "configs.treesitter" },
  { "nvim-tree/nvim-tree.lua", opts = require "configs.nvimtree" },
  { "echasnovski/mini.ai", version = "*" },
}
