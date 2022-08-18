require "user.plugins"
require "user.options"
require "user.general"

local mappings = require "user.mappings"
local lsp = require "user.lsp"

lsp.setup(mappings.lsp_mappings)
