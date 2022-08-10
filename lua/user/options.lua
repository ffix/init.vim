--Incremental live completion (note: this is now a default on master)
vim.o.inccommand = 'nosplit'

--Set highlight on search
vim.o.hlsearch = true

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Scroll margin
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
-- vim.o.updatetime = 750
vim.wo.signcolumn = 'yes'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
-- vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme gruvbox]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]] ,
  false
)

vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 2 spaces for a tab
vim.opt.expandtab = true

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'go',
  callback = function()
    vim.bo.expandtab = false
  end,
})

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- gutentags
vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/nvim/ctags/')
vim.g.gutentags_file_list_command = 'rg --files'
vim.g.gutentags_generate_on_new = true
vim.g.gutentags_generate_on_missing = true
vim.g.gutentags_generate_on_write = true
vim.g.gutentags_generate_on_empty_buffer = false

vim.g.gutentags_ctags_exclude = {
  '*.git', '*.svg', '*.hg',
  '*.json',
  '*.md',
}

vim.o.clipboard = 'unnamed,unnamedplus'
vim.o.relativenumber = true
vim.o.tabstop = 4

vim.o.listchars = 'tab:▸▸,trail:¬,nbsp:.,extends:❯,precedes:❮'
vim.o.list = true

-- spell
vim.o.spell = true
vim.o.spelllang = 'en_us,ru'

-- set window title
vim.api.nvim_exec(
  [[
  let my_asciictrl = nr2char(127)
  let my_unisubst = "␡"
  for i in range(1, 31)
    let my_asciictrl .= nr2char(i)
    let my_unisubst  .= nr2char(0x2400 + i, 1)
  endfor
  augroup termTitle
    au!
    autocmd BufEnter * let &titlestring = "vim " . tr(expand("%:t"), my_asciictrl, my_unisubst)
    autocmd BufEnter * set title
  augroup END
  ]],
  false
)
