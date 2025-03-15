local nmap = require('mapping_functions').nmap

return {
  --  ────────────────────────────< Colorscheme >────────────────────────────
  -- I made this color theme, so it’s in my dotFiles repo. If you are seeing
  -- this and want to install it for yourself, fetch the plugin at
  -- `Nuclear-Squid/photon.nvim`
  { dir = '~/Code/nvim_plugins/photon.nvim',
    priority = 1000, -- Load this before all other plugins.
    init = function()
      vim.cmd.colorscheme 'photon'
    end,
  },

  --  ─────────────────────────< Fancy UI elements >─────────────────────────
  { "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },

  --  ───────────────────────< Pretty LSP diagnostic >───────────────────────
  { "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config {
        virtual_text = false,
        virtual_lines = {
          only_current_line = true,
          highlight_whole_line = true,
        },
      }
    end,
  },

  --  ──────────────────────────< Fancy comments >───────────────────────
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'LudoPinelli/comment-box.nvim',
    init = function()
      nmap '<leader>c' ':CBccline8<CR>'
      nmap '<leader>b' ':CBccbox<CR>'
    end,
  },
}
