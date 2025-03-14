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
        ['<M-[aA]>'] = 'CreateWindow("[sv]")',
        ['<M-x>'] = 'CloseWindow("prout")',
        ['<M-Space>'] = 'TermOpen("fish", "f")',
        ['<M-Backspace>'] = 'TermOpenRanger("yazi")',
        ['<M-[qcopw]>'] = 'SelectTab([12345])',
        ['<M-[QCOPW]>'] = 'MoveWindowToTab([12345])',
        ['<C-M-[qcopw]>'] = 'CopyWindowToTab([12345])',
      }
    end,
  },
}
