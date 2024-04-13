vim.cmd("autocmd! BufWritePost suckless.lua source %")

local suckless_mappings_ergol = {
        ['<M-[sen]>']      =   'SetTilingMode("[sdf]")'    ,
        ['<M-[lrti]>']     =    'SelectWindow("[hjkl]")'   ,
        ['<M-[LRTI]>']     =      'MoveWindow("[hjkl]")'   ,
      ['<C-M-[lrti]>']     =    'ResizeWindow("[hjkl]")'   ,
        ['<M-[oO]>']       =    'CreateWindow("[sv]")'     ,
        ['<M-q>']          =     'CloseWindow("prout")'    ,
        ['<M-Space>']      =        'TermOpen("zsh", "f")' ,
        ['<M-Backspace>']  =  'TermOpenRanger()'           ,
        ['<M-[123456789]>']=       'SelectTab([123456789])',
        ['<M-[!@#$%^&*(]>']= 'MoveWindowToTab([123456789])',
      ['<C-M-[123456789]>']= 'CopyWindowToTab([123456789])',
}
local suckless_mappings_azerty = {
        ['<M-[sdf]>']      =   'SetTilingMode("[sdf]")'    ,
        ['<M-[hjkl]>']     =    'SelectWindow("[hjkl]")'   ,
        ['<M-[HJKL]>']     =      'MoveWindow("[hjkl]")'   ,
      ['<C-M-[hjkl]>']     =    'ResizeWindow("[hjkl]")'   ,
        ['<M-[oO]>']       =    'CreateWindow("[sv]")'     ,
        ['<M-w>']          =     'CloseWindow()'           ,
        ['<M-Return>']     =        'TermOpen()'           ,
        ['<M-Backspace>']  =  'TermOpenRanger()'           ,
        ['<M-[&é"\'(-è_ç]>']=       'SelectTab([123456789])',
        ['<M-[123456789]>']= 'MoveWindowToTab([123456789])',
      ['<C-M-[&é"\'(-è_ç]>']= 'CopyWindowToTab([123456789])',
}
local suckless_mappings_qwerty = {
        ['<M-[sdf]>']      =   'SetTilingMode("[sdf]")'    ,
        ['<M-[hjkl]>']     =    'SelectWindow("[hjkl]")'   ,
        ['<M-[HJKL]>']     =      'MoveWindow("[hjkl]")'   ,
      ['<C-M-[hjkl]>']     =    'ResizeWindow("[hjkl]")'   ,
        ['<M-[oO]>']       =    'CreateWindow("[sv]")'     ,
        ['<M-w>']          =     'CloseWindow()'           ,
        ['<M-Return>']     =        'TermOpen()'           ,
        ['<M-Backspace>']  =  'TermOpenRanger()'           ,
        ['<M-[123456789]>']=       'SelectTab([123456789])',
        ['<M-[!@#$%^&*(]>']= 'MoveWindowToTab([123456789])',
      ['<C-M-[123456789]>']= 'CopyWindowToTab([123456789])',
}

vim.g.suckless_mappings = suckless_mappings_ergol
-- vim.g.suckless_mappings = suckless_mappings_azerty
-- vim.g.suckless_mappings = suckless_mappings_qwerty

