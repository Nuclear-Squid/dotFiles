--------------------------------
-- auto-completion (nvim-cmp) --
--------------------------------
local cmp = require('cmp')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
    }),

    snippet = {
        expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
    },

    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            end
        end, { "i", "s" }),

        ['<CR>'] = cmp.mapping(function(fallback)
            if vim.fn["vsnip#jumpable"](1) == 1 then
                feedkey("<Plug>(vsnip-jump-next)", "")
            elseif cmp.visible() then
                cmp.confirm { select = true }
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-CR>'] = cmp.mapping(function(fallback)
            if vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            else
                fallback()
            end
        end, { 'i', 's'}),

        --   ['<C-f>']     = cmp.mapping(cmp.mapping.scroll_docs(4),  { 'i', 'c' }),
        --   ['<C-b>']     = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        --   ['<C-f>']     = cmp.mapping(cmp.mapping.scroll_docs(4),  { 'i', 'c' }),
          -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(),      { 'i', 'c' }),
        --   ['<C-y>']     = cmp.config.disable, --  remove the default `<C-y>` mapping
        --   ['<C-e>']     = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    },
})

------------------------------------------------------------------------------------------
-- LSP activation: call 'setup' on multiple servers                                     --
-- and add local keybindings and snippet capabilities when the language server attaches --
------------------------------------------------------------------------------------------
local lsp_servers = { 'clangd', 'pylsp' } -- see also: null-ls
local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local mappings = require("mappings.telescope")
for _, lsp in ipairs(lsp_servers) do
    nvim_lsp[lsp].setup({
        on_attach = mappings,
        flags = {
            debounce_text_changes = 150,
        },
        capabilities = capabilities,
    })
end
