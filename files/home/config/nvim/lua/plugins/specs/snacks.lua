return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = {
                enabled = true,
                preset = require("plugins.config.snacks.dashboard").preset,
            },
            explorer = {
                enabled = true,
                layout = { auto_hide = { "input" } },
            },
            indent = { enabled = true },
            input = { enabled = true },
            image = {
                enabled = true,
                math = {
                    enabled = true,
                    latex = {
                        font_size = "normalsize",
                        packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
                    },
                },
                doc = {
                    enabled = true,
                    inline = true,
                    float = true,
                },
            },
            picker = {
                enabled = true,
                ui_select = true,
                hidden = true,
                ignored = false,
                sources = {
                    matcher = { frecency = true, cwd_bonus = true, sort_empty = true },
                    grep = { hidden = true, regex = true },
                    explorer = { layout = require("plugins.config.snacks.picker_layout").explorer_layout },
                    select = { layout = require("plugins.config.snacks.picker_layout").select_layout },
                },
                layout = require("plugins.config.snacks.picker_layout").layout,
                win = {
                    preview = { wo = { winblend = 0 } },
                },
            },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = {
                enabled = true,
                left = { "mark", "sign" },
                right = { "fold", "git" },
                folds = {
                    open = true,
                    git_hl = true,
                },
            },
            words = { enabled = true },
            styles = {
                notification = {
                    border = "single",
                },
                float = {
                    border = "single",
                    backdrop = false,
                },
            },
        },
        init = function()
            vim.g.image_float = true

            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    local insts = {}
                    local last
                    local original_concealcursor = {}

                    local function at_cursor(r)
                        if not r then return false end
                        local row, col = vim.fn.line("."), vim.fn.col(".") - 1
                        if row < r[1] or row > r[3] then return false end
                        if r[1] == r[3] then
                            return col >= r[2] and col <= r[4]
                        end
                        return true
                    end

                    local function sync(self)
                        local hit

                        for _, img in pairs(self.imgs) do
                            if img.opts.type == "math" then
                                if at_cursor(img.opts.range) then
                                    img:hide()
                                    hit = img
                                else
                                    img:show()
                                end
                            end
                        end

                        return hit
                    end

                    local function hover_open()
                        for _, w in ipairs(vim.api.nvim_list_wins()) do
                            if vim.api.nvim_win_get_config(w).relative ~= ""
                                and vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "image" then
                                return true
                            end
                        end
                        return false
                    end

                    local inew = Snacks.image.inline.new
                    local conceal = Snacks.image.inline.conceal
                    local pnew = Snacks.image.placement.new

                    Snacks.image.inline.new = function(buf)
                        local o = inew(buf)
                        insts[buf] = o
                        return o
                    end

                    Snacks.image.inline.conceal = function(self)
                        conceal(self)
                        sync(self)
                    end

                    Snacks.image.placement.new = function(buf, src, opts)
                        local p = pnew(buf, src, opts)

                        if opts
                            and opts.inline
                            and opts.type == "math"
                            and buf == vim.api.nvim_get_current_buf()
                            and at_cursor(opts.range)
                        then
                            p.hidden = true
                        end

                        return p
                    end

                    local update = Snacks.util.debounce(function()
                        local win = vim.api.nvim_get_current_win()
                        local buf = vim.api.nvim_get_current_buf()
                        local o = insts[buf]

                        if not o then
                            if original_concealcursor[win] ~= nil then
                                vim.wo[win].concealcursor = original_concealcursor[win]
                            end
                            last = nil
                            Snacks.image.doc.hover_close()
                            return
                        end

                        if original_concealcursor[win] == nil then
                            original_concealcursor[win] = vim.wo[win].concealcursor
                        end

                        local hit = sync(o)

                        if hit then
                            vim.wo[win].concealcursor = "nvic"
                        else
                            vim.wo[win].concealcursor = original_concealcursor[win]
                        end

                        if not vim.g.image_float or not hit then
                            last = nil
                            Snacks.image.doc.hover_close()
                        elseif hit.id ~= last or not hover_open() then
                            last = hit.id
                            Snacks.image.doc.hover_close()
                            Snacks.image.hover()
                        end
                    end, { ms = 150 })

                    vim.api.nvim_create_autocmd({
                        "CursorMoved",
                        "CursorMovedI",
                        "TextChangedI",
                        "InsertEnter",
                        "InsertLeave",
                        "ModeChanged",
                    }, {
                        pattern = "*.md",
                        callback = update,
                    })
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
                    Snacks.toggle.diagnostics():map "<leader>ud"
                    Snacks.toggle.line_number():map "<leader>ul"
                    Snacks.toggle
                        .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                        :map "<leader>uc"
                    Snacks.toggle.treesitter():map "<leader>uT"
                    Snacks.toggle
                        .option("background", { off = "light", on = "dark", name = "Dark Background" })
                        :map "<leader>ub"
                    Snacks.toggle.inlay_hints():map "<leader>uh"
                    Snacks.toggle.indent():map "<leader>ug"
                    Snacks.toggle.dim():map "<leader>uD"
                    Snacks.toggle
                        .new({
                            id = "transparent",
                            name = "Transparent Background",
                            get = function()
                                return require("transparent").enabled
                            end,
                            set = function()
                                if require("transparent").enabled then
                                    require("transparent").disable()
                                else
                                    require("transparent").enable()
                                end
                            end,
                        })
                        :map "<leader>ut"
                    Snacks.toggle
                        .new({
                            id = "copilot_nes_auto",
                            name = "Copilot Auto NES",
                            get = function()
                                return vim.g.copilot_nes_auto
                            end,
                            set = function()
                                vim.g.copilot_nes_auto = not vim.g.copilot_nes_auto
                            end,
                        })
                        :map "<leader>un"
                end,
            })
        end,
        keys = {
            -- explorer
            {
                "<leader>e",
                function()
                    Snacks.picker.explorer()
                end,
                desc = "Explorer",
            },

            -- picker
            {
                "<leader>P",
                function()
                    Snacks.picker.pick()
                end,
                desc = "Picker",
            },
            {
                "<leader>f",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find files",
            },
            {
                "<leader>p",
                function()
                    Snacks.picker.projects()
                end,
                desc = "Projects",
            },
            {
                "<leader><space>",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Smart Find Files",
            },
            {
                "<leader>/",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep",
            },
            {
                "<leader>r",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Recent Files",
            },
            {
                "<leader>b",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>q",
                function()
                    Snacks.picker.qflist()
                end,
                desc = "Quickfix List",
            },
            {
                "<leader>?",
                function()
                    Snacks.picker.help()
                end,
                desc = "Help Tags",
            },
            {
                "<leader>dd",
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = "Diagnostics",
            },
            {
                "<leader>ll",
                require("plugins.config.snacks.lsp_picker").lsp_picker,
                desc = "Lsp List (current)",
            },
            {
                "<leader>lL",
                require("plugins.config.snacks.lsp_picker").lsp_picker_all,
                desc = "Lsp List",
            },
            {
                "<leader>ls",
                function()
                    Snacks.picker.lsp_symbols()
                end,
                desc = "LSP Symbols",
            },
            {
                "<leader>lS",
                function()
                    Snacks.picker.lsp_workspace_symbols()
                end,
                desc = "LSP Workspace Symbols",
            },
            {
                "<leader>h",
                function()
                    ---@diagnostic disable-next-line: undefined-field
                    Snacks.picker.noice()
                end,
                desc = "Noice",
            },
            {
                "gd",
                function()
                    Snacks.picker.lsp_definitions()
                end,
                desc = "Definitions",
                nowait = true,
            },
            {
                "gr",
                function()
                    Snacks.picker.lsp_references()
                end,
                desc = "References",
                nowait = true,
            },
            {
                "gi",
                function()
                    Snacks.picker.lsp_implementations()
                end,
                desc = "Implementations",
                nowait = true,
            },
            {
                "gt",
                function()
                    Snacks.picker.lsp_type_definitions()
                end,
                desc = "Type Definitions",
                nowait = true,
            },
            {
                "<leader>gd",
                function()
                    Snacks.picker.git_diff()
                end,
                desc = "Git Diff",
            },
            {
                "<leader>gl",
                function()
                    Snacks.picker.git_log()
                end,
                desc = "Git Log",
            },
            {
                "<leader>gs",
                function()
                    Snacks.picker.git_status()
                end,
                desc = "Git Status",
            },

            -- image
            {
                "<leader>if",
                function()
                    Snacks.image.hover()
                end,
                desc = "Image Hover",
            },

            -- words
            {
                "]]",
                function()
                    Snacks.words.jump(vim.v.count1)
                end,
                desc = "Next reference",
            },
            {
                "[[",
                function()
                    Snacks.words.jump(-vim.v.count1)
                end,
                desc = "Previous reference",
            },

            -- terminal
            {
                "<leader>kk",
                function()
                    Snacks.terminal(nil, { win = { position = "bottom" } })
                end,
                desc = "Toggle Terminal",
            },
            {
                "<leader>kf",
                function()
                    Snacks.terminal(nil, { win = { position = "float" } })
                end,
                desc = "Float Terminal",
            },

            -- toggle
            {
                "<leader>z",
                function()
                    Snacks.zen()
                end,
                desc = "Toggle Zen Mode",
            },
            {
                "<leader>Z",
                function()
                    Snacks.zen.zoom()
                end,
                desc = "Toggle Zoom",
            },
        },
    },
}
