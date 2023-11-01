vim.cmd("autocmd! BufWritePost telescope.lua source %")

local utils    = require "utils"
local nmap     = utils.nmap
local  map_opt = utils. map_opt

-- LSP buffer-specific options and keymaps --
local telescope = require('telescope.builtin')
nmap '<leader>f' (telescope.find_files)
nmap '<leader>g' (telescope.git_files)
nmap '<leader>G' (telescope.live_grep)
nmap '<leader>H' (telescope.help_tags)
nmap '<leader>b' (telescope.buffers)
nmap '<leader>m' (telescope.keymaps)

return function(_client, bufnr)
    local telescope = require('telescope.builtin')
    local opts = { buffer=bufnr, noremap=true, silent=true }
    map_opt  'n'       'K'        (vim.lsp.buf.hover)          (opts)
    map_opt  'n'       '<C-k>'    (vim.lsp.buf.signature_help) (opts)
    map_opt  'n'       'gA'       (vim.lsp.buf.code_action)    (opts) -- {apply=true}
    map_opt  'n'       'gR'       (vim.lsp.buf.rename)         (opts)
    map_opt {'n', 'v'} 'g='       (vim.lsp.buf.format)         (opts)
    map_opt  'n'       'gi'       (vim.lsp.buf.implementation) (opts)
    map_opt  'n'       '[<Enter>' (vim.diagnostic.goto_prev)   (opts)
    map_opt  'n'       ']<Enter>' (vim.diagnostic.goto_next)   (opts)
    -- SP reference, Ls definitions and diagnostics are handled by Telescope
    map_opt  'n'       'gr'       (telescope.lsp_references)   (opts)
    map_opt  'n'       'gd'       (telescope.lsp_definitions)  (opts)
    map_opt  'n'       'gD'       (telescope.diagnostics)      (opts)
    -- source/header switch (should be restricted to clangd))
    map_opt  'n'       'gh' ':ClangdSwitchSourceHeader<CR>'  (opts)
    -- enable completion triggered by <c-x><c-o> (and nvim-cmp))
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end
