vim.cmd("autocmd! BufWritePost mappings.lua source %")

----------------------
-- Sucre syntaxique --
----------------------
local map = vim.keymap.set

-- Un peu de cohérence dans un monde de brutes
map('n', 'Y', 'y$')
map('n', 'U', '<C-r>')

-- Fuck capslock
map('n', '<C-u>', 'gUiw')
map('i', '<C-u>', '<Left><C-o>gUiw<C-o>e<Right>')

-- Scroll
map({ 'n', 'v' }, '<C-j>', '25<C-e>')
map({ 'n', 'v' }, '<C-k>', '25<C-y>')
map('i', '<C-j>', '<C-o>25<C-e>')
map('i', '<C-k>', '<C-o>25<C-y>')

-- Garder la selection
map('v', '<', '<gv')
map('v', '>', '>gv')
map('v', '<C-a>', '<C-a>gv')
map('v', '<C-x>', '<C-x>gv')

-- Déplacements plus intuitif quand on utilise f ou t
map({ 'n', 'v', 'o' }, ',', ';', { noremap = true })
map({ 'n', 'v', 'o' }, ';', ',', { noremap = true })

-- Plus intuitif quand une ligne est cassée en deux
map({ 'n', 'v' }, 'j', 'gj', { noremap = true })
map({ 'n', 'v' }, 'k', 'gk', { noremap = true })

-- Fold mappings
map('n', 'z0', ':set fdl=0<CR>', { silent = true })
map('n', 'z1', ':set fdl=1<CR>', { silent = true })
map('n', 'z2', ':set fdl=2<CR>', { silent = true })
map('n', 'z3', ':set fdl=3<CR>', { silent = true })
map('n', 'z4', ':set fdl=4<CR>', { silent = true })
map('n', 'z5', ':set fdl=5<CR>', { silent = true })
map('n', 'z6', ':set fdl=6<CR>', { silent = true })
map('n', 'z7', ':set fdl=7<CR>', { silent = true })
map('n', 'z8', ':set fdl=8<CR>', { silent = true })
map('n', 'z9', ':set fdl=9<CR>', { silent = true })

-- Quand Ergo-L me casse les couilles
map('i', "fnt", "function")

-- Raccourcis avec leader
vim.g.mapleader = " "
map('n', '<leader>w', ':w<CR>')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>x', ':x<CR>')
map('n', '<leader>h', ':nohl<CR>')
map('n', '<leader> ', ':%s/ / /g<CR>``')  -- leader + shift + espace,
										  -- supprime tous les shift + espaces.
