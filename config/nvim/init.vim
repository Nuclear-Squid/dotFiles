" aides visuelles
set number
set ruler
set showcmd		    " Show (partial) command in status line.
set showmatch		" Show matching brackets.
set linebreak       " Do not split words when wrapping text.

" auto-indentation, auto-save
filetype plugin indent on
autocmd! InsertLeave * write
autocmd! BufWritePost init.vim source %

" recherche incrémentale
set hlsearch
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set inccommand=nosplit

" compléter avec <Tab> en mode commande
set wildmenu
set wildmode=longest,full

" options honteuses (pour les faibles)
set clipboard=unnamedplus
set mouse=a
set rtp^="/home/leo/.opam/default/share/ocp-indent/vim" "setup ocamlformat
" set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned

" un peu de cohérence dans un monde de brutes
nmap Y y$
nmap U <C-r>
" imap kj <C-[>

" plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'w0rp/ale'
" Plug 'OmniSharp/omnisharp-vim'
" Plug 'SirVer/ultisnips'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'ervandew/supertab'
Plug 'fabi1cazenave/kalahari.vim'
Plug 'fabi1cazenave/suckless.vim' " window management that sucks less
Plug 'fabi1cazenave/termopen.vim'
Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = 250
let g:markdown_fenced_Languages = ['html', 'css', 'bash=sh', 'ocaml', 'c']
Plug 'plasticboy/vim-markdown'
call plug#end()

" coloration syntaxique
set t_Co=256
set background=dark
" colorscheme desert
colorscheme kalahari
syntax on

" F12 pour changer de fond (noir/blanc)
nmap <silent><F12> :let &bg = (&bg == 'light' ? 'dark' : 'light')<CR>

set splitbelow
set splitright
let g:suckless_tmap = 1
let g:suckless_mappings_ergol = {
\        '<M-[srt]>'      :   'SetTilingMode("[sdf]")'    ,
\        '<M-[hnei]>'     :    'SelectWindow("[hjkl]")'   ,
\        '<M-[HNEI]>'     :      'MoveWindow("[hjkl]")'   ,
\      '<C-M-[hnei]>'     :    'ResizeWindow("[hjkl]")'   ,
\        '<M-[pP]>'       :    'CreateWindow("[sv]")'     ,
\        '<M-o>'          :     'CloseWindow()'           ,
\        '<M-Return>'     :        'TermOpen()'           ,
\        '<M-Backspace>'  :  'TermOpenRanger()'           ,
\        '<M-[123456789]>':       'SelectTab([123456789])',
\        '<M-[!@#$%^&*(]>': 'MoveWindowToTab([123456789])',
\      '<C-M-[123456789]>': 'CopyWindowToTab([123456789])',
\}
let g:suckless_mappings_qwerty = {
\        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
\        '<M-[hjkl]>'     :    'SelectWindow("[hjkl]")'   ,
\        '<M-[HJKL]>'     :      'MoveWindow("[hjkl]")'   ,
\      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
\        '<M-[oO]>'       :    'CreateWindow("[sv]")'     ,
\        '<M-w>'          :     'CloseWindow()'           ,
\        '<M-Return>'     :        'TermOpen()'           ,
\        '<M-Backspace>'  :  'TermOpenRanger()'           ,
\        '<M-[123456789]>':       'SelectTab([123456789])',
\        '<M-[!@#$%^&*(]>': 'MoveWindowToTab([123456789])',
\      '<C-M-[123456789]>': 'CopyWindowToTab([123456789])',
\}
" let g:suckless_mappings = g:suckless_mappings_qwerty
let g:suckless_mappings = g:suckless_mappings_ergol

" code folding
set foldmethod=indent
set smartindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
nmap <Tab> za
nmap <S-Tab> zA
nmap <silent> z0 :set fdl=0<CR>
nmap <silent> z1 :set fdl=1<CR>
nmap <silent> z2 :set fdl=2<CR>
nmap <silent> z3 :set fdl=3<CR>
nmap <silent> z4 :set fdl=4<CR>
nmap <silent> z5 :set fdl=5<CR>
nmap <silent> z6 :set fdl=6<CR>
nmap <silent> z7 :set fdl=7<CR>
nmap <silent> z8 :set fdl=8<CR>
nmap <silent> z9 :set fdl=9<CR>

map <C-u> gUiw
imap <C-u> <Left><C-o>gUiw<C-o>e<Right>

let mapleader = "\<Space>"

nmap <leader>w :w<CR>
nmap <leader>e :e<CR>
nmap <leader>q :q<CR>
nmap <leader>x :x<CR>

" nmap <M-Left>  :call SelectWindow("h")<CR>
" nmap <M-Up>    :call SelectWindow("k")<CR>
" nmap <M-Down>  :call SelectWindow("j")<CR>
" nmap <M-Right> :call SelectWindow("l")<CR>

" nmap <M-S-Left>  :call MoveWindow("h")<CR>
" nmap <M-S-Up>    :call MoveWindow("k")<CR>
" nmap <M-S-Down>  :call MoveWindow("j")<CR>
" nmap <M-S-Right> :call MoveWindow("l")<CR>

" nmap <M-C-Left>  :call ResizeWindow("h")<CR>
" nmap <M-C-Up>    :call ResizeWindow("k")<CR>
" nmap <M-C-Down>  :call ResizeWindow("j")<CR>
" nmap <M-C-Right> :call ResizeWindow("l")<CR>
