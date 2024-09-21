require "nvchad.options"

local o = vim.o
local fn = vim.fn
local autocmd = vim.api.nvim_create_autocmd

o.cursorlineopt = "both" -- to enable cursorline!
o.cmdheight = 0

vim.filetype.add {
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
}

vim.api.nvim_create_augroup("bufcheck", { clear = true })
-- reload config file on change
autocmd("BufWritePost", {
  group = "bufcheck",
  pattern = vim.env.MYVIMRC,
  command = "silent source %",
})

-- autocmd("TextYankPost", {
--   group = "bufcheck",
--   pattern = "*",
--   callback = function()
--     fn.setreg("+", fn.getreg "*")
--   end,
-- })
