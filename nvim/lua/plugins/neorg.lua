return {
  --  ──────────────────────────< Neorg <3 <3 <3 >───────────────────────
  {
    "nvim-neorg/neorg",
    lazy = false,  -- Disable lazy loading (from neorg’s docs, dunno why)
    version = "*", -- Pin Neorg to the latest stable release
    dependencies = {
      -- "luarocks.nvim",
      "nvim-neorg/lua-utils.nvim",
      "pysan3/pathlib.nvim",
      -- "jbyuki/nabla.nvim",  -- Render math inside Neovim
    },

    config = function()
      require('neorg').setup {
        load = {
          ["core.defaults"] = {},  -- Loads the default behaviour
          ["core.concealer"] = {}, -- Loads the default behaviour
        },
      }
    end,
  },
}
