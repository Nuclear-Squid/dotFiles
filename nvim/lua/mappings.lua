local map_fns = require 'mapping_functions'

local map  = map_fns.map
local nmap = map_fns.nmap
local imap = map_fns.imap
local vmap = map_fns.vmap

--  ────────────────────< Why aren’t those standard? >─────────────────
nmap 'Y' 'yg_'
nmap 'U' '<C-r>'
imap '<C-BS>' '<C-w>'

map { 'n', 'v' } { 'j', '<Down>', '+' } 'gj'
map { 'n', 'v' } { 'k', '<Up>',   '-' } 'gk'

-- vmap '<' '<gv'
-- vmap '>' '>gv'
-- vmap '<C-a>' '<C-a>gv'
-- vmap '<C-x>' '<C-x>gv'
-- vmap 'g<C-a>' 'g<C-a>gv'
-- vmap 'g<C-x>' 'g<C-x>gv'

vmap { '<', '>', '<c-a>', '<c-x>', 'g<c-a>', 'g<c-x>' } { after = 'gv' }

map { 'n', 'v', 'o' } ',' ';'
map { 'n', 'v', 'o' } ';' ','

nmap 'd}' 'V}kd'
nmap 'd{' 'V{jd'

--  ──────────────────────────────< Leader >───────────────────────────
vim.g.mapleader = ' '
vim.g.maplocalleader = '’'  -- typo -> espace en Ergo‑L

nmap '<leader>w' ':w<CR>'
nmap '<leader>q' ':q<CR>'
nmap '<leader>x' ':x<CR>'
-- make_awesome_mapping('<leader>d', map_fns.duplicate_and_comment)
nmap '<leader>d' (map_fns.make_text_object_cmd(map_fns.duplicate_and_comment))
vmap '<leader>d' (map_fns.make_visual_cmd(map_fns.duplicate_and_comment))
nmap '<leader>z' 'zMzvzczAzz'

--  ───────────────────────────< Miscellaneous >───────────────────────────
nmap '<Esc>' '<cmd>nohlsearch<CR>' -- Remove highlight
nmap 'vv' 'v$h'
map 't' '<Esc><Esc>' '<C-\\><C-n>' -- Exit term mode

-- Ergo‑L symbol layer aliases
imap '-+' '0'
imap '+-' '1'
imap '+/' '-1'

-- Code folding
nmap '<Tab>' 'za'
nmap '<S-Tab>' 'zA'

imap '{(' (map_fns.bracket_group('{', '}'))
imap '~[' (map_fns.bracket_group('[', ']'))

-- nmap 'é' (map_fns.make_text_object_cmd(map_fns.replace_on_range))

nmap 'µ' '`m'
nmap 'î' '`d'

-- -- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- setup Lazy (package manager)

