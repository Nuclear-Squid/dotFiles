return {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp' },
    root_markers = { 'compile_commands.json' }
    -- root_dir = function(fname)
    --   return util.root_pattern(
    --     '.clangd',
    --     '.clang-tidy',
    --     '.clang-format',
    --     'compile_commands.json',
    --     'compile_flags.txt',
    --     'configure.ac' -- AutoTools
    --   )(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    -- end,
}
