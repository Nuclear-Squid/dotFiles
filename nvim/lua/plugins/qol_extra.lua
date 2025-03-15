local map_fns = require('mapping_functions')
local nmap = map_fns.nmap
local vmap = map_fns.vmap

return {
  --  ──────────────────────────< Better motions >───────────────────────
  'jeetsukumaran/vim-indentwise',
  { -- ignore folds when jumping to next paragraph
    'justinmk/vim-ipmotion',
    init = function()
      vim.g.ip_skipfold = 1
    end,
  },

  --  ─────────────────────────< In Tpope we trust >─────────────────────────
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-repeat',
  { 'tpope/vim-surround',
    init = function()
      nmap 's' '<Plug>Csurround'
      vmap 's' '<Plug>VSurround'
    end,
  },
}
