return {
    'folke/snacks.nvim',
    opts = {
        dashboard = {
            enabled = true,
        },

        -- dim = {
        --     enabled = false,
        --     scope = {
        --         min_size = 5,
        --         max_size = 20,
        --         siblings = true,
        --     },
        --     filter = function(buf)
        --         return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
        --     end,
        -- },

        indent = {
            enabled = false,
            char = "│",
            only_scope = false, -- only show indent guides of the scope
            only_current = false, -- only show indent guides in the current window
        },

        lazygit = {},

        image = {},

        scroll = {
            enabled = true,
            animate = {
                duration = { step = 15, total = 250 },
                easing = "outExpo",
            },
        },

        statuscolumn = {},

    },
}
