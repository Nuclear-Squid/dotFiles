-- vim: set fdm=marker fmr=<<{,}>> fdl=0 ft=lua:

----------------------
-- Sucre syntaxique --
----------------------
local set = vim.opt
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

vim.cmd("autocmd! BufWritePost plugins.lua source %")

-------------------
-- Config Packer --
-------------------
--<<{
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'  -- Packer can manage itself.
	
	---------
	-- LSP --
	--------- 
	--<<{
	use 'w0rp/ale'  -- linter, not lsp but kinda related

	use 'neovim/nvim-lspconfig'   -- Language Server Protocol
	use 'williamboman/mason.nvim' -- LSP/DAP package manager
	require("setup.mason")

    -- Auto-Completion 
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    -- For vsnip users.
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
	--}>>

	---------------
	-- Telescope --
	---------------
	--<<{
	use { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
		requires = {
			'nvim-lua/plenary.nvim',
			'kyazdani42/nvim-web-devicons',
			{ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
		}
	}
	require("setup.telescope")
	--}>>

	----------------
	-- TreeSitter --
	----------------
	--<<{
	use 'nvim-treesitter/nvim-treesitter'
	use { 'nvim-treesitter/nvim-treesitter-context',
		requires = 'nvim-treesitter/nvim-treesitter',
	}
	use { 'nvim-treesitter/playground',
		requires = 'nvim-treesitter/nvim-treesitter',
	}
	require("setup.treesitter")
	--}>>

	--------------------
	-- Tiling Manager --
	--------------------
	--<<{
	use 'fabi1cazenave/termopen.vim'
	require("setup.termopen")

	use 'fabi1cazenave/suckless.vim'
	require("setup.suckless")
	--}>>

	------------------
	-- Color Themes --
	------------------
	--<<{
	use 'rebelot/kanagawa.nvim'
	use 'folke/tokyonight.nvim'
	use 'dracula/vim'
	use 'morhetz/gruvbox'
	use 'joshdick/onedark.vim'
	use 'fabi1cazenave/kalahari.vim'
	--}>>

	-----------
	-- Misc. --
	-----------
	--<<{
	use 'tpope/vim-surround'
	use 'tpope/vim-commentary'
	use 'tpope/vim-repeat'
	use 'ervandew/supertab'
	use 'jeetsukumaran/vim-indentwise'

	-- snippets, doesn't seem to work with lsp
	use 'SirVer/ultisnips'
	use 'honza/vim-snippets'

	use 'nvim-lualine/lualine.nvim'  -- fancy buffer separators
	require("setup.lualine")
	-- use 'yamatsum/nvim-cursorline'   -- deprecated

	use 'machakann/vim-highlightedyank'
	require("setup.highlightedyank")

	use 'plasticboy/vim-markdown'
	require("setup.vim_markdown")
	--}>>


end)
--}>>

--------------------------------
-- auto-completion (nvim-cmp) --
--------------------------------
--<<{
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
--}>>

---------------------------------------------
-- LSP buffer-specific options and keymaps --
---------------------------------------------
--<<{
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
--}>>

------------------------------------------------------------------------------------------
-- LSP activation: call 'setup' on multiple servers                                     --
-- and add local keybindings and snippet capabilities when the language server attaches --
----------------------------------------------------------------------------------------<<{
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
--}>>
