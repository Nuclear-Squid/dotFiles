vim.cmd [[
	autocmd! BufWritePost md_to_pdf.lua source %
]]

vim.g.md_converter = "~/Code/dotFiles/config/nvim/md_pdf_converter.sh"

vim.api.nvim_create_user_command(
    'Render',
    function(opts)
		vim.cmd(string.format(":!%s %s %s",
				vim.g.md_converter,
				vim.api.nvim_buf_get_name(0),
				opts.args
		))
    end,
    { nargs = 1 }
)

vim.api.nvim_create_user_command(
	'Preview',
	function(opts)
		vim.api.nvim_create_autocmd(
			'BufWritePost', {
				pattern = vim.api.nvim_buf_get_name(0),
				command = string.format(":silent !%s %s %s",
					vim.g.md_converter,
					vim.api.nvim_buf_get_name(0),
					opts.args
				)
			}
		)
		vim.cmd(":!mupdf "..opts.args.." &")
	end,
	{ nargs = 1 }
)
