vim.cmd("autocmd! BufWritePost termopen.lua source %")

local map = vim.keymap.set

map('n', '<M-Return>', ':call TermOpen("zsh", "f")<CR>')
