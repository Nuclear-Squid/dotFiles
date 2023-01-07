vim.cmd("autocmd! BufWritePost suckless.lua source %")

local set = vim.opt

vim.cmd [[
	let g:suckless_tmap = 1
	let g:suckless_mappings_ergol = {
	\        '<M-[snt]>'      :   'SetTilingMode("[sdf]")'    ,
	\        '<M-[hreo]>'     :    'SelectWindow("[hjkl]")'   ,
	\        '<M-[HREO]>'     :      'MoveWindow("[hjkl]")'   ,
	\      '<C-M-[hreo]>'     :    'ResizeWindow("[hjkl]")'   ,
	\        '<M-[pP]>'       :    'CreateWindow("[sv]")'     ,
	\        '<M-m>'          :     'CloseWindow()'           ,
	\        '<M-Return>'     :        'TermOpen()'           ,
	\        '<M-Backspace>'  :  'TermOpenRanger()'           ,
	\        '<M-[123456789]>':       'SelectTab([123456789])',
	\        '<M-[!@#$%^&*(]>': 'MoveWindowToTab([123456789])',
	\      '<C-M-[123456789]>': 'CopyWindowToTab([123456789])',
	\}
	let g:suckless_mappings_azerty = {
	\        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
	\        '<M-[hjkl]>'     :    'SelectWindow("[hjkl]")'   ,
	\        '<M-[HJKL]>'     :      'MoveWindow("[hjkl]")'   ,
	\      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
	\        '<M-[oO]>'       :    'CreateWindow("[sv]")'     ,
	\        '<M-w>'          :     'CloseWindow()'           ,
	\        '<M-Return>'     :        'TermOpen()'           ,
	\        '<M-Backspace>'  :  'TermOpenRanger()'           ,
	\        '<M-[&é"''(-è_ç]>':       'SelectTab([123456789])',
	\        '<M-[123456789]>': 'MoveWindowToTab([123456789])',
	\      '<C-M-[&é"''(-è_ç]>': 'CopyWindowToTab([123456789])',
	\}
	let g:suckless_mappings_qwerty = {
	\        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
	\        '<M-[hjkl]>'     :    'SelectWindow("[hjkl]")'   ,
	\        '<M-[HJKL]>'     :      'MoveWindow("[hjkl]")'   ,
	\      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
	\        '<M-[oO]>'       :    'CreateWindow("[sv]")'     ,
	\        '<M-w>'          :     'CloseWindow()'           ,
	\        '<M-Return>'     :        'TermOpen()'           ,
	\        '<M-Backspace>'  :  'TermOpenRanger()'           ,
	\        '<M-[123456789]>':       'SelectTab([123456789])',
	\        '<M-[!@#$%^&*(]>': 'MoveWindowToTab([123456789])',
	\      '<C-M-[123456789]>': 'CopyWindowToTab([123456789])',
	\}

	let g:suckless_mappings = g:suckless_mappings_ergol
	" let g:suckless_mappings = g:suckless_mappings_azerty
	" let g:suckless_mappings = g:suckless_mappings_qwerty
]]
