local nmap = require('mapping_functions').nmap

if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.6
  vim.g.neovide_padding_top = 5
  vim.g.neovide_padding_left = 5
  vim.g.neovide_cursor_unfocused_outline_width = 0.1

  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  vim.g.neovide_opacity = 0.95

  vim.g.neovide_scroll_animation_length = 0.33
  vim.g.neovide_scroll_animation_far_lines = 12
  vim.g.neovide_cursor_animation_length = 0.075

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_no_idle = false

  vim.g.neovide_cursor_vfx_mode = { 'railgun', 'ripple' }
  -- vim.g.neovide_cursor_vfx_mode = 'ripple'
  vim.g.neovide_cursor_vfx_opacity = 500
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.1
  vim.g.neovide_cursor_vfx_particle_density = 15
  vim.g.neovide_cursor_vfx_particle_speed = 20.0
  vim.g.neovide_cursor_vfx_particle_phase = 3
  vim.g.neovide_cursor_vfx_particle_curl = 3

  -- J’aimerai bien avoir ça en plus, mais c’est pas possible
  -- vim.g.neovide_cursor_vfx_mode = "ripple"

  nmap '<C-+>' (function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1 end)
  nmap '<C-->' (function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1 end)
end
