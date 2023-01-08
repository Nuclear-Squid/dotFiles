-- vim: set fdm=marker fmr=<<{,}>> fdl=0 ft=lua:
vim.cmd("autocmd! BufWritePost plugins.lua source %")

require('packer').startup(function(use)
use 'wbthomason/packer.nvim'  -- Packer can manage itself.

---------
-- LSP --
--------- 
--<<{
use 'w0rp/ale'  -- linter, not lsp but kinda related

use 'neovim/nvim-lspconfig'   -- Language Server Protocol
use 'williamboman/mason.nvim' -- LSP/DAP package manager
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
require("setup.cmp")
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
require('telescope').setup { defaults = { winblend = 20 } }
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
vim.g.highlightedyank_highlight_duration = 250

use 'plasticboy/vim-markdown'
vim.g.markdown_fenced_Languages = { 'html', 'css', 'bash=sh', 'ocaml', 'c', 'python' }
--}>>

end)
