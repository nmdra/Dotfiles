require('telescope').setup {
 defaults = {
    layout_config = {
      width = 0.75,
      prompt_position = "bottom",
      preview_cutoff = 120,
      horizontal = {mirror = false},
      vertical = {mirror = false}
    },
    find_command = {
      'rg', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'
    },
    prompt_prefix = " ",
    selection_caret = "❯ ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    file_sorter = require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
    path_display = {},
    winblend = 10,
    border = {},
    color_devicons = true,
    use_less = true,
    set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
  mappings = {
        i = {
          ["<C-n>"] = require('telescope.actions').move_selection_next,
          ["<C-p>"] = require('telescope.actions').move_selection_previous,
          ["<C-c>"] = require('telescope.actions').close,
          ["<C-j>"] = require('telescope.actions').cycle_history_next,
          ["<C-k>"] = require('telescope.actions').cycle_history_prev,
          -- ["<C-q>"] = require('telescope.actions').smart_send_to_qflist + actions.open_qflist,
          ["<CR>"] = require('telescope.actions').select_default,
        },
        n = {
          ["<C-n>"] = require('telescope.actions').move_selection_next,
          ["<C-p>"] = require('telescope.actions').move_selection_previous,
          -- ["<C-q>"] = require('telescope.actions').smart_send_to_qflist + actions.open_qflist,
     },
   }
 }
}
