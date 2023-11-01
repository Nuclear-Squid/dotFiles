local lspconfig = require 'lspconfig'
local options = { noremap = true, silent = true }
local capabilities = require 'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- local on_attach = function(_, buffer)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--         buffer = buffer,
--         callback = function()
--             vim.lsp.buf.format { async = false }
--         end
--     })
--     vim.api.nvim_buf_set_keymap(buffer, "n", "<Leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", options)
--     vim.api.nvim_buf_set_keymap(buffer, "n", "<Leader>d", "<cmd>lua vim.lsp.buf.declaration()<CR>", options)
--     vim.api.nvim_buf_set_keymap(buffer, "n", "<Leader>D", "<cmd>lua vim.lsp.buf.definition()<CR>", options)
--     vim.api.nvim_buf_set_keymap(buffer, "n", "<Leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", options)
--     vim.api.nvim_buf_set_keymap(buffer, "n", "<Leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", options)
--     vim.api.nvim_buf_set_keymap(buffer, "n", "<Leader>R", "<cmd>lua vim.lsp.buf.references()<CR>", options)
--     vim.api.nvim_buf_set_keymap(buffer, "n", "<Leader>f", "<cmd>lua vim.lsp.buf.format{async=true}<CR>", options)
-- end

require 'mason'.setup {
    pip = {
        upgrade_pip = true,
    }
}

local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
    ensure_enstaled = {
        "rust-analyzer"
    }
}
mason_lspconfig.setup_handlers {
    function(server_name)
        lspconfig[server_name].setup { capabilities = capabilities }
    end,
    ["rust-analyzer"] = function()
        require 'rust-tools'.setup {
            server = { capabilities = capabilities }
        }
    end,
}
