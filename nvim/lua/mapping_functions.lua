local M = {}

local utils = require 'utils'

function M.bracket_group(opening_delim, closing_delim)
  return function()
    local current_line = vim.api.nvim_get_current_line()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    local left_of_cursor = ''
    local right_of_cursor = ''

    local left_no_space_chars = '({['
    local right_no_space_chars = ')}];,'

    local function no_space_char_at_pos(no_space_chars, str, pos)
      if math.abs(pos) > str:len() then
        return false
      end
      return no_space_chars:find('[' .. utils.str_at(str, pos) .. ']')
    end

    if col == current_line:len() then
      local index_last_space = current_line:find ' [^ ]*$'

      if index_last_space ~= nil then
        -- Motherfucking arrays start at 1
        left_of_cursor = current_line:sub(1, index_last_space)
        right_of_cursor = current_line:sub(index_last_space)
      else
        left_of_cursor = current_line
      end

      if no_space_char_at_pos(left_no_space_chars, left_of_cursor, -2) then
        left_of_cursor = left_of_cursor:sub(1, -2)
      end

      if no_space_char_at_pos(right_no_space_chars, right_of_cursor, 2) then
        right_of_cursor = right_of_cursor:sub(2)
      end

      left_of_cursor = left_of_cursor .. opening_delim
      right_of_cursor = closing_delim .. utils.str_trim_right(right_of_cursor)
    else
      left_of_cursor = current_line:sub(1, col) .. opening_delim
      right_of_cursor = closing_delim .. current_line:sub(col + 1)
    end

    local indentation = string.rep(' ', current_line:len() - utils.str_trim_left(current_line):len())

    local indentation_nouvelle_ligne = indentation .. string.rep(' ', vim.o.tabstop)

    vim.api.nvim_buf_set_lines(0, row - 1, row, true, {
      left_of_cursor,
      indentation_nouvelle_ligne,
      indentation .. utils.str_trim_right(right_of_cursor),
    })

    vim.api.nvim_win_set_cursor(0, { row + 1, indentation_nouvelle_ligne:len() })
  end
end

function M.replace_on_range()
  local start_line = unpack(vim.api.nvim_buf_get_mark(0, '['))
  local finish_line = unpack(vim.api.nvim_buf_get_mark(0, ']'))
  vim.api.nvim_feedkeys(string.format(':%d,%ds/', start_line, finish_line), 'n', false)
function M.replace_on_range(start, finish, cursor)
  vim.api.nvim_feedkeys(string.format(':%d,%ds/', start[1], finish[1]), 'n', false)
end

-- « Atta je réessaye »
function M.duplicate_and_comment(start_line, finish_line, cursor_line, cursor_col)
  local new_cursor_line = cursor_line + finish_line - start_line + 1
  local range = string.format('%d,%d ', start_line, finish_line)
function M.duplicate_and_comment(start, finish, cursor)
  local new_cursor_line = cursor[1] + finish[1] - start[1] + 1
  local range = string.format('%d,%d ', start[1], finish[1])

  vim.cmd(range .. 'yank')
  vim.cmd(range .. 'norm gcc')

  vim.api.nvim_win_set_cursor(0, { finish[1], 0 })
  vim.cmd 'put'
  vim.api.nvim_win_set_cursor(0, { new_cursor_line, cursor[2] })
end

-- La position du curseur est stoquée dans le marqueur '`'
function M.duplicate_and_comment_normal()
  local start_line = vim.api.nvim_buf_get_mark(0, '[')[1]
  local finish_line = vim.api.nvim_buf_get_mark(0, ']')[1]
  local cursor_line, cursor_col = unpack(vim.api.nvim_buf_get_mark(0, '`'))
  duplicate_and_comment(start_line, finish_line, cursor_line, cursor_col)
function M.make_text_object_cmd(fn)
    local set_opfunc = vim.fn[vim.api.nvim_exec2([[
        func s:set_opfunc(val)
            let &opfunc = a:val
        endfunc
        echon get(function('s:set_opfunc'), 'name')
    ]], { output = true })["output"]]

    return function()
        set_opfunc(function()
            local start  = vim.api.nvim_buf_get_mark(0, '[')
            local finish = vim.api.nvim_buf_get_mark(0, ']')
            local cursor = vim.api.nvim_buf_get_mark(0, '`')
            fn(start, finish, cursor)
        end)

        vim.api.nvim_feedkeys("m`g@", "n", false)
    end
end

function M.duplicate_and_comment_visual()
  local cursor_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  local visual_line = vim.fn.getpos('v')[2]
  if cursor_line < visual_line then
    duplicate_and_comment(cursor_line, visual_line, cursor_line, cursor_col)
  else
    duplicate_and_comment(visual_line, cursor_line, cursor_line, cursor_col)
  end
function M.make_visual_cmd(fn)
    return function()
        local start  = vim.api.nvim_win_get_cursor(0)
        local finish = vim.fn.getpos("v")
        finish = { finish[2], finish[1] }

        if start[1] > finish[1] then
            start, finish = finish, start
        elseif start[2] > finish[2] then
            start, finish = finish, start
        end

        fn(start, finish, start)
    end
end

return M
