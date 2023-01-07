--   __________________________________________
--  /\                                         \
--  \_| La meilleure config neovim de tous les |
--    |  temps (parce que c'est la mienne et   |
--    |  que je suis parfaitement objectif).   |
--    |   _____________________________________|_
--     \_/_______________________________________/
-- 

vim.cmd("autocmd! BufWritePost plugins.lua source %")
vim.cmd [[
	source ~/.config/nvim/plugins.vim " Ancienne config
	source ~/.config/nvim/md_to_pdf.lua " md <3 <3 <3
]]

require("options")
require("mappings")
require("plugins")
