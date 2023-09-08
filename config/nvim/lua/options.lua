vim.cmd("autocmd! BufWritePost options.lua source %")

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

-- thème de couleur :
---------------------
-- vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme dracula")
vim.cmd("colorscheme photon")

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
set.foldmethod  = 'indent' -- Genère les folds à partir de l'indentation
set.smartindent = true     -- Auto-indentation quand on retourne à la ligne
set.shiftwidth  = 4        -- ???
set.softtabstop = 4        -- Nombre d'espaces quand on fait tab
set.tabstop     = 4        -- Nombre d'espaces, mais pas pareil ??
set.expandtab   = true     -- Transforme les tabs en espaces
map('n', '<Tab>', 'za')
map('n', '<S-Tab>', 'zA')

-- Je suis pas sûr que ça réponde exactement à ta question, mais ça marcherai pas ça ? `set.clipboard = 'unnamedplus'  -- Registre par defaut : '+'` (Ça permet d’utiliser le clipboard global par défaut)
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
