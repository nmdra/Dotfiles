--[[
Name: init.lua
Catogary: Neovim Config
Dependencies: Neovim
Description:
Contributors: nimendra
Last Update: 2022-09-02 11:37
-------------------------------
> gitlab.com/nimendra_
> twitter.com/nimendra_
===============================
--]]

-- Import Lua modules

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

-- Themes

-- Onedark
-- require('plugins/onedark')
-- require('onedark').load()

-- tokyonight
require('plugins/tokyonight')
vim.cmd[[colorscheme tokyonight]]

