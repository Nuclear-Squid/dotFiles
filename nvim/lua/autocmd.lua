-- Save when leaving insert mode, unless the file has no name.
local autocmd = vim.api.nvim_create_autocmd

autocmd('InsertLeave', {
    pattern = '*',
    callback = function()
        if vim.api.nvim_buf_get_name(0) ~= "" then
            vim.cmd ':w'
        end
    end,
})

-- Disable folding in Telescope's result window.
autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
})


autocmd("BufReadPost", {
    desc = 'Restore cursor to file position in previous editing session',
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"zz')
        end
    end,
})

-- autocmd("BufWinEnter", {
--     desc = "Folds everything except what’s under the cursor when opening a new file",
--     callback = function()
--         vim.cmd('normal zMzvzczAzz')
--     end,
-- })

-- Show cursorline only on active windows
autocmd({ "InsertLeave", "WinEnter" }, {
    callback = function()
        if vim.w.auto_cursorline then
            vim.wo.cursorline = true
            vim.w.auto_cursorline = false
        end
    end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
    callback = function()
        if vim.wo.cursorline then
            vim.w.auto_cursorline = true
            vim.wo.cursorline = false
        end
    end,
})
