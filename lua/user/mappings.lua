local opts   = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Search
keymap('n', '<leader>sf', '<cmd>Telescope find_files previewer=false<cr>', opts)
keymap('n', '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', opts)
keymap('n', '<leader>sg', '<cmd>Telescope grep_string<cr>', opts)
keymap('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', opts)
keymap('n', '<leader>sh', '<cmd>Telescope help_tags<CR>', opts)
keymap('n', '<leader>st', '<cmd>Telescope tags<CR>', opts)
keymap('n', '<leader>sp', '<cmd>Telescope live_grep<CR>', opts)
keymap('n', '<leader>so', '<cmd>Telescope current_buffer_tags<CR>', opts)
-- Quickfix
keymap('n', '<leader>qf', '<cmd>Telescope quickfix<CR>', opts)
keymap('n', '<leader>qh', '<cmd>Telescope quickfixhistory<CR>', opts)
-- Resume
keymap('n', '<leader>r', '<cmd>Telescope resume<CR>', opts)
-- Files
keymap('n', '<leader><space>', '<cmd>Telescope buffers<CR>', opts)
keymap('n', '<C-b>', '<cmd>Telescope oldfiles<CR>', opts)
keymap('n', '<C-p>', '<cmd>Telescope find_files previewer=false<CR>', opts)
-- File tree
keymap('n', '<leader>tr', '<cmd>NvimTreeRefresh<CR>', opts)
keymap('n', '<leader>tf', '<cmd>NvimTreeFindFile<CR>', opts)
keymap('n', '<leader>tc', '<cmd>NvimTreeCollapse<CR>', opts)
keymap('n', '<leader>tt', '<cmd>NvimTreeToggle<CR>', opts)

keymap('n', '<leader>c', '<cmd>Bdelete<CR>', opts)



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

-- langmap
vim.cmd [[
    set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
]]

-- Clear highlighting on escape in normal mode
keymap('n', '<Esc>', ':noh<CR><Esc>', opts)

keymap('', 's', '<cmd>HopWord<cr>', opts)
keymap('', 'f',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
    , opts)
keymap('', 'F',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
    , opts)
keymap('', 't',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
    , opts)
keymap('', 'T',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>"
    , opts)


-- Move text up and down
-- keymap('n', '<A-j>', '<cmd>m .+1<CR>==', opts)
-- keymap('n', '<A-k>', '<cmd>m .-2<CR>==', opts)
-- keymap('v', '<A-j>', "<cmd>m '>+1<CR>gv=gv", opts)
-- keymap('v', '<A-k>', "<cmd>m '<-2<CR>gv==gv", opts)

vim.cmd [[
    nnoremap <A-k> :m .-2<CR>==
    nnoremap <A-j> :m .+1<CR>==
    vnoremap <A-k> :m '<-2<CR>gv=gv
    vnoremap <A-j> :m '>+1<CR>gv=gv
]]

-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

local M = {}
M.lsp_mappings = function(bufnr)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting_sync()' ]]
    keymap('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- Lsp
    keymap('n', 'gd', '<cmd>Telescope lsp_definitions show_line=false<CR>', opts)
    keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    keymap('n', 'gi', '<cmd>Telescope lsp_implementations show_line=false<CR>', opts)
    keymap('n', 'gr', '<cmd>Telescope lsp_references show_line=false<CR>', opts)
    keymap('n', 'gt', '<cmd>Telescope lsp_type_definitions show_line=false<CR>', opts)

    keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)
    keymap('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols show_line=false<CR>', opts)
    keymap('n', '<leader>lS', '<cmd>Telescope lsp_workspace_symbols show_line=false<CR>', opts)
    keymap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

end

return M
