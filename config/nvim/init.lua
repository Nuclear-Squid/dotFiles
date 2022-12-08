--   __________________________________________
--  /\                                         \
--  \_| La meilleure config neovim de tous les |
--    |  temps (parce que c'est la mienne et   |
--    |  que je suis parfaitement objectif).   |
--    |   _____________________________________|_
--     \_/_______________________________________/
-- 

----------------------
-- Sucre syntaxique --
----------------------
local set = vim.opt
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

------------------
-- Autocommands --
------------------
autocmd("InsertLeave", { pattern = "*", command = "write" })
vim.cmd [[
	autocmd! BufWritePost init.lua source %
	source ~/.config/nvim/plugins.vim " Ancienne config
	source ~/.config/nvim/md_to_pdf.lua " md <3 <3 <3
]]

--------------------------------------------
-- Compléter avec <Tab> en mode commande --
--------------------------------------------
set.wildmenu = true
set.wildmode = 'longest,full'

-----------------------------
-- Recherche incrémentale --
-----------------------------
set.hlsearch = true         -- Surligne les patterns trouvés pendant les recherches
set.ignorecase = true		-- Les recherches ne sont de base pas case sensitives
set.smartcase = true		-- Recherches case sensitives si il y a une maj dans le pattern
set.incsearch = true		-- Sauter au match suivant / précédant avec n / N
set.inccommand = 'split'    -- Affiche le résultat de :s en temps réel

---------------------
-- aides visuelles --
---------------------
set.scrolloff = 5          -- Garder au moins 5 lignes au dessus / dessous le curseur
set.number = true          -- Afficher les numéros de lignes à gauche
-- set.relativenumber = true  -- Numéros de ligne relatif à la position du curseur
set.ruler = true           -- Affiche la position du curseur en bas du buffer
set.showcmd	= true	       -- Montre la commande dans la ligne de statuts
set.showmatch = true       -- Surligne la parenthèse associée a celle survolée
set.linebreak = true       -- Pas couper les mots en cas de retrour à la ligne

--------------------------
-- Options pour du joli --
--------------------------
-- set.t_Co = 256  -- what
set.termguicolors = true  -- 24bit colors babyyyyyyy !!
set.winblend = 20         -- Semi-transparence pour les fenêtres flotates
set.background = 'dark'   -- L'ilusion du choix

-- thème de couleur
vim.cmd [[
	" colorscheme photon
	" colorscheme tokyonight-storm
	colorscheme gruvbox
	" colorscheme onedark
	" colorscheme kalahari
	" colorscheme desert
]]
-- FLASHBANG !!!!
map('n', '<F12>', ":let &bg = (&bg == 'light' ? 'dark' : 'light')<CR>")
set.splitbelow = true  -- Mettre la nouvelle fenêtre en bas quand split vertical
set.splitright = true  -- Mettre la nouvelle fenêtre à droite quand split horizontal

--------------------
-- config Neovide --
--------------------
--
if (vim.g.neovide) then
	vim.g.font_size = 10
	vim.o.guifont='FantasqueSansMono Nerd Font Mono:h'..vim.g.font_size
	-- https://github.com/neovide/neovide/wiki/Configuration
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_scroll_animation_length = 0.3
	vim.g.neovide_cursor_animation_length = 0.075
	vim.g.neovide_cursor_vfx_mode = 'ripple'

	-- Changer la taille de police à la volée (Mud <3 <3 <3)
	-- https://stackoverflow.com/questions/73572079/neovim-lua-how-to-use-mutable-variables-in-keymappings/73574837#73574837
	map('n', '<C-->', ":let g:font_size = (g:font_size - 1)<CR>:let &guifont = 'FantasqueSansMono Nerd Font Mono:h'.g:font_size<CR>", { silent = true })
	map('n', '<C-+>', ":let g:font_size = (g:font_size + 1)<CR>:let &guifont = 'FantasqueSansMono Nerd Font Mono:h'.g:font_size<CR>", { silent = true })

	-- Passer vite entre la taille de police pour écran 12 et 24 pouces
	vim.keymap.set('n', '<F11>', ":let &guifont = (&guifont == 'FantasqueSansMono Nerd Font Mono:h8' ? 'FantasqueSansMono Nerd Font Mono:h10' : 'FantasqueSansMono Nerd Font Mono:h8')<CR>", { silent = true })
end

------------------
-- Code folding --
------------------
set.foldmethod = 'indent'  -- Genère les folds à partir de l'indentation
set.smartindent = true     -- Auto-indentation quand on retourne à la ligne
set.shiftwidth = 4         -- ???
set.softtabstop = 4        -- Nombre d'espaces quand on fait tab
set.tabstop = 4            -- Nombre d'espaces, mais pas pareil ??
map('n', '<Tab>', 'za')
map('n', '<S-Tab>', 'zA')
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

