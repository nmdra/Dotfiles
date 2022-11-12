-- Language servers{{{
require'lspconfig'.pyright.setup{
  capabilities = capabilities
}
require'lspconfig'.bashls.setup{
  capabilities = capabilities
}

require'lspconfig'.sumneko_lua.setup{
  capabilities = capabilities,
  cmd = {'/bin/lua-language-server'}
}
require'lspconfig'.emmet_ls.setup{
  capabilities = capabilities
}

require'lspconfig'.clangd.setup{
  capabilities = capabilities
}
--}}}
