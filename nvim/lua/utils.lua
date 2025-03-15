vim.cmd("autocmd! BufWritePost utils.lua source %")

function table.removeKey(list, key)
    local value = list[key]
    list[key] = nil
    return value
end


return {
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
