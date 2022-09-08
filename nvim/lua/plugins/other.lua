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
-- colorscheme setup{{{
-- Dracula.nvim
vim.g.dracula_italic_comment = true
vim.g.dracula_transparent_bg = false
-- Do not source the default filetype.vim
-- vim.g.did_load_filetypes = 1 -- filetype.nvim

-- -- Example config in Lua
-- vim.g.gruvbox_italic_functions = true
-- vim.g.gruvbox_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- Change the "hint" color to the "orange" color, and make the "error" color bright red
-- vim.g.gruvbox_colors = { hint = "orange", error = "#ff0000" }

-- Change the TabLineSel highlight group (used by barbar.nvim) to the "orange" color
-- vim.g.gruvbox_theme = { TabLineSel = { bg = "orange" } }

-- Load the colorscheme
-- vim.cmd[[colorscheme gruvbox-flat]]

-- vim.g.gruvbox_dark_float = true
-- vim.g.gruvbox_flat_style = "dark"
-- vim.g.gruvbox_dark_sidebar = true

-- vim.g.gruvbox_hide_inactive_statusline = true}}}
-- filetype.lua{{{
vim.filetype.add({
    -- extension = {
    --     foo = "fooscript",
    -- },
    filename = {
        ["lfrc"] = "sh",
    },
--     pattern = {
--         ["~/%.config/foo/.*"] = "fooscript",
--     }
})
--}}}
