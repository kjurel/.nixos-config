---@type NvPluginSpec[]
return {
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  {
    "xvzc/chezmoi.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("chezmoi").setup { edit = { watch = true } }
      local telescope = require "telescope"
      telescope.load_extension "chezmoi"
      vim.keymap.set("n", "<leader>cz", telescope.extensions.chezmoi.find_files, {})
      -- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      --   pattern = { os.getenv "HOME" .. "/.local/share/chezmoi/*" },
      --   callback = function()
      --     vim.schedule(require("chezmoi.commands.__edit").watch)
      --   end,
      -- })
    end,
  },
}
