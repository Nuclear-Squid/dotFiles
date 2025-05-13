local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- autoinstall if not present
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field

-- add Lazy to neovim’s runtime path
vim.opt.rtp:prepend(lazypath)
---@diagnostic disable-next-line: missing-fields
require('lazy').setup {

  {
    dir = '~/Code/nvim_plugins/nuisance.nvim',
    -- lazy = false,
    -- event = "BufReadPost",
    opts = {
      player = "paplay", -- options: paplay (default), pw-play, mpv
      max_sounds = 20, -- Limit the amount of sounds that can play at the same time
      sounds = {
        -- Add custom sound paths or lists of sounds for other events here
        -- For example, BufRead can play a random sound from a list
        BufReadPre = { path = '~/Code/dotFiles/Zelda chest opening ｜ Sound Effect.wav', volume = 100, delay = 8000, probability = 0.05 },
        -- CursorMovedI = { path = sound_dir .. "click.ogg", volume = 0-100 },
        -- InsertLeave = { path = sound_dir .. "toggle.ogg", volume = 0-100 },
        -- ExitPre = { path = sound_dir .. "exit.ogg", volume = 0-100 },
        -- BufWrite = { path = sound_dir .. "save.ogg", volume = 0-100 },
        -- TextChangedI = { path = '~/Code/dotFiles/Windows_XP_Error_sound_effect.wav', volume = 100 },
     },
    },
  },

  'neovim/nvim-lspconfig',

  require 'plugins.pretty_ui',
  require 'plugins.neorg',
  require 'plugins.qol_extra',
  -- require 'plugins.cmp',
  require 'plugins.blink',
  -- require 'plugins.conform',
  -- require 'plugins.debug',
  require 'plugins.gitsigns',
  -- require 'plugins.lint',
  -- require 'plugins.lspconfig',
  require 'plugins.lualine',
  require 'plugins.suckless',
  -- require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.snacks',
  require 'plugins.mini',
  -- require 'plugins.sessions',
}
