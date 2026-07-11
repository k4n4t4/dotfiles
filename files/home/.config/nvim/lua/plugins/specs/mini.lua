local enable_mini = true

return {
    {
        "nvim-mini/mini.files",
        enabled = enable_mini,
        event = "VeryLazy",
        config = function()
            local files = require("mini.files")
            files.setup()
            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    local b = args.data.buf_id
                    vim.keymap.set('n', '<CR>', function()
                        files.go_in { close_on_file = true }
                    end, { buffer = b, desc = 'Go in' })
                    vim.keymap.set('n', '<S-CR>', files.go_out, { buffer = b, desc = 'Go out' })
                    vim.keymap.set('n', '<Leader>e', files.close, { buffer = b, desc = 'Close' })
                    vim.keymap.set('n', '<ESC>', files.close, { buffer = b, desc = 'Close' })
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
        enabled = enable_mini,
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
        enabled = enable_mini,
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
    },
    {
        "nvim-mini/mini.ai",
        enabled = enable_mini,
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
        enabled = enable_mini,
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
        enabled = enable_mini,
        event = "User Ready",
        config = function()
            require("mini.git").setup()
        end,
    },
    {
        "nvim-mini/mini.pick",
        enabled = enable_mini,
        dependencies = {
            "nvim-mini/mini.extra"
        },
        event = "User Ready",
        config = function()
            local pick = require("mini.pick")
            local extra = require("mini.extra")

            pick.setup()
            vim.ui.select = pick.ui_select

            local set = vim.keymap.set

            -- all pickers
            set('n', '<leader>fp', function()
                local available_pickers = {}

                for name, func in pairs(pick.builtin) do
                    available_pickers[name] = func
                end

                for name, func in pairs(extra.pickers) do
                    available_pickers[name] = func
                end

                local picker_names = vim.tbl_keys(available_pickers)
                table.sort(picker_names)

                pick.start({
                    source = {
                        name = 'All Pickers',
                        items = picker_names,
                        choose = function(item)
                            vim.schedule(function()
                                available_pickers[item]()
                            end)
                        end,
                    },
                })
            end, { desc = "Select a Picker" })

            -- search pickers
            set('n', '<leader>ff', function()
                pick.builtin.files { tool = 'git' }
            end, { desc = 'Pick Files' })
            set('n', '<leader>fe', function()
                extra.pickers.explorer()
            end, { desc = 'Pick Files' })
            set('n', '<leader>fg', function()
                pick.builtin.grep_live { tool = 'git' }
            end, { desc = "Pick Live Grep" })
            set('n', '<leader>fr', function()
                extra.pickers.oldfiles()
            end, { desc = "Pick Oldfiles" })
            set('n', '<leader>fb', function()
                pick.builtin.buffers()
            end, { desc = "Pick Buffers" })
            set('n', '<leader>fh', function()
                pick.builtin.help()
            end, { desc = "Pick Help Tags" })
            set('n', '<leader>fk', function()
                extra.pickers.keymaps()
            end, { desc = "Pick Keymaps" })

            -- diagnostic and quickfix pickers
            set('n', '<leader>fq', function()
                extra.pickers.list { scope = 'quickfix' }
            end, { desc = "Pick Quickfix" })
            set('n', '<leader>fd', function()
                extra.pickers.diagnostic { scope = 'current' }
            end, { desc = "Pick Diagnostics (current)" })
            set('n', '<leader>fD', function()
                extra.pickers.diagnostic { scope = 'all' }
            end, { desc = "Pick Diagnostics (all)" })

            -- lsp pickers
            set('n', '<leader>fld', function()
                extra.pickers.lsp { scope = 'definition' }
            end, { desc = "Pick LSP Definition" })
            set('n', '<leader>flt', function()
                extra.pickers.lsp { scope = 'type_definition' }
            end, { desc = "Pick LSP Type Definition" })
            set('n', '<leader>flr', function()
                extra.pickers.lsp { scope = 'references' }
            end, { desc = "Pick LSP References" })
            set('n', '<leader>fli', function()
                extra.pickers.lsp { scope = 'implementation' }
            end, { desc = "Pick LSP Implementation" })
            set('n', '<leader>fo',  function()
                extra.pickers.lsp { scope = 'document_symbol' }
            end, { desc = "Pick LSP Document Symbols" })
        end,
    },
    {
        "nvim-mini/mini.notify",
        enabled = enable_mini,
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
        enabled = enable_mini,
        config = function()
            require('mini.icons').setup()
        end,
    },
    {
        "nvim-mini/mini.statusline",
        enabled = enable_mini,
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
        enabled = enable_mini,
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
        enabled = enable_mini,
        config = function()
            require('mini.sessions').setup()
        end,
    },
    {
        "nvim-mini/mini.base16",
        enabled = enable_mini,
        event = "User Ready",
        config = function()
            require('mini.base16').setup {
                palette = {
                    base00 = "#10101f",
                    base01 = "#2a2a2f",
                    base02 = "#40404f",
                    base03 = "#5a5a5f",
                    base04 = "#70707f",
                    base05 = "#a0a0b0",
                    base06 = "#b0b0c0",
                    base07 = "#c0c0d0",
                    base08 = "#c05050",
                    base09 = "#c07050",
                    base0A = "#c09000",
                    base0B = "#70c070",
                    base0C = "#50c090",
                    base0D = "#5090c0",
                    base0E = "#c090c0",
                    base0F = "#900000",
                },
                use_cterm = true,
            }
            require("utils.transparent").enable()
        end,
    },
    {
        "nvim-mini/mini.hipatterns",
        enabled = enable_mini,
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
}
