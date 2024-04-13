vim.cmd("autocmd! BufWritePost oneokai.lua source %")

local oneokai = require 'oneokai'
oneokai.load()  -- Loading global variables, **DO NOT** remove, will crash

-- Standard oneokai palettes
local palettes = require 'oneokai.palette'

-- New Colors
-- local c = {
local c = vim.tbl_extend('force', palettes.dark, {  -- reload defaults
    bg0    = '#232136',  -- Stolen from the 'duskfox' theme (bg1)
    fg     = '#cdcbe0',  -- Stolen from the 'duskfox' theme (fg2)
    grey   = '#605969',  -- Halfway between palettes.grey and palettes.warm.grey
    green  = palettes.darkplus.green,
    orange = palettes.deep.orange,
    blue   = palettes.cool.blue,
    cyan   = palettes.warm.cyan,  -- kinda works, not great
    -- cyan   = "#9ccfd8",
    -- cyan   = "#569fba",
    -- cyan   = "#7bb8c1",
}
)

oneokai.setup {
    style = 'dark',

    code_style = {
        keywords = 'italic',
        functions = 'bold',
        strings = 'italic',
    },

    colors = c,

    highlights = {
        -- I love types
        ["@type"]              = { fg = c.yellow },
        ["@type.builtin"]      = { fg = c.yellow },
        ["@type.interface"]    = { fg = c.yellow, fmt = 'italic' },
        ["@type.qualifier"]    = { fg = c.orange, fmt = 'italic' },
        ["@storageclass"]      = { fg = c.orange, fmt = 'italic' },
        ["@property"]          = { fg = c.cyan, },
        ["@field"]             = { fg = c.cyan, },
        ["@lsp.type.property.lua"] = { fg = c.cyan, },
        ["@namespace"]         = { fg = c.orange, },
        ["@punctuation.types"] = { fg = c.purple, }, -- Pretty type anotations, custom group, setup in nvim/after/query

        -- Keywords
        ["@keyword.function"] = { fg = c.red, },
        ["@conditional"]      = { fg = c.orange, },
        ["@repeat"]           = { fg = c.purple, },

        -- Values and Function Calls
        ["@function.call"]    = { fg = c.green, fmt = "bold", },
        ["@method.call"]      = { fg = c.green, fmt = "bold", },
        ["@constant"]         = { fg = c.purple, },
        ["@constant.builtin"] = { fg = c.blue, fmt = "nocombine", },
        ["@lsp.type.macro.c"] = { fg = c.purple, },

        -- Fancy variables
        ["@parameter"]           = { fg = c.blue, },
        ["@lsp.type.parameter"]  = { fg = c.blue, },
        -- Isn’t defined by treesitter, used by the plugin prototype below.
        ["@parameter.reference"] = { fg = c.red, },

        ["@define"]  = { fg = c.purple, fmt = 'italic', },
        ["@include"] = { fg = c.red, fmt = 'italic', },
    },
}

-- better hot reload for debugging purpusses
vim.cmd('colorscheme oneokai')

function concat_string_list(list, separator)
    local rv = ""
    for _, s in pairs(list) do rv = rv..s..separator end
    return rv
end

function get_string_under_node(node)
    local start_line, start_col, end_line, end_col = node:range()
    local lines = concat_string_list(vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, true), '\n')
    local last_line = concat_string_list(vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, true), '\n')
    local last_index = string.len(lines) - string.len(last_line) + end_col
    return lines:sub(start_col + 1, last_index)
end

-- returns a (bool, bool) tuple, for (is_const, is_pointer)
function is_const_pointer(root_node)
    local is_const = false
    local is_pointer = false
    local declarator = nil
    local identifier = nil
    for item in root_node:iter_children() do
        if item:type() == 'type_qualifier' then
            is_const = get_string_under_node(item) == 'const'
        end

        if item:type() == 'pointer_declarator' then
            declarator = item
            is_pointer = true
        end

        if item:type() == 'identifier' then
            identifier = item
        end
    end


    if is_pointer then
        if not is_const then
            while declarator:type() ~= 'identifier' do
                declarator = declarator:field('declarator')[1]
            end
            return { false, true, declarator }
        else
            local child_is_const, child_is_pointer, identifier = unpack(is_const_pointer(declarator))
            if child_is_pointer then
                is_const = child_is_const
            end
            return { is_const, true, identifier }
        end
    else
        return { is_const, false, identifier }
    end
end

vim.g.ref_args_namespace = vim.api.nvim_create_namespace('pointer')
vim.g.ref_mut_args_namespace = vim.api.nvim_create_namespace('mutable_pointer')

function list_contains(list, value)
    for _, v in pairs(list) do
        if v == value then return true end
    end
    return false
end

function highlight_c_mutable_pointers()
    local tree = vim.treesitter.get_parser(0, 'c'):parse()[1]
    vim.api.nvim_buf_clear_namespace(0, vim.g.ref_args_namespace, 0, -1)
    vim.api.nvim_buf_clear_namespace(0, vim.g.ref_mut_args_namespace, 0, -1)

    for item in tree:root():iter_children() do
        if item:type() ~= 'function_definition' then goto continue1 end

        local parameter_list = item:named_child(1):named_child(1)
        if parameter_list == nil then goto continue1 end

        for parameter in parameter_list:iter_children() do
            if list_contains({ '(', ',', ')' }, parameter:type()) then
                goto continue2
            end

            -- print(get_string_under_node(item))
            local is_const, is_pointer, identifier = unpack(is_const_pointer(parameter))
            if identifier == nil then goto continue2 end
            local query = vim.treesitter.query.parse('c', [[
                ((identifier) @parameter (#eq? @parameter "]]
                ..get_string_under_node(identifier)..'"))')
            local query_ref = vim.treesitter.query.parse('c', [[
                ((identifier) @parameter.reference (#eq? @parameter.reference "]]
                ..get_string_under_node(identifier)..'"))')

            if not is_pointer or is_const then
                for _, node in query:iter_captures(item, 0) do
                    local sl, sc, _, ec = node:range()
                    vim.api.nvim_buf_add_highlight(0, vim.g.ref_args_namespace, '@parameter', sl, sc, ec)
                end
            else
                for _, node in query_ref:iter_captures(item, 0) do
                    local sl, sc, _, ec = node:range()
                    vim.api.nvim_buf_add_highlight(0, vim.g.ref_mut_args_namespace, '@parameter.reference', sl, sc, ec)
                end
            end

            ::continue2::
        end

        ::continue1::
    end
end

vim.cmd("autocmd! BufWritePost *.c :lua highlight_c_mutable_pointers()")
