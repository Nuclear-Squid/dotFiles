vim.cmd("autocmd! BufWritePost treesitter.lua source %")

local treesitter_dir = "/home/leo/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
require('nvim-treesitter.configs').setup {
	parser_install_dir = treesitter_dir,
	ensure_installed = { "rust", "c", "ocaml" },
	highlight = { enable = true },
}

vim.opt.runtimepath:append(treesitter_dir)
