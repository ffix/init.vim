-- LSP settings
local M = {}

M.setup = function(lsp_mappings)
    local nvim_lsp = require "lspconfig"
    local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        lsp_mappings(bufnr)

        require("illuminate").on_attach(client)
    end

    -- nvim-cmp supports additional completion capabilities
    local cmp_lsp = require "cmp_nvim_lsp"
    local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Enable the following language servers
    -- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
    local servers = { "pyright", "psalm" }
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end

    nvim_lsp.gopls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            gopls = {
                buildFlags = { "-tags=integration" },
                gofumpt = true,
                usePlaceholders = true,
            },
        },
    }
    nvim_lsp.sumneko_lua.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    }
end

return M
