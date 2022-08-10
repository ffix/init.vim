local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local wk = require("which-key")

--Remap space as leader key
keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


--Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

--Add leader shortcuts
wk.register({
  ["<leader>s"] = {
    f = {"<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>", "Find files"},
    b = {"<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", "Fuzzy find in current buffer"},
    h = {"<cmd>lua require('telescope.builtin').help_tags()<CR>", "Help tags"},
    t = {"<cmd>lua require('telescope.builtin').tags()<CR>", "Tags"},
    d = {"<cmd>lua require('telescope.builtin').grep_string()<CR>", "Grep a string"},
    p = {"<cmd>lua require('telescope.builtin').live_grep()<CR>", "Live grep"},
    o = {"<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>", "Tags only in current buffer"},
  },
 
  ['<leader><space>'] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Show opened buffers"},
  ['<C-b>'] = { "<cmd>lua require('telescope.builtin').oldfiles()<CR>", "Show old files"},
  ['<C-p>'] = { "<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>", "Find files"},

})


keymap('n', '<C-n>', [[<cmd>lua require('nvim-tree').toggle()<CR>]], opts)



-- Toggle to disable mouse mode and indentlines for easier paste
ToggleMouse = function()
  if vim.o.mouse == 'a' then
    vim.cmd[[IndentBlanklineDisable]]
    vim.wo.signcolumn='no'
    vim.o.mouse = 'v'
    vim.o.relativenumber = false
    vim.wo.number = false
    vim.o.list = false
    print("Mouse disabled")
  else
    vim.cmd[[IndentBlanklineEnable]]
    vim.wo.signcolumn='yes'
    vim.o.mouse = 'a'
    vim.o.relativenumber = true
    vim.wo.number = true
    vim.o.list = true
    print("Mouse enabled")
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
  s = {"<cmd>HopChar2<cr>", "Hop Char 2"},
  S = {"<cmd>HopWord<cr>", "Hop Word"},
})

local M = {}
M.lsp_mappings = function(bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

return M