------------------------------------------
-- Options honteuses (pour les faibles) --
------------------------------------------
set.clipboard = 'unnamedplus'  -- Registre par defaut : '+'
set.mouse = 'a'         -- Active la sourie (surtout pour le scroll)
-- set.mouse = ''          -- Fuck la sourie
set.mousehide = true    -- Cache la sourie quand on tape (marche pas avec neovide)
set.autowrite = true    -- Auto-save avant certaines cmd comme :next / :make
vim.cmd [[
	set rtp^="/home/leo/.opam/default/share/ocp-indent/vim"
]] -- OCaml setup thing, idk

----------------------------
-- Mappings en tout genre --
----------------------------
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

-----------------------
-- Config TreeSitter --
-----------------------

require('nvim-treesitter.configs').setup {
	parser_install_dir = "~/Code/dotFiles/config/nvim/plugged/nvim-treesitter",
	ensure_installed = { "ocaml" },
	
	highlight = {
		enable = true,
	},
}
vim.opt.runtimepath:append( "~/Code/dotFiles/config/nvim/plugged/nvim-treesitter")

require('nvim-cursorline').setup {
  cursorline = {
    enable = false,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}

-------------------
-- Config Packer --
-------------------
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'  -- Packer can manage itself.
	use 'neovim/nvim-lspconfig'   -- Language Server Protocol

    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'kyazdani42/nvim-web-devicons' },
        { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
      }
    }
    require('telescope').setup { defaults = { winblend = 20 } }
    -- (note: LSP-specific mappings are defined later)
    local telescope = require('telescope.builtin')
    map('n', '<leader>f', telescope.find_files)
    map('n', '<leader>g', telescope.git_files)
    map('n', '<leader>G', telescope.live_grep)
    map('n', '<leader>H', telescope.help_tags)
    map('n', '<leader>b', telescope.buffers)
    map('n', '<leader>m', telescope.keymaps)

	-- LSP/DAP package manager
	use 'williamboman/mason.nvim'
	require('mason').setup()

    -- Auto-Completion 
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    -- For vsnip users.
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
end)

--
-- auto-completion (nvim-cmp)
--
local cmp = require('cmp')
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
cmp.setup({
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
		{ name = 'buffer' },
	}),
	snippet = {
		expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends an already mapped key (probably `<Tab>` here).
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
		--   ['<C-f>']     = cmp.mapping(cmp.mapping.scroll_docs(4),  { 'i', 'c' }),
		--   ['<C-b>']     = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		--   ['<C-f>']     = cmp.mapping(cmp.mapping.scroll_docs(4),  { 'i', 'c' }),
		--   ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(),      { 'i', 'c' }),
		--   ['<C-y>']     = cmp.config.disable, --  remove the default `<C-y>` mapping
		--   ['<C-e>']     = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
		--   ['<CR>']      = cmp.mapping.confirm({ select = true }),
	},
})

--
-- LSP buffer-specific options and keymaps
--
local set_lsp_keymaps = function(client, bufnr)
	local opts = { buffer=bufnr, noremap=true, silent=true }
	local telescope = require('telescope.builtin')
	-- mappings
	map( 'n',       'K',        vim.lsp.buf.hover,          opts)
	map( 'n',       '<C-k>',    vim.lsp.buf.signature_help, opts)
	map( 'n',       'gA',       vim.lsp.buf.code_action,    opts) -- {apply=true}
	map( 'n',       'gR',       vim.lsp.buf.rename,         opts)
	map({'n', 'v'}, 'g=',       vim.lsp.buf.format,         opts)
	map( 'n',       'gi',       vim.lsp.buf.implementation, opts)
	map( 'n',       '[<Enter>', vim.diagnostic.goto_prev,   opts)
	map( 'n',       ']<Enter>', vim.diagnostic.goto_next,   opts)
	-- LSP references, definitions and diagnostics are handled by Telescope
	map( 'n',       'gr',       telescope.lsp_references,   opts)
	map( 'n',       'gd',       telescope.lsp_definitions,  opts)
	map( 'n',       'gD',       telescope.diagnostics,      opts)
	-- source/header switch (should be restricted to clangd)
	map('n', 'gh', ':ClangdSwitchSourceHeader<CR>', opts)
	-- enable completion triggered by <c-x><c-o> (and nvim-cmp)
	vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

--
-- LSP activation: call 'setup' on multiple servers
-- and add local keybindings and snippet capabilities when the language server attaches
--
local lsp_servers = { 'clangd', 'pylsp' } -- see also: null-ls
local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in ipairs(lsp_servers) do
	nvim_lsp[lsp].setup({
		on_attach = set_lsp_keymaps,
		flags = {
			debounce_text_changes = 150,
		},
		capabilities = capabilities,
	})
end
