local M = {}

local utils_win = require "utils.win"
local utils_info = require "utils.info"

local function default_adapter()
    local config = require("codecompanion.config").config
    local adapter = config.interactions.chat.adapter
    ---@diagnostic disable-next-line: undefined-field
    return require("codecompanion.adapters").resolve(adapter.name), adapter
end

local function get_model(chat)
    local connection = chat and chat.acp_connection
    local models = connection and connection:get_models()
    if models and models.currentModelId and models.currentModelId ~= "" then
        return models.currentModelId
    end

    local _, adapter = default_adapter()
    ---@diagnostic disable-next-line: undefined-field
    return adapter.model
end

local function get_mode(chat)
    local connection = chat and chat.acp_connection
    local option = connection and connection:_find_config_option "mode"
    if option and option.currentValue then
        return option.currentValue
    end

    local defaults = (chat and chat.adapter or default_adapter()).defaults
    return defaults and defaults.session_config_options and defaults.session_config_options.mode
end

local function toggle_mode(chat)
    local next_mode = get_mode(chat) == "plan" and "build" or "plan"

    local connection = chat.acp_connection
    local option = connection and connection:_find_config_option "mode"
    if option then
        connection:set_config_option(option.id, next_mode)
    elseif chat.adapter.defaults and chat.adapter.defaults.session_config_options then
        chat.adapter.defaults.session_config_options.mode = next_mode
    end

    return next_mode
end

local function make_footer(chat, mode)
    return (get_model(chat) or "") .. " " .. (mode or get_mode(chat) or "")
end

local function get_location()
    local is_visual = utils_info.is_visual()

    local source_bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(source_bufnr), ":.")

    local location = ("@%s"):format(filename)

    if is_visual then
        local visual = utils_info.get_visual()
        if not visual then
            return location
        end

        if visual.mode == "V" then
            if visual.start_line == visual.end_line then
                location = ("%s %dL"):format(location, visual.start_line)
            else
                location = ("%s %dL-%dL"):format(location, visual.start_line, visual.end_line)
            end
        else
            if visual.start_line == visual.end_line and visual.start_col == visual.end_col then
                location = ("%s %dL:%dC"):format(location, visual.start_line, visual.start_col)
            else
                location = ("%s %dL:%dC-%dL:%dC"):format(
                    location,
                    visual.start_line,
                    visual.start_col,
                    visual.end_line,
                    visual.end_col
                )
            end
        end
    end

    return location
end

local overrides = {}

local function float_send(opts)
    local is_new = opts.new
    local with_location = opts.with_location

    local cc = require "codecompanion"
    local prev_win = vim.api.nvim_get_current_win()

    local chat
    if is_new then
        chat = cc.chat { hidden = true, context = {} }
    else
        chat = cc.last_chat()
        if not chat then
            chat = cc.chat { hidden = true, context = {} }
            is_new = true
        end
    end
    if not chat then
        return
    end

    local location = ""
    if with_location then
        location = get_location()
        chat:add_message {
            role = "user",
            content = location .. "\n",
        }
        chat:add_buf_message {
            content = location .. "\n",
        }
    end

    local title = ""
    title = title .. "CodeCompanion"
    if is_new then
        title = title .. " (New)"
    end
    if with_location then
        title = title .. " " .. location
    end

    local footer = make_footer(chat)

    utils_win.float_input {
        filetype = "codecompanion",
        win = {
            title = title,
            footer = footer,
            relative = "cursor",
            row = 1,
            col = 0,
            border = "single",
        },
        on_create = function(data)
            overrides[data.buf] = chat
            vim.api.nvim_create_autocmd("BufWipeout", {
                buffer = data.buf,
                callback = function()
                    overrides[data.buf] = nil
                end,
            })

            vim.keymap.set({ "n", "i" }, "<C-CR>", data.submit, { buffer = data.buf, desc = "Submit" })
            vim.keymap.set({ "n", "i" }, "<S-Tab>", function()
                local mode = toggle_mode(chat)
                if vim.api.nvim_win_is_valid(data.win) then
                    vim.api.nvim_win_set_config(data.win, { title = title, footer = make_footer(chat, mode) })
                end
            end, { buffer = data.buf, desc = "Toggle mode" })
        end,
        on_submit = function(msg)
            chat:add_message {
                role = "user",
                content = msg,
            }
            chat:add_buf_message {
                content = msg,
            }

            chat:open()
            chat:submit()

            vim.api.nvim_set_current_win(prev_win)
            vim.cmd.stopinsert()
        end,
    }
end

