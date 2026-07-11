return {
    {
        "nvim-mini/mini.files",
        event = "VeryLazy",
        config = function()
            local files = require("mini.files")
            files.setup()
            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    local b = args.data.buf_id
                    vim.keymap.set('n', '<CR>', files.go_in, { buffer = b, desc = 'Go in' })
                    vim.keymap.set('n', '<S-CR>', files.go_out, { buffer = b, desc = 'Go out' })
                    vim.keymap.set('n', '<Leader>e', files.close, { buffer = b, desc = 'Close' })
                end,
            })
        end,
        keys = {
            {
                mode = 'n',
                '<Leader>e',
                '<CMD>lua MiniFiles.open()<CR>',
                desc = 'MiniFiles toggle'
            },
        },
    },
    {
        "nvim-mini/mini.surround",
        event = "VeryLazy",
        config = function()
            local surround = require("mini.surround")

            local prefix = 'y'
            surround.setup {
                mappings = {
                    add = prefix .. 's',
                    delete = prefix .. 'd',
                    find = prefix .. 'f',
                    find_left = prefix .. 'F',
                    highlight = prefix .. 'h',
                    replace = prefix .. 'r',
                    suffix_last = '',
                    suffix_next = '',
                },
            }
            vim.keymap.del('x', 'ys')
            vim.keymap.del('x', 'yf')
            vim.keymap.del('x', 'yF')
            vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
        end,
    },
    {
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
    },
    {
        "nvim-mini/mini.ai",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                dependencies = { "nvim-treesitter/nvim-treesitter" },
            },
        },
        event = "VeryLazy",
        config = function()
            local ai = require("mini.ai")
            local spec_treesitter = ai.gen_spec.treesitter
            ai.setup {
                custom_textobjects = {
                    f = spec_treesitter { a = "@function.outer", i = "@function.inner" },
                    c = spec_treesitter { a = "@class.outer", i = "@class.inner" },
                    b = spec_treesitter { a = "@block.outer", i = "@block.inner" },
                    a = spec_treesitter { a = "@parameter.outer", i = "@parameter.inner" },
                    o = spec_treesitter {
                        a = { "@conditional.outer", "@loop.outer" },
                        i = { "@conditional.inner", "@loop.inner" },
                    },
                },
            }
        end,
    },
    {
        "nvim-mini/mini.diff",
        event = "User Ready",
        config = function()
            require("mini.diff").setup {
                view = {
                    style = "sign",
                    signs = {
                        add = "┃",
                        change = "┃",
                        delete = "_",
                    },
                    priority = 6,
                },
            }
        end,
    },
    {
        "nvim-mini/mini-git",
        event = "User Ready",
        config = function()
            require("mini.git").setup()
        end,
    },
    {
        "nvim-mini/mini.pick",
        event = "User Ready",
        config = function()
            local pick = require("mini.pick")
            pick.setup()
            vim.ui.select = pick.ui_select
            vim.keymap.set('n', '<space>ff', function()
                pick.builtin.files({ tool = 'git' })
            end, { desc = 'mini.pick.files' })
        end,
    },
    {
        "nvim-mini/mini.notify",
        event = "User Ready",
        config = function()
            local notify = require("mini.notify")

            notify.setup {
                lsp_progress = {
                    enable = true,
                },
            }

            vim.notify = notify.make_notify()
        end,
    },
    {
        "nvim-mini/mini.icons",
        config = function()
            require('mini.icons').setup()
        end,
    },
    {
        "nvim-mini/mini.statusline",
        event = "VeryLazy",
        config = function()
            local statusline = require("mini.statusline")
            statusline.setup({
                content = {
                    active = function()
                        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
                        local filename = vim.fn.expand("%:t")
                        local git = statusline.section_git({ trunc_width = 40 })
                        local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        local lsp = #clients > 0 and (" " .. #clients) or ""
                        local search = statusline.section_searchcount({
                            trunc_width = 75,
                            options = { recompute = false },
                        })
                        local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
                        local location = statusline.section_location({ trunc_width = 75 })
                        local recording = vim.fn.reg_recording()
                        if recording ~= "" then
                            recording = "󰑋 " .. recording
                        end

                        return statusline.combine_groups({
                            { hl = mode_hl, strings = { mode } },
                            {
                                hl = "MiniStatuslineDevinfo",
                                strings = {
                                    git,
                                    diagnostics,
                                },
                            },
                            "%<",
                            {
                                hl = "MiniStatuslineFilename",
                                strings = {
                                    filename,
                                },
                            },
                            "%=",
                            {
                                hl = "MiniStatuslineFileinfo",
                                strings = {
                                    recording,
                                    lsp,
                                    search,
                                    fileinfo,
                                },
                            },
                            {
                                hl = mode_hl,
                                strings = {
                                    location,
                                },
                            },
                        })
                    end,
                },
            })
            vim.opt.laststatus = 3
            vim.opt.cmdheight = 0
        end,
    },
    {
        "nvim-mini/mini.tabline",
        event = "VeryLazy",
        config = function()
            require('mini.tabline').setup()
            local set = vim.keymap.set

            set("n", "<M-n>", "<Cmd>enew<CR>", { desc = "New buffer" })
            set("n", "<M-j>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
            set("n", "<M-k>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
            set("n", "<M-x>", "<Cmd>bdelete<CR>", { desc = "Delete buffer" })

            set("n", "<M-t>", "<Cmd>tabnew<CR>", { desc = "New tabpage" })
            set("n", "<M-h>", "<Cmd>tabprevious<CR>", { desc = "Previous tabpage" })
            set("n", "<M-l>", "<Cmd>tabnext<CR>", { desc = "Next tabpage" })
            set("n", "<M-S-x>", "<Cmd>tabclose<CR>", { desc = "Close tabpage" })
        end,
    },
    {
        "nvim-mini/mini.sessions",
        config = function()
            require('mini.sessions').setup()
        end,
    },
    {
        "nvim-mini/mini.base16",
        event = "User Ready",
        config = function()
            require('mini.base16').setup {
                palette = {
                    base00 = '#101030',
                    base01 = '#202040',
                    base02 = '#404060',
                    base03 = '#9090A0',
                    base04 = '#d5dc81',
                    base05 = '#e2e98f',
                    base06 = '#eff69c',
                    base07 = '#fcffaa',
                    base08 = '#ffcfa0',
                    base09 = '#cc7e46',
                    base0A = '#46a436',
                    base0B = '#9ff895',
                    base0C = '#ca6ecf',
                    base0D = '#42f7ff',
                    base0E = '#ffc4ff',
                    base0F = '#00a5c5',
                },
                use_cterm = true,
            }
            require("utils.transparent").enable()
        end,
    },
    {
        "nvim-mini/mini.hipatterns",
        dependencies = {
            "nvim-mini/mini.extra"
        },
        event = "User Ready",
        config = function()
            local hipatterns = require('mini.hipatterns')
            local hi_words = require('mini.extra').gen_highlighter.words
            hipatterns.setup({
                highlighters = {
                    fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
                    hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
                    todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
                    note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },
    {
        "nvim-mini/mini.clue",
        event = "User Ready",
        config = function()
            local function mode_nx(keys)
                return { mode = 'n', keys = keys }, { mode = 'x', keys = keys }
            end
            local clue = require('mini.clue')
            clue.setup({
                triggers = {
                    -- Leader triggers
                    mode_nx('<leader>'),

                    -- Built-in completion
                    { mode = 'i', keys = '<c-x>' },

                    -- `g` key
                    mode_nx('g'),

                    -- Marks
                    mode_nx("'"),
                    mode_nx('`'),

                    -- Registers
                    mode_nx('"'),
                    { mode = 'i', keys = '<c-r>' },
                    { mode = 'c', keys = '<c-r>' },

                    -- Window commands
                    { mode = 'n', keys = '<c-w>' },

                    -- bracketed commands
                    { mode = 'n', keys = '[' },
                    { mode = 'n', keys = ']' },

                    -- `z` key
                    mode_nx('z'),

                    -- surround
                    mode_nx('s'),

                    -- text object
                    { mode = 'x', keys = 'i' },
                    { mode = 'x', keys = 'a' },
                    { mode = 'o', keys = 'i' },
                    { mode = 'o', keys = 'a' },

                    -- option toggle (mini.basics)
                    { mode = 'n', keys = 'm' },
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    clue.gen_clues.builtin_completion(),
                    clue.gen_clues.g(),
                    clue.gen_clues.marks(),
                    clue.gen_clues.registers({ show_contents = true }),
                    clue.gen_clues.windows({ submode_resize = true, submode_move = true }),
                    clue.gen_clues.z(),
                },
            })
        end,
    },
}
