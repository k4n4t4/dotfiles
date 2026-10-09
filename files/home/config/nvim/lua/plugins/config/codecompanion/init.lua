local M = {}

local function input(opts, on_submit)
    local title = opts.title or "Input"
    local bufname = opts.bufname or title
    local ft = opts.filetype or "text"
    local go_back = opts.go_back or false

    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.6)
    local height = 5

    vim.api.nvim_buf_set_name(buf, bufname)
    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].filetype = ft

    local prev_win = vim.api.nvim_get_current_win()

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = title,
    })

    local closed = false
    local function close_input()
        if closed then
            return
        end
        closed = true

        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
    vim.cmd.startinsert()

    vim.keymap.set({ "n", "i" }, "<C-CR>", function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local msg = table.concat(lines, "\n")

        if vim.trim(msg) == "" then
            return
        end

        close_input()
        on_submit(msg, buf, win)
        if go_back then
            vim.api.nvim_set_current_win(prev_win)
        end
    end, { buffer = buf, desc = "Submit prompt" })

    vim.keymap.set("n", "q", function()
        close_input()
    end, { buffer = buf, desc = "Close prompt" })
end

local function get_visual(mode)
    local start_pos = vim.fn.getpos "v"
    local end_pos = vim.fn.getpos "."
    local selection_lines = vim.fn.getregion(start_pos, end_pos, {
        type = mode,
    })

    if selection_lines and #selection_lines > 0 then
        if mode == "V" then
            if start_pos[2] == end_pos[2] then
                return ("%dL"):format(start_pos[2])
            else
                return ("%dL-%dL"):format(start_pos[2], end_pos[2])
            end
        else
            if start_pos[2] == end_pos[2] and start_pos[3] == end_pos[3] then
                return ("%dL:%dC"):format(start_pos[2], start_pos[3])
            else
                return ("%dL:%dC-%dL:%dC"):format(start_pos[2], start_pos[3], end_pos[2], end_pos[3])
            end
        end
    end
end

local function get_location()
    local mode = vim.fn.mode()
    local is_visual = mode == "v" or mode == "V" or mode == "\22"

    local source_bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(source_bufnr), ":.")

    local location
    if is_visual then
        location = get_visual(mode)
        location = ("@%s %s"):format(filename, location)
    else
        location = ("@%s"):format(filename)
    end

    return location
end

function M.config()
    require("codecompanion").setup {
        opts = {
            log_level = "DEBUG",
            language = "Japanese",
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
                    },
                },
                intro_message = "",
            },
        },
        interactions = {
            chat = {
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
        "<C-j>",
        function()
            require("codecompanion").toggle()
        end,
        mode = { "n", "v" },
        desc = "Code Companion Toggle",
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
            local cc = require "codecompanion"
            local location = get_location()

            input({
                title = "CodeCompanion Float" .. " " .. location,
                filetype = "codecompanion",
                go_back = true,
            }, function(msg)
                local chat = cc.last_chat() or cc.chat { hidden = true, context = {} }
                if not chat then
                    return
                end

                chat:add_message {
                    role = "user",
                    content = location .. "\n" .. msg,
                }
                chat:add_buf_message {
                    content = location .. "\n" .. msg,
                }

                chat:open()
                chat:submit()
            end)
        end,
        desc = "CodeCompanion Float",
        mode = { "n", "x" },
    },
    {
        "<Leader>jJ",
        function()
            local cc = require "codecompanion"
            local location = get_location()

            input({
                title = "CodeCompanion Float" .. " " .. location,
                filetype = "codecompanion",
                go_back = true,
            }, function(msg)
                local chat = cc.chat { hidden = true, context = {} }
                if not chat then
                    return
                end

                chat:add_message {
                    role = "user",
                    content = location .. "\n" .. msg,
                }
                chat:add_buf_message {
                    content = location .. "\n" .. msg,
                }

                chat:open()
                chat:submit()
            end)
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
