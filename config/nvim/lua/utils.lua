vim.cmd("autocmd! BufWritePost utils.lua source %")

function map(scope)
    return function(pattern)
        return function(command)
            vim.keymap.set(scope, pattern, command, { noremap = true, silent = true })
        end
    end
end

function map_opt(scope)
    return function(pattern)
        return function(command)
            return function(options)
                vim.keymap.set(scope, pattern, command, options)
            end
        end
    end
end

return {
    map = map,
    nmap = map 'n',
    imap = map 'i',
    vmap = map 'v',
    map_opt = map_opt,

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

    str_at = function(str, index)
        if index > string.len(str) then return nil end
        return string.sub(str, index, index)
    end,
}
