--[[
This Configuration Based on Neovim-Lua by brainfucksec,
Website: https://github.com/brainfucksec/neovim-lua
--]]

-- Import Lua modules
require('core/lazy')
require('core/autocmds')
require('core/keymaps')
require('plugins/lualine') -- statusline config
require('core/options')
require('lsp/lspconfig')
require('plugins/nvim-tree')
require('plugins/nvim-cmp')
require('plugins/nvim-treesitter')
require('plugins/comment') --comment plugin
require('plugins/tokyonight')
vim.cmd[[colorscheme tokyonight]]

require('plugins/indent-blankline')
require('plugins/toggleterm')
