vim.cmd("autocmd! BufWritePost telescope.lua source %")

local map = vim.keymap.set

require('telescope').setup { defaults = { winblend = 20 } }

local telescope = require('telescope.builtin')
map('n', '<leader>f', telescope.find_files)
map('n', '<leader>g', telescope.git_files)
map('n', '<leader>G', telescope.live_grep)
map('n', '<leader>H', telescope.help_tags)
map('n', '<leader>b', telescope.buffers)
map('n', '<leader>m', telescope.keymaps)
