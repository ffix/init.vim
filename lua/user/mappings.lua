local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local wk = require('which-key')

--Remap space as leader key
keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

--Add leader shortcuts
wk.register({
  ['<leader>s'] = {
    f = { '<cmd>Telescope find_files previewer=false<CR>', 'Find files' },
    b = { '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Fuzzy find in current buffer' },
    h = { '<cmd>Telescope help_tags<CR>', 'Help tags' },
    t = { '<cmd>Telescope tags<CR>', 'Tags' },
    d = { '<cmd>Telescope grep_string<CR>', 'Grep a string' },
    p = { '<cmd>Telescope live_grep<CR>', 'Live grep' },
    o = { '<cmd>Telescope current_buffer_tags<CR>', 'Tags only in current buffer' },
  },

  ['<leader><space>'] = { '<cmd>Telescope buffers<CR>', 'Show opened buffers' },
  ['<C-b>'] = { '<cmd>Telescope oldfiles<CR>', 'Show old files' },
  ['<C-p>'] = { '<cmd>Telescope find_files previewer=false<CR>', 'Find files' },

})

keymap('n', '<C-n>', [[<cmd>lua require('nvim-tree').toggle()<CR>]], opts)

-- Toggle to disable mouse mode and indentlines for easier paste
ToggleMouse = function()
  if vim.o.mouse == 'a' then
    vim.cmd [[IndentBlanklineDisable]]
    vim.wo.signcolumn = 'no'
    vim.o.mouse = 'v'
    vim.o.relativenumber = false
    vim.wo.number = false
    vim.o.list = false
    print('Mouse disabled')
  else
    vim.cmd [[IndentBlanklineEnable]]
    vim.wo.signcolumn = 'yes'
    vim.o.mouse = 'a'
    vim.o.relativenumber = true
    vim.wo.number = true
    vim.o.list = true
    print('Mouse enabled')
  end
end

keymap('n', '<F10>', '<cmd>lua ToggleMouse()<cr>', opts)

-- hard mode
vim.api.nvim_exec(
  [[
    nnoremap <buffer> <Left> <Nop>
    nnoremap <buffer> <Right> <Nop>
    nnoremap <buffer> <Up> <Nop>
    nnoremap <buffer> <Down> <Nop>
    nnoremap <buffer> <PageUp> <Nop>
    nnoremap <buffer> <PageDown> <Nop>

    inoremap <buffer> <Left> <Nop>
    inoremap <buffer> <Right> <Nop>
    inoremap <buffer> <Up> <Nop>
    inoremap <buffer> <Down> <Nop>
    inoremap <buffer> <PageUp> <Nop>
    inoremap <buffer> <PageDown> <Nop>

    vnoremap <buffer> <Left> <Nop>
    vnoremap <buffer> <Right> <Nop>
    vnoremap <buffer> <Up> <Nop>
    vnoremap <buffer> <Down> <Nop>
    vnoremap <buffer> <PageUp> <Nop>
    vnoremap <buffer> <PageDown> <Nop>

    vnoremap <buffer> - <Nop>
    vnoremap <buffer> + <Nop>

    nnoremap <buffer> - <Nop>
    nnoremap <buffer> + <Nop>
  ]],
  false
)
keymap('n', '<C-c><C-c>', [[<cmd>lua require('bufdelete').bufdelete(0, false)<CR>]], opts)

-- langmap
vim.api.nvim_exec(
  [[
    set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
  ]],
  false
)

-- Clear highlighting on escape in normal mode
keymap('n', '<Esc>', ':noh<CR><Esc>', opts)

wk.register({
  s = { '<cmd>HopChar2<cr>', 'Hop Char 2' },
  S = { '<cmd>HopWord<cr>', 'Hop Word' },
})

local M = {}
M.lsp_mappings = function(bufnr)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting_sync()' ]]
  vim.api.nvim_set_keymap('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  wk.register({
    g = {
      d = { '<cmd>Telescope lsp_definitions show_line=false<CR>', 'Go to definition' },
      D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to declaration' },
      i = { '<cmd>Telescope lsp_implementations show_line=false<CR>', 'Show implementation' },
      r = { '<cmd>Telescope lsp_references show_line=false<CR>', 'Show references' },
    },
    ['<leader>l'] = {
      name = 'Lsp',
      a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action' },
      r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
      f = { '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', 'Format' },
      s = { '<cmd>Telescope lsp_document_symbols show_line=false<CR>', 'Document Symbols' },
      S = { '<cmd>Telescope lsp_workspace_symbols show_line=false<CR>', 'Workspace Symbols' },
      h = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help' },
    },
    K = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Documentation' },
  }, { buffer = bufnr })
end

return M
