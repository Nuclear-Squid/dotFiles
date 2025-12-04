local options = {
  --  ───────────────< Options honteuses (pour les faibles) >────────────
  clipboard = 'unnamedplus',  -- Registre par defaut : '+'
  mouse     = 'a',   -- Active la sourie (surtout pour le scroll)
  mousehide = true,  -- Cache la sourie quand on tape
  autowrite = true,  -- Auto-save avant certaines cmd comme :next / :make
  undofile  = true,  -- Sauvegarde l’historique de retours en arrière.

  --  ───────────────────────────< Code folding >────────────────────────
  foldmethod = 'expr',
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldtext = require 'foldtext',
  fillchars = {
      eob = "-",
      fold = " ",
      foldopen = "",
      foldclose = "",
      foldsep = " ",  -- or "│" to use bar for show fold area
  },

  --  ────────────────────────────< Indentation >────────────────────────────
  smartindent = true,  -- Auto-indentation quand on retourne à la ligne
  shiftwidth  = 4,     -- Nombre d’espaces à ajouter / retirer avec `<` et `>`
  softtabstop = 4,     -- Nombre d'espaces quand on fait tab
  tabstop     = 4,     -- Nombre d'espaces, mais pas pareil ??
  expandtab   = true,  -- Transforme les tabs en espaces

  --  ──────────────────────< Recherche incrémentale >───────────────────
  hlsearch   = true,   -- Surligne les patterns trouvés pendant les recherches
  ignorecase = true,   -- Les recherches ne sont de base pas case sensitives
  smartcase  = true,   -- Recherches case sensitives si il y a une maj dans le pattern
  incsearch  = true,   -- Sauter au match suivant / précédant avec n / N

  --  ──────────────────────────< aides visuelles >──────────────────────────
  scrolloff   = 10,    -- Garder au moins 10 lignes au dessus / dessous le curseur
  number      = true,  -- Afficher les numéros de lignes à gauche
  ruler       = true,  -- Affiche la position du curseur en bas du buffer
  showcmd     = true,  -- Montre la commande dans la ligne de statuts
  showmatch   = true,  -- Surligne la parenthèse associée a celle survolée
  linebreak   = true,  -- Pas couper les mots en cas de retrour à la ligne
  breakindent = true,  -- Indente les lignes coupées quand trop longues
  list        = true,  -- Afficher des symboles sur certains caractères.
  listchars   = { tab = '» ', trail = '·', nbsp = '␣' },
  cursorline  = true,  -- Show which line your cursor is on
  updatetime  = 350,   -- Timer pour 'CursorHold'
  timeoutlen  = 350,   -- Timer pour 'WhichKey'

  --  ───────────────────────< Options pour du joli >────────────────────
  winblend   = 20,     -- Semi-transparence pour les fenêtres flotates
  splitbelow = true,   -- Mettre la nouvelle fenêtre en bas quand split vertical
  splitright = true,   -- Mettre la nouvelle fenêtre à droite quand split horizontal
  showmode   = false,  -- Cacher le mode, vu qu’il est déjà dans la status bar
}

for option_name, value in pairs(options) do
  -- To avoid errors on toggle nvim version
  local ok, _ = pcall(vim.api.nvim_get_option_info2, option_name, {})
  if ok then
    vim.opt[option_name] = value
  else
    vim.notify("Option " .. option_name .. " is not supported", vim.log.levels.WARN)
  end
end
