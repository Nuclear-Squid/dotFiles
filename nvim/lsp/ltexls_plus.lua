local language_id_mapping = {
  bib = 'bibtex',
  pandoc = 'markdown',
  plaintex = 'tex',
  rnoweb = 'rsweave',
  rst = 'restructuredtext',
  tex = 'latex',
  text = 'plaintext',
}

local function get_language_id(_, filetype)
  return language_id_mapping[filetype] or filetype
end

return {
  cmd = { 'ltex-ls-plus' },
  filetypes = {
    'bib',
    'context',
    'gitcommit',
    'html',
    'markdown',
    'org',
    'pandoc',
    'plaintex',
    'quarto',
    'mail',
    'mdx',
    'rmd',
    'rnoweb',
    'rst',
    'tex',
    'text',
    'typst',
    'xhtml',
  },
  root_dir = '/home/nuclear-squid/Code/Snorbi/sciduino_rapport/doc/polytech.grenoble-inp.fr/',
  -- root_dir = function(fname)
  --   return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  -- end,
  single_file_support = true,
  get_language_id = get_language_id,
  settings = {
    ltex = {
      enabled = {
        'bib',
        'context',
        'gitcommit',
        'html',
        'markdown',
        'org',
        'pandoc',
        'plaintex',
        'quarto',
        'mail',
        'mdx',
        'rmd',
        'rnoweb',
        'rst',
        'tex',
        'latex',
        'text',
        'typst',
        'xhtml',
      },
    },
  },
}
