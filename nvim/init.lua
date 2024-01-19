--[[
This Configuration Based on Neovim-Lua by brainfucksec,
Website: https://github.com/brainfucksec/neovim-lua
--]]

require('core/lazy')

if vim.g.vscode then
  -- VSCode extension
  require('core/options')
  require('core/autocmds')
  require('core/keymaps')
else
  -- ordinary Neovim
  -- Import Lua modules
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
end
