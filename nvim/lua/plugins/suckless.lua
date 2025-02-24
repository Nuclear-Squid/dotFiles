return {
  'fabi1cazenave/termopen.vim',
  {
    'fabi1cazenave/suckless.vim',
    init = function()
      vim.g.suckless_tmap = 1
      vim.g.suckless_mappings = {
        ['<M-[sen]>'] = 'SetTilingMode("[sdf]")',
        ['<M-[lrti]>'] = 'SelectWindow("[hjkl]")',
        ['<M-[LRTI]>'] = 'MoveWindow("[hjkl]")',
        ['<C-M-[lrti]>'] = 'ResizeWindow("[hjkl]")',
        ['<M-[oO]>'] = 'CreateWindow("[sv]")',
        ['<M-q>'] = 'CloseWindow("prout")',
        ['<M-Space>'] = 'TermOpen("zsh", "f")',
        ['<M-Backspace>'] = 'TermOpenRanger("yazi")',
        ['<M-[123456789]>'] = 'SelectTab([123456789])',
        ['<M-[€«»$%^&*#]>'] = 'MoveWindowToTab([123456789])',
        ['<C-M-[123456789]>'] = 'CopyWindowToTab([123456789])',
      }
    end,
  },
}
