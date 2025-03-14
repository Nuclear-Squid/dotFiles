return {
    "echasnovski/mini.nvim",
    config = function()
        require('mini.ai').setup {}
        require('mini.splitjoin').setup {}
        require('mini.align').setup {}
        -- require('mini.clue').setup {}
        -- require('mini.jump').setup {}

        -- local jump2d = require('mini.jump2d')
        -- jump2d.setup {
        local jump2d = require('mini.jump2d')
        jump2d.setup {
            spotter = jump2d.gen_union_spotter(
                -- jump2d.gen_pattern_spotter('^%s*%S', 'end'),
                jump2d.gen_pattern_spotter('[~:=]+', 'start'),
                jump2d.gen_pattern_spotter('return', 'start'),
                jump2d.gen_pattern_spotter('function', 'start'),
                jump2d.gen_pattern_spotter('for', 'start'),
                jump2d.gen_pattern_spotter('if', 'start'),
                jump2d.gen_pattern_spotter('else', 'start'),
                jump2d.gen_pattern_spotter('match', 'start'),
                jump2d.gen_pattern_spotter('switch', 'start'),
                jump2d.gen_pattern_spotter('let', 'start'),
                jump2d.gen_pattern_spotter('local', 'start')
            ),

            view = {
                -- dim = true,
                n_steps_ahead = 2,
            },

            allowed_lines = {
                blank = false, -- Blank line (not sent to spotter even if `true`)
                cursor_before = true, -- Lines before cursor line
                cursor_at = false, -- Cursor line
                cursor_after = true, -- Lines after cursor line
                fold = true, -- Start of fold (not sent to spotter even if `true`)
            },

            allowed_windows = {
                current = true,
                not_current = false,
            },
        }
    end
}
