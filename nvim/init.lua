--  ────────────────────< Imports and syntaxic sugar >─────────────────
local utils = require 'utils'
local map = utils.map
local nmap = utils.nmap
local imap = utils.imap
local vmap = utils.vmap

local map_fns = require 'mapping_functions'
local make_awesome_mapping = map_fns.make_awesome_mapping

local set = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local default_timer = 350

--  ───────────────────────────< Autocommands >────────────────────────
autocmd('InsertLeave', { pattern = '*', command = 'write' })

-- Disable folding in Telescope's result window.
autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = default_timer }
  end,
})


autocmd("BufReadPost", {
    desc = 'Restore cursor to file position in previous editing session',
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"zz')
        end
    end,
})

-- Show cursorline only on active windows
autocmd({ "InsertLeave", "WinEnter" }, {
    callback = function()
        if vim.w.auto_cursorline then
            vim.wo.cursorline = true
            vim.w.auto_cursorline = false
        end
    end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
    callback = function()
        if vim.wo.cursorline then
            vim.w.auto_cursorline = true
            vim.wo.cursorline = false
        end
    end,
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                         Options                         │
--          ╰─────────────────────────────────────────────────────────╯

--  ───────────────< Options honteuses (pour les faibles) >────────────
set.clipboard = 'unnamedplus' -- Registre par defaut : '+'
set.mouse = 'a' -- Active la sourie (surtout pour le scroll)
set.mousehide = true -- Cache la sourie quand on tape
set.autowrite = true -- Auto-save avant certaines cmd comme :next / :make
set.undofile = true -- Sauvegarde l’historique de retours en arrière.

--  ───────────────────────────< Code folding >────────────────────────
set.foldmethod = 'indent' -- Genère les folds à partir de l'indentation
set.smartindent = true -- Auto-indentation quand on retourne à la ligne
set.shiftwidth = 4 -- Nombre d’espaces à ajouter / retirer avec `<` et `>`
set.softtabstop = 4 -- Nombre d'espaces quand on fait tab
set.tabstop = 4 -- Nombre d'espaces, mais pas pareil ??
set.expandtab = true -- Transforme les tabs en espaces

--  ──────────────────────< Recherche incrémentale >───────────────────
set.hlsearch = true -- Surligne les patterns trouvés pendant les recherches
set.ignorecase = true -- Les recherches ne sont de base pas case sensitives
set.smartcase = true -- Recherches case sensitives si il y a une maj dans le pattern
set.incsearch = true -- Sauter au match suivant / précédant avec n / N
set.inccommand = 'split' -- Affiche le résultat de :s en temps réel

--  ──────────────────────────< aides visuelles >──────────────────────────
set.scrolloff = 10 -- Garder au moins 10 lignes au dessus / dessous le curseur
set.number = true -- Afficher les numéros de lignes à gauche
set.ruler = true -- Affiche la position du curseur en bas du buffer
set.showcmd = true -- Montre la commande dans la ligne de statuts
set.showmatch = true -- Surligne la parenthèse associée a celle survolée
set.linebreak = true -- Pas couper les mots en cas de retrour à la ligne
set.breakindent = true -- Indente les lignes coupées quand trop longues
set.list = true -- Afficher des symboles sur certains caractères.
set.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
set.cursorline = true -- Show which line your cursor is on
set.updatetime = default_timer -- Timer pour 'CursorHold'
set.timeoutlen = default_timer -- Timer pour 'WhichKey'

--  ───────────────────────< Options pour du joli >────────────────────
set.termguicolors = true -- 24bit colors babyyyyyyy !!
set.winblend = 20 -- Semi-transparence pour les fenêtres flotates
set.background = 'dark' -- L'ilusion du choix
set.splitbelow = true -- Mettre la nouvelle fenêtre en bas quand split vertical
set.splitright = true -- Mettre la nouvelle fenêtre à droite quand split horizontal
set.showmode = false -- Cacher le mode, vu qu’il est déjà dans la status bar

--  ──────────────────────────< config Neovide >───────────────────────
if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.4
  vim.g.neovide_padding_top = 5
  vim.g.neovide_padding_left = 5
  vim.g.neovide_cursor_unfocused_outline_width = 0.1

  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  vim.g.neovide_transparency = 0.96

  vim.g.neovide_scroll_animation_length = 0.33
  vim.g.neovide_scroll_animation_far_lines = 12
  vim.g.neovide_cursor_animation_length = 0.075

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_no_idle = false

  vim.g.neovide_cursor_vfx_mode = 'railgun'
  vim.g.neovide_cursor_vfx_opacity = 500
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.1
  vim.g.neovide_cursor_vfx_particle_density = 15
  vim.g.neovide_cursor_vfx_particle_speed = 20.0
  vim.g.neovide_cursor_vfx_particle_phase = 3
  vim.g.neovide_cursor_vfx_particle_curl = 3

  -- J’aimerai bien avoir ça en plus, mais c’est pas possible
  -- vim.g.neovide_cursor_vfx_mode = "ripple"

  nmap '<C-+>' (function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1 end)
  nmap '<C-->' (function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1 end)

  -- -- Passer vite entre la taille de police pour écran 12 et 24 pouces
  -- vim.keymap.set(
  --   'n',
  --   '<F11>',
  --   ":let &guifont = (&guifont == 'FantasqueSansMono Nerd Font Mono:h8' ? 'FantasqueSansMono Nerd Font Mono:h10' : 'FantasqueSansMono Nerd Font Mono:h8')<CR>",
  --   { silent = true }
  -- )
end

--          ╭─────────────────────────────────────────────────────────╮
--          │                        Mappings                         │
--          ╰─────────────────────────────────────────────────────────╯

--  ────────────────────< Why aren’t those standard? >─────────────────
nmap 'Y' 'yg_'
nmap 'U' '<C-r>'
imap '<C-BS>' '<C-w>'

map { 'n', 'v' } 'j'      'gj'
map { 'n', 'v' } '<Down>' 'gj'
map { 'n', 'v' } '+'      'gj'

map { 'n', 'v' } 'k'    'gk'
map { 'n', 'v' } '<Up>' 'gk'
map { 'n', 'v' } '-'    'gk'

vmap '<' '<gv'
vmap '>' '>gv'
vmap '<C-a>' '<C-a>gv'
vmap '<C-x>' '<C-x>gv'
vmap 'g<C-a>' 'g<C-a>gv'
vmap 'g<C-x>' 'g<C-x>gv'

map { 'n', 'v', 'o' } ',' ';'
map { 'n', 'v', 'o' } ';' ','

nmap 'd}' 'V}d'
nmap 'd{' 'V{d'

--  ──────────────────────────────< Leader >───────────────────────────
vim.g.mapleader = ' '
vim.g.maplocalleader = '’'  -- typo -> espace en Ergo‑L

nmap '<leader>w' ':w<CR>'
nmap '<leader>q' ':q<CR>'
nmap '<leader>x' ':x<CR>'
nmap '<leader>d' (map_fns.make_text_object_cmd(map_fns.duplicate_and_comment))
vmap '<leader>d' (map_fns.make_visual_cmd(map_fns.duplicate_and_comment))

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

nmap 'µ' '`m'
nmap 'î' '`d'

-- -- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- setup Lazy (package manager)

--          ╭─────────────────────────────────────────────────────────╮
--          │                         Plugins                         │
--          ╰─────────────────────────────────────────────────────────╯

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- autoinstall if not present
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field

-- add Lazy to neovim’s runtime path
vim.opt.rtp:prepend(lazypath)
require('lazy').setup {
  --  ──────────────────────────────< Photon >───────────────────────────
  -- I made this color theme, so it’s in my dotFiles repo. If you are seeing
  -- this and want to install it for yourself, fetch the plugin at
  -- `Nuclear-Squid/photon.nvim`
  {
    dir = '~/Code/nvim_plugins/photon.nvim',
    priority = 1000, -- Load this before all other plugins.
    init = function()
      vim.cmd.colorscheme 'photon'
    end,
  },

  --  ──────────────────────────< Fancy comments >───────────────────────
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'LudoPinelli/comment-box.nvim',
    init = function()
      nmap '<leader>c' ':CBccline8<CR>'
      nmap '<leader>b' ':CBccbox<CR>'
    end,
  },

  --  ──────────────────────────< Better motions >───────────────────────
  'jeetsukumaran/vim-indentwise',
  'wellle/targets.vim', -- supercharge your text objects
  { -- ignore folds when jumping to next paragraphe
    'justinmk/vim-ipmotion',
    init = function()
      vim.g.ip_skipfold = 1
    end,
  },

  --  ─────────────────────────< In Tpope we trust >─────────────────────────
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-repeat',
  {
    'tpope/vim-surround',
    init = function()
      nmap 's' '<Plug>Csurround'
      vmap 's' '<Plug>VSurround'
    end,
  },

  --  ────────────────────< More complex plugin setups >─────────────────
  require 'plugins.cmp',
  -- require 'plugins.conform',
  require 'plugins.debug',
  -- require 'plugins.gitsigns',
  require 'plugins.lint',
  require 'plugins.lspconfig',
  require 'plugins.lualine',
  require 'plugins.suckless',
  require 'plugins.telescope',
  require 'plugins.treesitter',
}
