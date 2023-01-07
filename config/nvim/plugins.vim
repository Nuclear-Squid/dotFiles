" lua require('settings')

" auto-indentation, auto-save
filetype plugin indent on
autocmd! BufWritePost settings.vim source %

" plugins
call plug#begin('~/.config/nvim/plugged')
" Plug 'w0rp/ale'
" Plug 'OmniSharp/omnisharp-vim'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
" Plug 'nvim-lualine/lualine.nvim'
" Plug 'rebelot/kanagawa.nvim'
" Plug 'folke/tokyonight.nvim'
" Plug 'dracula/vim'
" Plug '~/Code/dotFiles/config/nvim/plugged/photon'
" Plug 'morhetz/gruvbox'
" Plug 'joshdick/onedark.vim'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-repeat'
" Plug 'ervandew/supertab'
" Plug 'yamatsum/nvim-cursorline'

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-context'

" Plug 'fabi1cazenave/kalahari.vim'
" Plug 'fabi1cazenave/suckless.vim' " window management that sucks less
" Plug 'fabi1cazenave/termopen.vim'
" Plug 'machakann/vim-highlightedyank'
" Plug 'junegunn/vim-slash'
" let g:highlightedyank_highlight_duration = 250
" let g:markdown_fenced_Languages = ['html', 'css', 'bash=sh', 'ocaml', 'c', 'python']
" Plug 'plasticboy/vim-markdown'
" Plug 'jeetsukumaran/vim-indentwise' " Moving through indents levels
call plug#end()

" let g:suckless_tmap = 1
" let g:suckless_mappings_ergol = {
" \        '<M-[snt]>'      :   'SetTilingMode("[sdf]")'    ,
" \        '<M-[hreo]>'     :    'SelectWindow("[hjkl]")'   ,
" \        '<M-[HREO]>'     :      'MoveWindow("[hjkl]")'   ,
" \      '<C-M-[hreo]>'     :    'ResizeWindow("[hjkl]")'   ,
" \        '<M-[pP]>'       :    'CreateWindow("[sv]")'     ,
" \        '<M-m>'          :     'CloseWindow()'           ,
" \        '<M-Return>'     :        'TermOpen()'           ,
" \        '<M-Backspace>'  :  'TermOpenRanger()'           ,
" \        '<M-[123456789]>':       'SelectTab([123456789])',
" \        '<M-[!@#$%^&*(]>': 'MoveWindowToTab([123456789])',
" \      '<C-M-[123456789]>': 'CopyWindowToTab([123456789])',
" \}
" let g:suckless_mappings_azerty = {
" \        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
" \        '<M-[hjkl]>'     :    'SelectWindow("[hjkl]")'   ,
" \        '<M-[HJKL]>'     :      'MoveWindow("[hjkl]")'   ,
" \      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
" \        '<M-[oO]>'       :    'CreateWindow("[sv]")'     ,
" \        '<M-w>'          :     'CloseWindow()'           ,
" \        '<M-Return>'     :        'TermOpen()'           ,
" \        '<M-Backspace>'  :  'TermOpenRanger()'           ,
" \        '<M-[&é"''(-è_ç]>':       'SelectTab([123456789])',
" \        '<M-[123456789]>': 'MoveWindowToTab([123456789])',
" \      '<C-M-[&é"''(-è_ç]>': 'CopyWindowToTab([123456789])',
" \}
" let g:suckless_mappings_qwerty = {
" \        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
" \        '<M-[hjkl]>'     :    'SelectWindow("[hjkl]")'   ,
" \        '<M-[HJKL]>'     :      'MoveWindow("[hjkl]")'   ,
" \      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
" \        '<M-[oO]>'       :    'CreateWindow("[sv]")'     ,
" \        '<M-w>'          :     'CloseWindow()'           ,
" \        '<M-Return>'     :        'TermOpen()'           ,
" \        '<M-Backspace>'  :  'TermOpenRanger()'           ,
" \        '<M-[123456789]>':       'SelectTab([123456789])',
" \        '<M-[!@#$%^&*(]>': 'MoveWindowToTab([123456789])',
" \      '<C-M-[123456789]>': 'CopyWindowToTab([123456789])',
" \}
" let g:suckless_mappings = g:suckless_mappings_ergol
" " let g:suckless_mappings = g:suckless_mappings_azerty
" " let g:suckless_mappings = g:suckless_mappings_qwerty

" lua << END
" vim.keymap.set('n', '<M-Return>', ':call TermOpen("zsh", "f")<CR>')
" END

" lua << END
" require('lualine').setup {
"   options = {
"     icons_enabled = true,
"     -- theme = 'gruvbox',
"     theme = 'auto',
"     component_separators = { left = '', right = ''},
"     section_separators = { left = '', right = ''},
"     disabled_filetypes = {
"       statusline = {},
"       winbar = {},
"     },
"     ignore_focus = {},
"     always_divide_middle = true,
"     globalstatus = false,
"     refresh = {
"       statusline = 1000,
"       tabline = 1000,
"       winbar = 1000,
"     }
"   },
"   sections = {
"     lualine_a = {'mode'},
"     lualine_b = {'branch', 'diff', 'diagnostics'},
"     lualine_c = {'filename'},
"     lualine_x = {'encoding', 'fileformat', 'filetype'},
"     lualine_y = {'progress'},
"     lualine_z = {'location'}
"   },
"   inactive_sections = {
"     lualine_a = {},
"     lualine_b = {},
"     lualine_c = {'filename'},
"     lualine_x = {'location'},
"     lualine_y = {},
"     lualine_z = {}
"   },
"   tabline = {},
"   winbar = {},
"   inactive_winbar = {},
"   extensions = {}
" }
" END
