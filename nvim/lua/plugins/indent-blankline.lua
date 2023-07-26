-- Plugin: indent-blankline
-- url: https://github.com/lukas-reineke/indent-blankline.nvim

local status_ok, indent_blankline = pcall(require, 'indent_blankline')
if not status_ok then
  return
end

indent_blankline.setup {
  -- char = "",
  -- space_char_blankline = " ",
  show_current_context = true,
  -- show_current_context_start = false,
  filetype_exclude = {
    'lspinfo',
    'packer',
    'checkhealth',
    'help',
    'man',
    'dashboard',
    'git',
    'markdown',
    'text',
    'terminal',
    'NvimTree',
  },
  buftype_exclude = {
    'terminal',
    'nofile',
    'quickfix',
    'prompt',
  },
}