function M.config()
    local group = vim.api.nvim_create_augroup("CodeCompanionStatus", {
        clear = true,
    })

    local ns = vim.api.nvim_create_namespace "CodeCompanionStatus"
    local marks = {}

    local function clear_extmark(ev)
        local status = marks[ev.data.bufnr]
        if not status then
            return
        end

        if vim.api.nvim_buf_is_valid(status.bufnr) then
            pcall(vim.api.nvim_buf_del_extmark, status.bufnr, ns, status.mark)
        end

        marks[ev.data.bufnr] = nil
    end

    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "CodeCompanionChatSubmitted",
        callback = function(ev)
            local bufnr = ev.data.bufnr
            if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
                return
            end

            clear_extmark(ev)
            marks[bufnr] = {
                bufnr = bufnr,
                mark = vim.api.nvim_buf_set_extmark(bufnr, ns, vim.api.nvim_buf_line_count(bufnr) - 1, 0, {
                    virt_text = { { " Sending request ...", "Comment" } },
                    virt_text_pos = "eol",
                }),
            }
        end,
    })

    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = { "CodeCompanionRequestStreaming", "CodeCompanionRequestFinished", "CodeCompanionChatStopped" },
        callback = clear_extmark,
    })

    local cc = require "codecompanion"
    local orig_buf_get_chat = cc.buf_get_chat
    cc.buf_get_chat = function(bufnr)
        if bufnr == nil or bufnr == 0 then
            bufnr = vim.api.nvim_get_current_buf()
        end
        return overrides[bufnr] or orig_buf_get_chat(bufnr)
    end

    cc.setup {
        opts = {
            log_level = "DEBUG",
            language = "Japanese",
        },
        adapters = {
            acp = {
                extend = {
                    opencode = {
                        defaults = {
                            session_config_options = {
                                mode = "plan",
                            },
                        },
                    },
                },
            },
        },
        display = {
            diff = {
                enabled = true,
                threshold_for_chat = 0,
            },
            chat = {
                window = {
                    layout = "vertical",
                    width = 0.35,
                    height = 0.6,
                    opts = {
                        number = false,
                        relativenumber = false,
                        signcolumn = "no",
                        foldcolumn = "0",
                    },
                },
                intro_message = "",
            },
        },
        interactions = {
            chat = {
                keymaps = {
                    send = {
                        modes = { n = "<C-CR>", i = "<C-CR>" },
                        index = 1,
                        callback = "keymaps.send",
                        description = "Send",
                    },
                    toggle_mode = {
                        modes = { n = "<S-Tab>" },
                        description = "Toggle plan/build",
                        callback = function(chat)
                            local mode = toggle_mode(chat)
                            vim.notify("mode: " .. mode)
                        end,
                    },
                },
                adapter = {
                    name = "opencode",
                    model = "opencode/big-pickle",
                },
                tools = {
                    opts = {
                        approval_mode = "manual",
                    },
                },
            },
            inline = {
                adapter = {
                    name = "copilot",
                    model = "gpt-4o",
                },
            },
        },
    }
end

M.keys = {
    {
        "<C-.>",
        function()
            require("codecompanion").toggle()
        end,
        mode = { "n", "x" },
        desc = "Code Companion Toggle",
    },
    {
        "<C-j>",
        function()
            float_send {
                new = true,
            }
        end,
        mode = { "n", "x" },
        desc = "Code Companion Float",
    },
    {
        "<C-S-j>",
        function()
            float_send {}
        end,
        mode = { "n", "x" },
        desc = "Code Companion Float",
    },
    {
        "<Leader>jn",
        function()
            local cc = require "codecompanion"
            local chat = cc.chat { hidden = true, context = {} }
            if not chat then
                return
            end

            local location = get_location() .. "\n"
            chat:add_message {
                role = "user",
                content = location,
            }
            chat:add_buf_message {
                content = location,
            }

            chat:open()
            local win = vim.fn.bufwinid(chat.bufnr)
            if win ~= -1 then
                vim.api.nvim_set_current_win(win)
            end
        end,
        desc = "Code Companion Chat",
        mode = { "n", "x" },
    },
    {
        "<Leader>jl",
        function()
            local cc = require "codecompanion"
            local chat = cc.last_chat() or cc.chat { hidden = true, context = {} }
            if not chat then
                return
            end

            local location = get_location() .. "\n"
            chat:add_message {
                role = "user",
                content = location,
            }
            chat:add_buf_message {
                content = location,
            }

            chat:open()
            local win = vim.fn.bufwinid(chat.bufnr)
            if win ~= -1 then
                vim.api.nvim_set_current_win(win)
            end
        end,
        desc = "CodeCompanion Ask",
        mode = { "n", "x" },
    },
    {
        "<Leader>jj",
        function()
            float_send {
                with_location = true,
            }
        end,
        desc = "CodeCompanion Float",
        mode = { "n", "x" },
    },
    {
        "<Leader>jJ",
        function()
            float_send {
                with_location = true,
                new = true,
            }
        end,
        desc = "CodeCompanion Float New",
        mode = { "n", "x" },
    },
    {
        "<Leader>ja",
        function()
            require("codecompanion").actions {}
        end,
        desc = "CodeCompanion Actions",
    },
    {
        "<Leader>ji",
        function()
            require("codecompanion").inline {}
        end,
        desc = "CodeCompanion Inline",
    },
}

return M
