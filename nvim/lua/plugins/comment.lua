require('Comment').setup{
    padding = true,
    sticky = true,
    ignore = '^$',
    toggler = {
        -- -Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },

    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
    },

    ---LHS of extra mappings
    ---@type table
    extra = {
        above = 'gcO',
        below = 'gco',
        eol = 'gcA',
    },

    mappings = {
        basic = true,
        extra = true,
        extended = false,
    },

    pre_hook = nil,

    post_hook = nil,
}
