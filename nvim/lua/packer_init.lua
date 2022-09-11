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
  -- use 'Mofiqul/dracula.nvim'
  use 'navarasu/onedark.nvim'
  use 'folke/tokyonight.nvim'
  -- use 'tiagovla/tokyodark.nvim'
  -- use 'eddyekofo94/gruvbox-flat.nvim'
  --}}}

  -- lsp stuff  {{{
  -- nvim-lspconfig
  use {
    "neovim/nvim-lspconfig"
    -- event = "BufRead"
  }

  -- lsp icons
  use 'onsails/lspkind-nvim'

  -- use 'williamboman/nvim-lsp-installer'

  -- Autopair
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }

  -- use {
  --   'jose-elias-alvarez/null-ls.nvim',
  -- }
  --
  -- use 'nvim-lua/plenary.nvim'
  --}}}

  -- Treesitter {{{
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    -- event = 'BufRead',
    config = 'require("treesitter")'
  }

  use {
    'p00f/nvim-ts-rainbow',
    after = 'nvim-treesitter'
  }
  --}}}

  -- Autocomplete plugins {{{
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  -- use 'hrsh7th/cmp-cmdline'

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
          -- { name = 'cmdline' }
          -- more sources
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

  -- fzf-lua >> alternative to telescope
  use 'ibhagwan/fzf-lua'

  -- Icons
  use {
    'kyazdani42/nvim-web-devicons',
    event = 'BufRead'
  }

  -- vim-tmux vim-tmux-navigator >> easy navigation vim & tmux panes
  use 'christoomey/vim-tmux-navigator'

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    cmd = "NvimTreeToggle",
    config = "require('nvimtree')"
  }

  -- Indent line
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = "require('indent_blankline')",
    event = 'BufRead'
  }

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

  use {
    'NvChad/nvim-colorizer.lua',
    cmd = "ColorizerToggle",
    config = "require'colorizer'.setup()"
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
--}}}

  -- Using Packer
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
