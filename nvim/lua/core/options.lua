-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-- Default options are not included
-- See: https://neovim.io/doc/user/vim_diff.html
-- [2] Defaults - *nvim-defaults*

local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General{{{
-----------------------------------------------------------
opt.mouse = 'a'                       -- Enable mouse support
-- opt.mousemodel = 'extend'
opt.clipboard = 'unnamedplus'         -- Copy/paste to system clipboard
opt.swapfile = false                  -- Don't use swapfile
opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options
--}}}
-----------------------------------------------------------
-- Neovim UI{{{
-----------------------------------------------------------
opt.number = true           -- Show line number
opt.relativenumber = true   -- relativenumber
opt.showmatch = true        -- Highlight matching parenthesis
opt.foldmethod = 'marker'   -- Enable folding (default 'foldmarker')
--opt.colorcolumn = '80'      -- Line lenght marker at 80 columns
opt.splitright = true       -- Vertical split to the right
opt.splitbelow = true       -- Horizontal split to the bottom
opt.ignorecase = true       -- Ignore case letters when search
opt.smartcase = true        -- Ignore lowercase for the whole pattern
opt.linebreak = true        -- Wrap on word boundary
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.laststatus=3            -- Set global statusline
opt.cursorline= true        -- cursorline
opt.list = true
opt.listchars:append "space:⋅"
opt.winblend = 0
opt.pumblend = 0
-- opt.listchars:append "eol:"
--}}}
-----------------------------------------------------------
-- Tabs, indent{{{
-----------------------------------------------------------
opt.expandtab = true        -- Use spaces instead of tabs
opt.shiftwidth = 4          -- Shift 4 spaces when tab
opt.tabstop = 4             -- 1 tab == 4 spaces
opt.smartindent = true      -- Autoindent new lines
opt.showtabline = 2
--}}}

-----------------------------------------------------------
-- Memory, CPU{{{
-----------------------------------------------------------
opt.hidden = true           -- Enable background buffers
opt.history = 100           -- Remember N lines in history
opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240         -- Max column for syntax highlight
opt.updatetime = 400        -- ms to wait for trigger an event
opt.timeoutlen = 300        --
-- vim.opt.spell = true
opt.spelllang = { 'en','cjk' }
--}}}
-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append "sI"

-- Disable builtins plugins{{{
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "tutor_mode_plugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "remote_plugins",
  "spellfile_plugin",
  "matchit",
  "fzf",
  "matchparen"
}
--}}}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

