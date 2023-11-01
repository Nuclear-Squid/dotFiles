vim.cmd("autocmd! BufWritePost suckless.lua source %")

vim.g.suckless_tmap = 1
require "mappings.suckless"

