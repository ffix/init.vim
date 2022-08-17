--Set statusbar
require('lualine').setup {
    tabline = {
        lualine_a = { 'buffers' },
    },
    sections = {
        lualine_b = { { 'diagnostics', sources = { 'nvim_lsp' } }, 'FugitiveHead' },
        lualine_c = { { 'filename', path = 1 }, 'lsp_progress' },
    },
    inactive_sections = {
        lualine_c = { { 'filename', path = 1 } },
    },
    extensions = { 'fugitive', 'quickfix' }
}

-- Gitsigns
require('gitsigns').setup {}

-- Telescope
local telescope = require('telescope')
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
        file_ignore_patterns = {
            "^vendor/"
        },
        -- initial_mode = "normal",
    },
}
telescope.load_extension('fzf')
-- telescope.load_extension('file_browser')
telescope.load_extension('ui-select')

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
        --    disable = {'python'},
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

-- luasnip setup

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require('luasnip/loaders/from_vscode').load({ include = { 'python', 'go', 'php' } }) -- Load only python snippets
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'
local cmp = require 'cmp'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        keyword_length = 2,
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    formatting = {
        format = lspkind.cmp_format {
            mode = 'symbol',
            maxwidth = 50,
        },
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    experimental = {
        ghost_text = true,
    },
}

-- project
require('project_nvim').setup {}
require('telescope').load_extension('projects')

require('nvim-tree').setup({
    respect_buf_cwd = true,
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = true
    },
    filters = {
        dotfiles = true,
        custom = { '.git', 'venv', '__pycache__', 'vendor' },
    },
})

-- indent blackline
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
}

-- autopairs
require('nvim-autopairs').setup {}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
