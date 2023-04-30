-- packer {{{
-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

-- Autocommand that reloads neovim whenever you save the packer_init.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer_init.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end --}}}

-- Install plugins
return packer.startup(function(use)
-- Add you plugins here:
use 'wbthomason/packer.nvim' -- packer can manage itself

-- Is using a standard Neovim install, i.e. built from source or using a
-- provided appimage.
use 'lewis6991/impatient.nvim'

-- colorschemes {{{
use 'folke/tokyonight.nvim'
--}}}

-- lsp stuff  {{{
-- nvim-lspconfig
use {
  "neovim/nvim-lspconfig"
  -- event = "BufRead"
}

-- lsp icons
use 'onsails/lspkind-nvim'

-- Autopair
use {
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup()
  end
}

-- }}}

-- Treesitter {{{
use {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  -- event = 'BufRead',
  config = 'require("plugins/treesitter")'
}

use {
  'mrjones2014/nvim-ts-rainbow',
  after = 'nvim-treesitter'
}
--}}}

-- Autocomplete plugins {{{
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-path'
use 'hrsh7th/cmp-buffer'

use 'L3MON4D3/LuaSnip'
use {
  'hrsh7th/nvim-cmp',
  config = function()
    require 'cmp'.setup {
      snippet = {
        expand = function(args)
          require 'luasnip'.lsp_expand(args.body)
        end
      },

      sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' }
      },
    }
  end
}
use 'saadparwaiz1/cmp_luasnip'

use "rafamadriz/friendly-snippets"
--}}}

-- UI & Other Plugins {{{
-- nvim-lualine
use 'nvim-lualine/lualine.nvim'

use { 'ibhagwan/fzf-lua',
  -- optional for icon support
  requires = { 'kyazdani42/nvim-web-devicons' }
}

use 'RRethy/vim-illuminate'

-- Icons
use {
  'kyazdani42/nvim-web-devicons',
  event = 'BufRead'
}

-- vim-tmux vim-tmux-navigator >> easy navigation vim & tmux panes
-- use 'christoomey/vim-tmux-navigator'
use({
  "aserowy/tmux.nvim",
  config = function()
      require("tmux").setup({
          copy_sync = {
              -- enables copy sync and overwrites all register actions to
              -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
              enable = true,
          },
          navigation = {
              -- enables default keybindings (C-hjkl) for normal mode
              enable_default_keybindings = true,
          },
          resize = {
              -- enables default keybindings (A-hjkl) for normal mode
              enable_default_keybindings = true,
          }
      })
  end
})

-- File explorer
use {
  'kyazdani42/nvim-tree.lua',
  cmd = "NvimTreeToggle",
  config = "require('plugins/nvimtree')"
}

-- Indent line
use 'lukas-reineke/indent-blankline.nvim'

-- neoscroll >> smooth scrolling plugin
use 'karb94/neoscroll.nvim'

-- Comment.nvim >> Comment plugin
use 'numToStr/Comment.nvim'

-- toggleterm >> Terminal Plugin
use {
  "akinsho/toggleterm.nvim",
  tag = 'v2.*',
  config = "require('plugins/toggleterm')"
}

-- use {
--   'NvChad/nvim-colorizer.lua',
--   cmd = "ColorizerToggle",
--   config = "require'colorizer'.setup()"
-- }

use {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup()
  end
}

use {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup()
  end,
}

  --}}}

  -- Using Packer
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
