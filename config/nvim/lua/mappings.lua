-- vim: set fdm=marker fmr=<<{,}>> fdl=0 ft=lua:
vim.cmd("autocmd! BufWritePost mappings.lua source %")

----------------------
-- Sucre syntaxique --
----------------------
--<<{
function map(scope)
	return function(pattern, command, options)
		local final_options = vim.tbl_extend("keep", options or {}, { noremap = true })
		vim.keymap.set(scope, pattern, command, final_options)
	end
end
--}>>

----------------------
-- General Mappings --
----------------------
--<<{
-- Un peu de cohérence dans un monde de brutes
map 'n' ('Y', 'y$')
map 'n' ('U', '<C-r>')
map 'i' ('<C-BS>', '<C-w>')

-- Déplacements plus intuitif quand on utilise f ou t
map { 'n', 'v', 'o' } (',', ';')
map { 'n', 'v', 'o' } (';', ',')

-- Plus intuitif quand une ligne est cassée en deux
map { 'n', 'v' } ('j', 'gj')
map { 'n', 'v' } ('k', 'gk')
map { 'n', 'v' } ('<Down>', 'gj')
map { 'n', 'v' } ('<Up>', 'gk')

-- Garder la selection
map 'v' ('<'     ,      '<gv')
map 'v' ('>'     ,      '>gv')
map 'v' ('<C-a>' ,  '<C-a>gv')
map 'v' ('<C-x>' ,  '<C-x>gv')
map 'v' ('g<C-a>', 'g<C-a>gv')
map 'v' ('g<C-x>', 'g<C-x>gv')

-- Fuck capslock
map 'n' ('<C-u>', 'gUiw')
map 'i' ('<C-u>', '<Left><C-o>gUiw<C-o>e<Right>')
--}>>


-------------
-- Aliases --
-------------
--<<{
-- Quand Ergo-L me casse les couilles
map 'i' ('fnt', 'function')

-- Insérer un bloc d’accolades
-- map 'i' ('{(', '{<CR>.<CR><BS><BS>}<UP><RIGHT><RIGHT><RIGHT><RIGHT><BS>')
map 'i' ('{(', '{<CR><BS>}<UP><END><CR>')

map 'i' ('<C-CR>', '<UP><END><CR>')
map 'i' ('[[', '[0]')
--}>>

------------
-- Leader --
------------
--<<{
vim.g.mapleader = " "
map 'n' ('<leader>w', ':w<CR>')
map 'n' ('<leader>q', ':q<CR>')
map 'n' ('<leader>x', ':x<CR>')
map 'n' ('<leader>h', ':nohl<CR>', { silent = true })
map 'n' ('<leader> ', ':%s/ / /g<CR>``')  -- leader -> shift + espace, supprime tous les shift + espaces.
--}>>

------------
-- Editor --
------------
--<<{
map 'n' ('<M-Return>', ':call TermOpen("zsh", "f")<CR>')
map 'n' ('<M-Backspace>', ':call TermOpenRanger()<CR>')

-- Fold mappings
map 'n' ('z0', ':set fdl=0<CR>', { silent = true })
map 'n' ('z1', ':set fdl=1<CR>', { silent = true })
map 'n' ('z2', ':set fdl=2<CR>', { silent = true })
map 'n' ('z3', ':set fdl=3<CR>', { silent = true })
map 'n' ('z4', ':set fdl=4<CR>', { silent = true })
map 'n' ('z5', ':set fdl=5<CR>', { silent = true })
map 'n' ('z6', ':set fdl=6<CR>', { silent = true })
map 'n' ('z7', ':set fdl=7<CR>', { silent = true })
map 'n' ('z8', ':set fdl=8<CR>', { silent = true })
map 'n' ('z9', ':set fdl=9<CR>', { silent = true })

local telescope = require('telescope.builtin')
map 'n' ('<leader>f', telescope.find_files)
map 'n' ('<leader>g', telescope.git_files)
map 'n' ('<leader>G', telescope.live_grep)
map 'n' ('<leader>H', telescope.help_tags)
map 'n' ('<leader>b', telescope.buffers)
map 'n' ('<leader>m', telescope.keymaps)

-- LSP buffer-specific options and keymaps --
local set_lsp_keymaps = function(_client, bufnr)
	local telescope = require('telescope.builtin')
	local opts = { buffer=bufnr, noremap=true, silent=true }
	map  'n'       ('K',        vim.lsp.buf.hover,          opts)
	map  'n'       ('<C-k>',    vim.lsp.buf.signature_help, opts)
	map  'n'       ('gA',       vim.lsp.buf.code_action,    opts) -- {apply=true}
	map  'n'       ('gR',       vim.lsp.buf.rename,         opts)
	map {'n', 'v'} ('g=',       vim.lsp.buf.format,         opts)
	map  'n'       ('gi',       vim.lsp.buf.implementation, opts)
	map  'n'       ('[<Enter>', vim.diagnostic.goto_prev,   opts)
	map  'n'       (']<Enter>', vim.diagnostic.goto_next,   opts)
	-- SP referenceLs, definitions and diagnostics are handled by Telescope
	map  'n'       ('gr',       telescope.lsp_references,   opts)
	map  'n'       ('gd',       telescope.lsp_definitions,  opts)
	map  'n'       ('gD',       telescope.diagnostics,      opts)
	-- source/header switch (should be restricted to clangd)
	map  'n'       ('gh', ':ClangdSwitchSourceHeader<CR>',  opts)
	-- enable completion triggered by <c-x><c-o> (and nvim-cmp)
	vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end
--}>>

-- Table of functions used to set mappings in other modules
return {
	set_lsp_keymaps = set_lsp_keymaps,
}
