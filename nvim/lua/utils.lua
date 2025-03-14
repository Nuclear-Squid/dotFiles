vim.cmd("autocmd! BufWritePost utils.lua source %")

function table.removeKey(list, key)
    local value = list[key]
    list[key] = nil
    return value
end

local function execute_mapping(mapping)
    if mapping == nil then return end

    if type(mapping) == "string" then
        local keys = vim.api.nvim_replace_termcodes(mapping, true, true, true)
        vim.api.nvim_feedkeys(keys, vim.api.nvim_get_mode()["mode"], false)
    else
        mapping()
    end
end

function map(scope)
    return function(patterns)
        return function(target)
            if type(patterns) == "string" then patterns = { patterns } end
            if type(target) ~= "table" then target = { target } end

            local command_before = table.removeKey(target, 'before')
            local command_after  = table.removeKey(target, 'after')
            local base_command   = table.remove(target, 1)
            local options = vim.tbl_extend('force', { noremap = true, silent = true }, target)

            for _, p in pairs(patterns) do
                local command
                if type(command_before) ~= "function" and type(base_command) ~= "function" and type(command_after) ~= "function" then
                    command = (command_before or '') .. (base_command or p) .. (command_after or '')
                else
                    command = function()
                        execute_mapping(command_before)
                        execute_mapping(base_command or p)
                        execute_mapping(command_after)
                    end
                end

                vim.keymap.set(scope, p, command, options)
            end
        end
    end
end

return {
    map = map,
    nmap = map 'n',
    imap = map 'i',
    vmap = map 'v',

    str_trim = function (str)
        local str_start = string.find(str, '[^ ]')
        local str_end = string.find(str, '[^ ] *$')
        return string.sub(str, str_start, str_end)
    end,

    str_trim_left = function (str)
        local str_start = string.find(str, '[^ ]')
        return string.sub(str, str_start)
    end,

    str_trim_right = function (str)
        local str_end = string.find(str, '[^ ] *$')
        return string.sub(str, 1, str_end)
    end,

    str_at = function (str, index)
        if index > string.len(str) then return nil end
        return string.sub(str, index, index)
    end,

    contains = function (list, value)
        for _, v in pairs(list) do
            if v == value then return true end
        end
        return false
    end,
}
