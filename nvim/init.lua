--[[
Name: init.lua
Contributors: nimendra
Last Update: 2022-10-09 19:58
-----------------------------
> github.com/NMDRA
> twitter.com/nimendra_
=============================
--]]

require('impatient') -- speedup neovim loading
require'impatient'.enable_profile() -- impatient report enable

require('core/options') --neovim options
require('packer_init') -- packer.nvim
require('core/autocmds') --AuotoCommands
require('core/keymaps') --Keymappings
require('plugins/nvim-cmp') -- neovim autocomplete
require('plugins/nvim-lspconfig') --LSP configuration
require('plugins/fzf-lua') -- fzf plugin written in lua
require('plugins/lualine') -- statusline config
require('plugins/other') --other configuration
require('plugins/neoscroll') -- smooth scrolling plugin
require('plugins/comment') --comment plugin
require('plugins/toggleterm') -- Terminal
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
-- Themes
-- Tokyonight
require('plugins/tokyonight')
vim.cmd[[colorscheme tokyonight]]

-- For Neovide
-- vim.opt.guifont = { "JetBrainsMono Nerd Font", "h13" }
