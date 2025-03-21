return {
    'folke/snacks.nvim',
    opts = {
        dashboard = {
            enabled = true,
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
                {
                    pane = 2,
                    icon = " ",
                    desc = "Browse Repo",
                    padding = 1,
                    key = "b",
                    action = function()
                        Snacks.gitbrowse()
                    end,
                },
                function()
                    local in_git = Snacks.git.get_root() ~= nil
                    local cmds = {
                        {
                            title = "Notifications",
                            cmd = "gh notify -s -a -n5",
                            action = function()
                                vim.ui.open("https://github.com/notifications")
                            end,
                            key = "n",
                            icon = " ",
                            height = 5,
                            enabled = true,
                        },
                        {
                            title = "Open Issues",
                            cmd = "gh issue list -L 3",
                            key = "i",
                            action = function()
                                vim.fn.jobstart("gh issue list --web", { detach = true })
                            end,
                            icon = " ",
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Open PRs",
                            cmd = "gh pr list -L 3",
                            key = "P",
                            action = function()
                                vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Git Status",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 10,
                        },
                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            pane = 2,
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                    end, cmds)
                end,
            },
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

        debug = {},
    },
}
