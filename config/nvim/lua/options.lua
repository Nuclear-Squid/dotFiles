vim.cmd("autocmd! BufWritePost options.lua source %")

-- ╭─────────────────────────────────────────────────────────╮
-- │                    Sucre syntaxique                     │
-- ╰─────────────────────────────────────────────────────────╯
local set = vim.opt
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

-- ╭─────────────────────────────────────────────────────────╮
-- │                      Autocommands                       │
-- ╰─────────────────────────────────────────────────────────╯
autocmd("InsertLeave", { pattern = "*", command = "write" })

-- ╭─────────────────────────────────────────────────────────╮
-- │          Compléter avec <Tab> en mode commande          │
-- ╰─────────────────────────────────────────────────────────╯
set.wildmenu = true
set.wildmode = 'longest,full'

-- ╭─────────────────────────────────────────────────────────╮
-- │                 Recherche incrémentale                  │
-- ╰─────────────────────────────────────────────────────────╯
set.hlsearch   = true     -- Surligne les patterns trouvés pendant les recherches
set.ignorecase = true     -- Les recherches ne sont de base pas case sensitives
set.smartcase  = true     -- Recherches case sensitives si il y a une maj dans le pattern
set.incsearch  = true     -- Sauter au match suivant / précédant avec n / N
set.inccommand = 'split'  -- Affiche le résultat de :s en temps réel

-- ╭─────────────────────────────────────────────────────────╮
-- │                     aides visuelles                     │
-- ╰─────────────────────────────────────────────────────────╯
set.scrolloff = 5         -- Garder au moins 5 lignes au dessus / dessous le curseur
set.number    = true      -- Afficher les numéros de lignes à gauche
set.ruler     = true      -- Affiche la position du curseur en bas du buffer
set.showcmd   = true      -- Montre la commande dans la ligne de statuts
set.showmatch = true      -- Surligne la parenthèse associée a celle survolée
set.linebreak = true      -- Pas couper les mots en cas de retrour à la ligne
set.list      = true      -- Afficher des symboles sur certains caractères.
set.listchars = {         -- La liste de caractères et leur symboles
    nbsp  = '¤',          -- no-break-space
    tab   = '··',         -- tabs
    trail = '¤',          -- trailing white spaces
}

-- ╭─────────────────────────────────────────────────────────╮
-- │                  Options pour du joli                   │
-- ╰─────────────────────────────────────────────────────────╯
-- set.t_Co = 256  -- what
set.termguicolors = true  -- 24bit colors babyyyyyyy !!
set.winblend = 20         -- Semi-transparence pour les fenêtres flotates
set.background = 'dark'   -- L'ilusion du choix
set.splitbelow = true     -- Mettre la nouvelle fenêtre en bas quand split vertical
set.splitright = true     -- Mettre la nouvelle fenêtre à droite quand split horizontal
vim.cmd("colorscheme oneokai")

-- ╭─────────────────────────────────────────────────────────╮
-- │                     config Neovide                      │
-- ╰─────────────────────────────────────────────────────────╯
if vim.g.neovide then
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

    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_vfx_opacity = 500
    vim.g.neovide_cursor_vfx_particle_lifetime = 1.1
    vim.g.neovide_cursor_vfx_particle_density = 15
    vim.g.neovide_cursor_vfx_particle_speed = 20.0
    vim.g.neovide_cursor_vfx_particle_phase = 3
    vim.g.neovide_cursor_vfx_particle_curl = 3

    -- J’aimerai bien avoir ça en plus, mais c’est pas possible
    -- vim.g.neovide_cursor_vfx_mode = "ripple"

    -- Changer la taille de police à la volée (Mud <3 <3 <3)
    -- https://stackoverflow.com/questions/73572079/neovim-lua-how-to-use-mutable-variables-in-keymappings/73574837#73574837
    map('n', '<C-->', ":let g:font_size = (g:font_size - 1)<CR>:let &guifont = 'FantasqueSansMono Nerd Font Mono:h'.g:font_size<CR>", { silent = true })
    map('n', '<C-+>', ":let g:font_size = (g:font_size + 1)<CR>:let &guifont = 'FantasqueSansMono Nerd Font Mono:h'.g:font_size<CR>", { silent = true })

    -- Passer vite entre la taille de police pour écran 12 et 24 pouces
    vim.keymap.set('n', '<F11>', ":let &guifont = (&guifont == 'FantasqueSansMono Nerd Font Mono:h8' ? 'FantasqueSansMono Nerd Font Mono:h10' : 'FantasqueSansMono Nerd Font Mono:h8')<CR>", { silent = true })
end

-- ╭─────────────────────────────────────────────────────────╮
-- │                      Code folding                       │
-- ╰─────────────────────────────────────────────────────────╯
set.foldmethod  = 'indent' -- Genère les folds à partir de l'indentation
set.smartindent = true     -- Auto-indentation quand on retourne à la ligne
set.shiftwidth  = 4        -- ???
set.softtabstop = 4        -- Nombre d'espaces quand on fait tab
set.tabstop     = 4        -- Nombre d'espaces, mais pas pareil ??
set.expandtab   = true     -- Transforme les tabs en espaces
map('n', '<Tab>', 'za')
map('n', '<S-Tab>', 'zA')

-- ╭─────────────────────────────────────────────────────────╮
-- │          Options honteuses (pour les faibles)           │
-- ╰─────────────────────────────────────────────────────────╯
set.clipboard = 'unnamedplus'  -- Registre par defaut : '+'
set.mouse = 'a'         -- Active la sourie (surtout pour le scroll)
-- set.mouse = ''          -- Fuck la sourie
set.mousehide = true    -- Cache la sourie quand on tape
set.autowrite = true    -- Auto-save avant certaines cmd comme :next / :make
vim.cmd [[
    set rtp^="/home/leo/.opam/default/share/ocp-indent/vim"
]] -- OCaml setup thing, idk
