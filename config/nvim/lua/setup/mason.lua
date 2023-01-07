vim.cmd("autocmd! BufWritePost mason.lua source %")

require('mason').setup()
