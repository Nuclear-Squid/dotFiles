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
  require 'plugins.pretty_ui',
  require 'plugins.neorg',
  require 'plugins.qol_extra',
  require 'plugins.cmp',
  -- require 'plugins.conform',
  require 'plugins.debug',
  require 'plugins.gitsigns',
  require 'plugins.lint',
  require 'plugins.lspconfig',
  require 'plugins.lualine',
  require 'plugins.suckless',
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.snacks',
  require 'plugins.mini',
  require 'plugins.sessions',
}
