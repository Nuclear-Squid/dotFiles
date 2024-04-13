-- vim: set fdm=marker fmr=<<{,}>> fdl=0 ft=lua:
vim.cmd("autocmd! BufWritePost init.lua source %")

require('packer').startup(function(use)
use 'wbthomason/packer.nvim'  -- Packer can manage itself.

-- ╭─────────────────────────────────────────────────────────╮
-- │                           LSP                           │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
use 'w0rp/ale'  -- linter, not lsp but kinda related

use 'neovim/nvim-lspconfig'   -- Language Server Protocol
require 'plugins.setup.lspconfig'

use 'williamboman/mason.nvim' -- LSP/DAP package manager
use 'williamboman/mason-lspconfig'
require 'plugins.setup.mason'
-- require("plugins.setup.mason-lspconfig")

-- Auto-Completion 
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-path'
use 'hrsh7th/cmp-cmdline'
use 'hrsh7th/nvim-cmp'
-- For vsnip users.
use 'hrsh7th/cmp-vsnip'
use 'hrsh7th/vim-vsnip'
use 'hrsh7th/vim-vsnip-integ'
require("plugins.setup.cmp")

use 'vigoux/ltex-ls.nvim'
require 'ltex-ls'.setup {}
--}>>

-- ╭─────────────────────────────────────────────────────────╮
-- │                        Telescope                        │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
use { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    }
}
require 'plugins.setup.telescope'
--}>>

-- ╭─────────────────────────────────────────────────────────╮
-- │                       TreeSitter                        │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
use 'nvim-treesitter/nvim-treesitter'
use { 'nvim-treesitter/nvim-treesitter-context',
    requires = 'nvim-treesitter/nvim-treesitter',
}
use { 'nvim-treesitter/playground',
    requires = 'nvim-treesitter/nvim-treesitter',
}
require("plugins.setup.treesitter")
--}>>

-- ╭─────────────────────────────────────────────────────────╮
-- │                     Tiling Manager                      │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
use 'fabi1cazenave/termopen.vim'
use 'fabi1cazenave/suckless.vim'
require("plugins.setup.suckless")
--}>>

-- ╭─────────────────────────────────────────────────────────╮
-- │                      Color Themes                       │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
-- My current theme, oneokai with a lot of tinkering.
-- Custom treesitter queries are specified at `/after/queries`
use 'AxelGard/oneokai.nvim'
require 'plugins.setup.oneokai'

-- Other themes I may come back to
use 'morhetz/gruvbox'
use 'rebelot/kanagawa.nvim'
use 'EdenEast/nightfox.nvim'
use 'folke/tokyonight.nvim'
use 'sainnhe/everforest'

-- Meh, not bad, not good either
-- use 'dracula/vim'
-- use 'joshdick/onedark.vim'
-- use 'arturgoms/moonbow.nvim'
-- use '~/Code/projets_persos/photon.nvim'
-- use 'fabi1cazenave/kalahari.vim'
-- use 'Shatur/neovim-ayu'
-- use 'JoosepAlviste/palenightfall.nvim'
-- use 'lucastrvsn/kikwis'
-- use 'catppuccin/nvim'
--}>>

-- ╭─────────────────────────────────────────────────────────╮
-- │                          Misc.                          │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
use {
    'nvim-neorg/neorg',
    config = function()
        require("plugins.setup.neorg")
    end,
    run = ":Neorg sync-parsers",
    requires = "nvim-lua/plenary.nvim",
}
use 'tpope/vim-surround'
use 'tpope/vim-commentary'
use 'tpope/vim-repeat'
use 'ervandew/supertab'
use 'jeetsukumaran/vim-indentwise'

use 'wellle/targets.vim'  -- supercharge your text objects
use 'justinmk/vim-ipmotion'  -- ignore folds when jumping to next paragraphe
vim.g.ip_skipfold = 1

use 'LudoPinelli/comment-box.nvim'

use '~/Code/projets_persos/just-code'
require('just-code').setup()

use {
    "folke/noice.nvim",
    requires = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}
require 'plugins.setup.noice'

-- snippets, doesn't seem to work with lsp
-- use 'SirVer/ultisnips'
-- use 'honza/vim-snippets'
-- require 'mappings.ultisnips'

use 'nvim-lualine/lualine.nvim'  -- fancy buffer separators
require("plugins.setup.lualine")
-- use 'yamatsum/nvim-cursorline'   -- deprecated

use 'machakann/vim-highlightedyank'
vim.g.highlightedyank_highlight_duration = 250

use 'plasticboy/vim-markdown'
vim.g.markdown_fenced_Languages = { 'html', 'css', 'bash=sh', 'ocaml', 'c', 'python' }

use 'ARM9/arm-syntax-vim'
vim.cmd('au BufNewFile,BufRead *.s,*.S set filetype=arm " arm = armv7')
--}>>

end)
