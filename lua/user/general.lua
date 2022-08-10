local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local wk = require("which-key")

--Set statusbar
require('lualine').setup{
  tabline = {
    lualine_a = {'buffers'},
  },
  sections = {
    lualine_b = {{'diagnostics', sources={'nvim_lsp'}}, 'FugitiveHead'},
    lualine_c = {{'filename', path=1}, 'lsp_progress'},
  },
  inactive_sections = {
    lualine_c = {{'filename', path=1}},
  },
  extensions = {'fugitive', 'quickfix', 'nvim-tree'}
}

--Remap space as leader key
keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { hl = 'GitGutterAdd', text = '+' },
    change = { hl = 'GitGutterChange', text = '~' },
    delete = { hl = 'GitGutterDelete', text = '_' },
    topdelete = { hl = 'GitGutterDelete', text = '‾' },
    changedelete = { hl = 'GitGutterChange', text = '~' },
  },
}

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}
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

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
--    disable = {"python"},
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

-- LSP settings
local nvim_lsp = require 'lspconfig'
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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

  require'illuminate'.on_attach(client)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
-- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
local servers = { 'pyright', 'gopls', 'psalm'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end


-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
require('luasnip/loaders/from_vscode').load({ include = { 'python', 'go', 'php'} }) -- Load only python snippets
local luasnip = require 'luasnip'


-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- project
require("project_nvim").setup {}
require('telescope').load_extension('projects')

require("nvim-tree").setup({
  respect_buf_cwd = true,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true
  },
  filters = {
    dotfiles = true,
    custom = {'.git', 'venv', '__pycache__', 'vendor'},
  },
})

keymap('n', '<C-n>', [[<cmd>lua require('nvim-tree').toggle()<CR>]], opts)

-- clc
require("no-clc").setup({
	load_at_startup = true,
	cursorline = true,
	cursorcolumn = true
})

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


-- autopairs
require('nvim-autopairs').setup{}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))


-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
-- cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"

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
