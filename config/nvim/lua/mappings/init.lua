-- vim: set fdm=marker fmr=<<{,}>> fdl=0 ft=lua:
vim.cmd("autocmd! BufWritePost init.lua source %")

local utils = require "utils"
local  map     = utils. map
local nmap     = utils.nmap
local imap     = utils.imap
local vmap     = utils.vmap
local  map_opt = utils. map_opt

----------------------
-- General Mappings --
----------------------
--<<{
-- Un peu de cohérence dans un monde de brutes
nmap 'Y' 'y$'
nmap 'U' '<C-r>'
imap '<C-BS>' '<C-w>'

-- En vrai `s` ça sert à quoi ?
nmap 's' '<Plug>Csurround'
vmap 's' ':s/'

-- Déplacements plus intuitif quand on utilise f ou t
map { 'n', 'v', 'o' } ',' ';'
map { 'n', 'v', 'o' } ';' ','

-- Plus intuitif quand une ligne est cassée en deux
map { 'n', 'v' } 'j' 'gj'
map { 'n', 'v' } 'k' 'gk'
map { 'n', 'v' } '<Down>' 'gj'
map { 'n', 'v' } '<Up>' 'gk'

-- Parce que Ergo-L
map { 'n', 'v' } '+' 'gj'
map { 'n', 'v' } '-' 'gk'

-- Parce que flemme
nmap 'dm' '"Qd'
nmap 'yg' '"Qy'
nmap 'qq' '"qpqqq'

-- « Atta je réessaye »
function duplicate_and_comment_inner(start_line, finish_line)
    local range = string.format("%d,%d ", start_line, finish_line)
    vim.cmd(range .. 'yank')
    vim.cmd(range .. 'Commentary')
    vim.api.nvim_win_set_cursor(0, { finish_line, 0 })
    vim.cmd('put')
end

function duplicate_and_comment_normal()
    local start_line  = unpack(vim.api.nvim_buf_get_mark(0, '['))
    local finish_line = unpack(vim.api.nvim_buf_get_mark(0, ']'))

    -- Allow `h` as movement option for single line duplication
    if finish_line < start_line then finish_line = start_line end
    duplicate_and_comment_inner(start_line, finish_line)
end

function duplicate_and_comment_visual()
    local start_line  = vim.fn.getpos '.'[2]
    local finish_line = vim.fn.getpos 'v'[2]

    -- Prevent backward ranges
    if finish_line < start_line then
        local tmp = finish_line
        finish_line = start_line
        start_line = tmp
    end

    duplicate_and_comment_inner(start_line, finish_line)
end

nmap 'gh' ':set opfunc=v:lua.duplicate_and_comment_normal<CR>g@'
vmap 'gh' (duplicate_and_comment_visual)

-- Garder la selection
vmap '<'           '<gv'
vmap '>'           '>gv'
vmap '<C-a>'   '<C-a>gv'
vmap '<C-x>'   '<C-x>gv'
vmap 'g<C-a>' 'g<C-a>gv'
vmap 'g<C-x>' 'g<C-x>gv'

-- Fuck capslock
nmap '<C-u>' 'gUiw'
imap '<C-u>' '<Left><C-o>gUiw<C-o>e<Right>'
--}>>


-------------
-- Aliases --
-------------
--<<{
-- Quand Ergo-L me casse les couilles
imap 'fnt' 'function'

-- Insérer un bloc d’accolades
function bracket_group(opening_delim, closing_delim)
    return function()
        local current_line = vim.api.nvim_get_current_line()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))

        local left_of_cursor  = ""
        local right_of_cursor = ""

        if col == string.len(current_line) then
            local index_last_space = string.find(current_line, ' [^ ]*$')

            if utils.str_at(current_line, index_last_space - 1) == '(' then
                left_of_cursor = string.sub(current_line, 1, index_last_space - 1) .. opening_delim
            else
                left_of_cursor = string.sub(current_line, 1, index_last_space) .. opening_delim
            end

            if string.find(string.sub(current_line, index_last_space + 1), '[^]});,]') then
                right_of_cursor = closing_delim .. string.sub(current_line, index_last_space)
            else
                right_of_cursor = closing_delim .. string.sub(current_line, index_last_space + 1)
            end
        else
            left_of_cursor  = string.sub(current_line, 1, col) .. opening_delim
            right_of_cursor = closing_delim .. string.sub(current_line, col + 1)
        end

        local nb_espaces_indentation = math.floor(
            (string.len(current_line) - string.len(utils.str_trim_left(current_line)))
            / vim.o.tabstop
        )

        local nb_espaces_nouvelle_ligne = nb_espaces_indentation + vim.o.tabstop

        vim.api.nvim_buf_set_lines(0, row - 1, row, true, {
            left_of_cursor,
            string.rep(" ", nb_espaces_nouvelle_ligne),
            utils.str_trim_right(right_of_cursor),
        })

        vim.api.nvim_win_set_cursor(0, { row + 1, nb_espaces_nouvelle_ligne })
    end
end
imap '{(' (bracket_group('{', '}'))
imap '@[' (bracket_group('[', ']'))

imap '<C-CR>' '<UP><END><CR>'
imap '[[' '[0]'
--}>>

------------
-- Leader --
------------
--<<{
vim.g.mapleader = " "
nmap '<leader>w' ':w<CR>'
nmap '<leader>q' ':q<CR>'
nmap '<leader>x' ':x<CR>'
nmap '<leader>h' ':nohl<CR>'
nmap '<leader> ' ':%s/ / /g<CR>``'  -- leader -> shift + espace, supprime tous les shift + espaces.

vim.g.maplocalleader = " l"
--}>>

------------
-- Editor --
------------
--<<{
-- Fold mappings
nmap 'z0' ':set fdl=0<CR>'
nmap 'z1' ':set fdl=1<CR>'
nmap 'z2' ':set fdl=2<CR>'
nmap 'z3' ':set fdl=3<CR>'
nmap 'z4' ':set fdl=4<CR>'
nmap 'z5' ':set fdl=5<CR>'
nmap 'z6' ':set fdl=6<CR>'
nmap 'z7' ':set fdl=7<CR>'
nmap 'z8' ':set fdl=8<CR>'
nmap 'z9' ':set fdl=9<CR>'
--}>>
