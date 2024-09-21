-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "catppuccin",
  ---@type HLTable
  hl_add = {
    NvimTreeOpenedFolderName = { fg = "green", bold = true },
  },
  ---@type Base46HLGroupsList
  hl_override = {
    ["@comment"] = { italic = true },
  },
  -- https://github.com/NvChad/base46/tree/v2.0/lua/base46/extended_integrations
  extended_integrations = { "notify", "alpha" }, -- these aren't compiled by default, ex: "alpha", "notify"

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "flat_light", -- default/flat_light/flat_dark/atom/atom_colored
    selected_item_bg = "simple", -- colored / simple
  },
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow (separators work only for "default" statusline theme;
    -- round and block will work for the minimal theme only)
    separator_style = "default",
    overriden_modules = nil,
  },
  tabufline = {
    lazyload = true,
    overriden_modules = nil,
  },
  mason = {cmd=false}
}

return M
