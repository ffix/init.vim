-- LSP settings
local M = {}

M.setup = function(lsp_mappings)
  local nvim_lsp = require 'lspconfig'
  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    lsp_mappings(bufnr)

    require'illuminate'.on_attach(client)
  end

  -- nvim-cmp supports additional completion capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  -- Enable the following language servers
  -- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
  local servers = { 'pyright', 'gopls', 'psalm', 'sumneko_lua' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end

return M
