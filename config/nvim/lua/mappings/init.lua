-- vim: set fdm=marker fmr=<<{,}>> fdl=0 ft=lua:
vim.cmd("autocmd! BufWritePost init.lua source %")

-- ╭─────────────────────────────────────────────────────────╮
-- │               Imports et sucre syntaxique               │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
local utils    = require "utils"
local  map     = utils. map
local nmap     = utils.nmap
local imap     = utils.imap
local vmap     = utils.vmap
local  map_opt = utils. map_opt

function bracket_group(opening_delim, closing_delim)
    return function()
        local current_line = vim.api.nvim_get_current_line()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))

        local left_of_cursor  = ""
        local right_of_cursor = ""

        local left_no_space_chars  = "({["
        local right_no_space_chars = ")}];,"

        function no_space_char_at_pos(no_space_chars, str, pos)
            if math.abs(pos) > str:len() then return false end
            return no_space_chars:find('['..utils.str_at(str, pos)..']')
        end

        if col == current_line:len() then
            local index_last_space = current_line:find(' [^ ]*$')

            -- Motherfucking arrays start at 1
            left_of_cursor  = current_line:sub(1, index_last_space)
            right_of_cursor = current_line:sub(index_last_space)

            if no_space_char_at_pos(left_no_space_chars, left_of_cursor, -2) then
                left_of_cursor = left_of_cursor:sub(1, -2)
            end

            if no_space_char_at_pos(right_no_space_chars, right_of_cursor, -2) then
                right_of_cursor = right_of_cursor:sub(2)
            end

            dbg = right_of_cursor
            left_of_cursor  = left_of_cursor .. opening_delim
            right_of_cursor = closing_delim  .. utils.str_trim_right(right_of_cursor)
        else
            left_of_cursor  = current_line:sub(1, col) .. opening_delim
            right_of_cursor = closing_delim .. current_line:sub(col + 1)
        end

        local indentation = string.rep(' ', current_line:len() -
                utils.str_trim_left(current_line):len())

        local indentation_nouvelle_ligne = indentation .. string.rep(' ', vim.o.tabstop)

        vim.api.nvim_buf_set_lines(0, row - 1, row, true, {
            left_of_cursor,
            indentation_nouvelle_ligne,
            indentation .. utils.str_trim_right(right_of_cursor),
        })

        vim.api.nvim_win_set_cursor(0, { row + 1, indentation_nouvelle_ligne:len() })
    end
end

function replace_on_range()
    local start_line  = unpack(vim.api.nvim_buf_get_mark(0, '['))
    local finish_line = unpack(vim.api.nvim_buf_get_mark(0, ']'))
    vim.api.nvim_feedkeys(string.format(":%d,%ds/", start_line, finish_line), 'n', false)
end

-- « Atta je réessaye »
function duplicate_and_comment(start_line, finish_line, cursor_line, cursor_col)
    local new_cursor_line = cursor_line + finish_line - start_line + 1
    local range = string.format("%d,%d ", start_line, finish_line)

    vim.cmd(range .. 'yank')
    vim.cmd(range .. 'Commentary')

    vim.api.nvim_win_set_cursor(0, { finish_line, 0 })
    vim.cmd('put')
    vim.api.nvim_win_set_cursor(0, { new_cursor_line, cursor_col })
end

-- La position du curseur est stoquée dans le marqueur '`'
function duplicate_and_comment_normal()
    local start_line  = vim.api.nvim_buf_get_mark(0, '[')[1]
    local finish_line = vim.api.nvim_buf_get_mark(0, ']')[1]
    local cursor_line, cursor_col = unpack(vim.api.nvim_buf_get_mark(0, '`'))
    duplicate_and_comment(start_line, finish_line, cursor_line, cursor_col)
end

function duplicate_and_comment_visual()
    local cursor_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
    local visual_line = vim.fn.getpos('v')[2]
    if cursor_line < visual_line then
        duplicate_and_comment(cursor_line, visual_line, cursor_line, cursor_col)
    else
        duplicate_and_comment(visual_line, cursor_line, cursor_line, cursor_col)
    end
end
--}>>


-- ╭─────────────────────────────────────────────────────────╮
-- │                    General Mappings                     │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
-- Un peu de cohérence dans un monde de brutes
nmap 'Y' 'y$'
nmap 'U' '<C-r>'
imap '<C-BS>' '<C-w>'
imap '<S-CR>' '<UP><END><CR>'

-- En vrai `s` ça sert à quoi ?
nmap 's' '<Plug>Csurround'

vmap 's' '<Plug>VSurround'
vmap 'S' ':s/'

-- Déplacements plus intuitif quand on utilise f ou t
map { 'n', 'v', 'o' } ',' ';'
map { 'n', 'v', 'o' } ';' ','
vmap '$' '$h'

-- Plus intuitif quand une ligne est cassée en deux
map { 'n', 'v' } 'j'      'gj'
map { 'n', 'v' } '<Down>' 'gj'
map { 'n', 'v' } '+'      'gj'

map { 'n', 'v' } 'k'      'gk'
map { 'n', 'v' } '<Up>'   'gk'
map { 'n', 'v' } '-'      'gk'

-- Parce que flemme
nmap 'dm' '"Qd'
nmap 'yg' '"Qy'
nmap 'qq' '"qpqqq'

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

-- ╭─────────────────────────────────────────────────────────╮
-- │                         Aliases                         │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
-- Ergo-L Dead Key Mappings
imap 'µ' '<C-o>db'

-- Quand Ergo-L me casse les couilles
imap 'fnt' 'function'

imap '-+' '0'
imap '+-' '1'
imap '+/' '-1'
imap ';!' '0;'
imap '!;' '1;'


imap '{(' (bracket_group('{', '}'))
imap '~[' (bracket_group('[', ']'))

imap '[[' '[0]'
--}>>

-- ╭─────────────────────────────────────────────────────────╮
-- │                         Leader                          │
-- ╰─────────────────────────────────────────────────────────╯
--<<{
vim.g.mapleader = " "
vim.cmd [[
    nmap <BackSpace> <Nop>
    let maplocalleader = "\<BackSpace>"
]]

nmap '<leader>w' ':w<CR>'
nmap '<leader>q' ':q<CR>'
nmap '<leader>x' ':x<CR>'
nmap '<leader>h' ':nohl<CR>'
nmap '<leader> ' ':%s/ / /g<CR>``'  -- leader -> shift + espace, supprime tous les shift + espaces.
nmap '<leader>r' 'zR'
nmap '<leader>s' ':set opfunc=v:lua.replace_on_range<CR>g@'
nmap '<leader>d' "m`:set opfunc=v:lua.duplicate_and_comment_normal<CR>g@"
vmap '<leader>d' (duplicate_and_comment_visual)

--}>>

-- ╭─────────────────────────────────────────────────────────╮
-- │                         Editor                          │
-- ╰─────────────────────────────────────────────────────────╯
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
