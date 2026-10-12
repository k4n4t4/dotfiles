local M = {}

local utils_win = require "utils.win"
local utils_info = require "utils.info"

local pending = setmetatable({}, { __mode = "k" })

M.acp = require "plugins.config.codecompanion.acp"

function M.default_adapter()
    local config = require("codecompanion.config").config
    local adapter = config.interactions.chat.adapter
    ---@diagnostic disable-next-line: undefined-field
    return require("codecompanion.adapters").resolve(adapter.name), adapter
end

function M.get_model(chat)
    local connection = chat and chat.acp_connection
    local models = connection and connection:get_models()
    if models and models.currentModelId and models.currentModelId ~= "" then
        return models.currentModelId
    end

    local _, adapter = M.default_adapter()
    ---@diagnostic disable-next-line: undefined-field
    return adapter.model
end

function M.get_mode(chat)
    if chat and pending[chat] then
        return pending[chat]
    end

    local connection = chat and chat.acp_connection
    local option = connection and connection:_find_config_option "mode"
    if option and option.currentValue then
        return option.currentValue
    end

    local defaults = (chat and chat.adapter or M.default_adapter()).defaults
    return defaults and defaults.session_config_options and defaults.session_config_options.mode
end

function M.get_thought_level(chat)
    local thought_level = M.acp.current(chat.bufnr, "thought_level")
    return thought_level and thought_level.value
end

function M.get_meta(chat)
    local all = _G.codecompanion_chat_metadata
    return chat and all and all[chat.bufnr] or {}
end

function M.get_context_items(chat)
    return M.get_meta(chat).context_items or 0
end

function M.get_cycles(chat)
    return M.get_meta(chat).cycles or 0
end

function M.get_tokens(chat)
    return M.get_meta(chat).tokens or 0
end

function M.toggle_mode(chat)
    local next_mode = M.get_mode(chat) == "plan" and "build" or "plan"
    pending[chat] = next_mode
    return next_mode
end

function M.apply_mode(chat)
    local mode = pending[chat]
    if not mode then
        return
    end
    pending[chat] = nil

    local connection = chat.acp_connection
    local option = connection and connection:_find_config_option "mode"
    if option then
        connection:set_config_option(option.id, mode)
    elseif chat.adapter.defaults and chat.adapter.defaults.session_config_options then
        chat.adapter.defaults.session_config_options.mode = mode
    end
end

local function make_footer(chat, mode)
    return (M.get_model(chat) or "")
        .. " "
        .. (mode or M.get_mode(chat) or "")
        .. " "
        .. (M.get_thought_level(chat) or "")
        .. " "
        .. (M.get_context_items(chat) or 0)
        .. " context items, "
        .. (M.get_cycles(chat) or 0)
        .. " cycles, "
        .. (M.get_tokens(chat) or 0)
        .. " tokens"
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

M.overrides = {}

function M.float_send(opts)
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
            M.overrides[data.buf] = chat
            vim.api.nvim_create_autocmd("BufWipeout", {
                buffer = data.buf,
                callback = function()
                    M.overrides[data.buf] = nil
                end,
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = { "CodeCompanionChatACPConfigChanged", "CodeCompanionChatModel" },
                callback = function(ev)
                    if not vim.api.nvim_win_is_valid(data.win) then
                        return true
                    end
                    if ev.data and ev.data.bufnr == chat.bufnr then
                        vim.api.nvim_win_set_config(data.win, { title = title, footer = make_footer(chat) })
                    end
                end,
            })
            local adapters = require "codecompanion.adapters"
            local resolved = adapters.resolve(require("codecompanion.config").interactions.chat.adapter)
            vim.api.nvim_exec_autocmds("User", {
                pattern = "CodeCompanionChatAdapter",
                data = { bufnr = data.buf, adapter = adapters.make_safe(resolved) },
            })

            vim.keymap.set({ "n", "i" }, "<C-CR>", data.submit, { buffer = data.buf, desc = "Submit" })
            vim.keymap.set({ "n", "i" }, "<S-Tab>", function()
                local next_mode = M.toggle_mode(chat)
                if vim.api.nvim_win_is_valid(data.win) then
                    vim.api.nvim_win_set_config(data.win, { title = title, footer = make_footer(chat, next_mode) })
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

local function override_chat_submit()
    local Chat = require "codecompanion.interactions.chat"
    local orig_submit = Chat.submit
    Chat.submit = function(self, ...)
        M.apply_mode(self)

        return orig_submit(self, ...)
    end
end

local function override_chat_update_metadata()
    local defaults = require "codecompanion.interactions.chat.acp.defaults"
    local orig_apply = defaults.apply
    ---@diagnostic disable-next-line: duplicate-set-field
    defaults.apply = function(adapter, connection)
        local ret = orig_apply(adapter, connection)
        local chat = connection.chat
        if chat then
            chat:update_metadata()
        end
        return ret
    end
end

local function override_acp_request_permission()
    local rp = require "codecompanion.interactions.chat.acp.request_permission"
    local orig_confirm = rp.confirm
    ---@diagnostic disable-next-line: duplicate-set-field
    rp.confirm = function(chat, request)
        local function fallback(reason)
            vim.notify("acp fallback: " .. reason)
            return orig_confirm(chat, request)
        end
        local tc = request.tool_call or {}
        local c = tc.content and tc.content[1]
        if tc.kind ~= "edit" or not c or c.type ~= "diff" then
            return fallback("kind=" .. tostring(tc.kind))
        end

        local path = (tc.locations and tc.locations[1] and tc.locations[1].path)
            or vim.fs.joinpath(vim.fn.getcwd(), c.path)
        local bufnr = vim.fn.bufadd(path)
        vim.fn.bufload(bufnr)
        if vim.bo[bufnr].modified then
            return fallback("buffer modified: " .. path)
        end
        local allow, reject
        for _, o in ipairs(request.options or {}) do
            if o.kind == "allow_once" then
                allow = o.optionId
            elseif o.kind == "reject_once" then
                reject = o.optionId
            end
        end
        if not (allow and reject) then
            return fallback "no allow/reject option"
        end
        local win = vim.fn.bufwinid(bufnr)
        if win == -1 then
            vim.cmd("sbuffer " .. bufnr)
        else
            vim.api.nvim_set_current_win(win)
        end

        local orig = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local new = vim.split(c.newText or "", "\n", { plain = true })
        local from = vim.deepcopy(orig)
        local to = vim.deepcopy(new)
        if #orig == 1 and orig[1] == "" then
            from = { "" }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "", "" })
        end
        if new[#new] == "" then
            table.remove(to)
        end

        require("codecompanion.helpers").show_diff {
            bufnr = bufnr,
            inline = true,
            from_lines = from,
            to_lines = to,
            ft = vim.bo[bufnr].filetype,
            diff_id = math.random(1000000),
            chat_bufnr = chat.bufnr,
            keymaps = {
                on_accept = function()
                    request.respond(allow, false)
                    vim.schedule(function()
                        vim.bo[bufnr].modified = false
                    end)
                    vim.defer_fn(function()
                        vim.api.nvim_buf_call(bufnr, function()
                            vim.cmd "silent! edit!"
                        end)
                    end, 300)
                end,
                on_reject = function()
                    request.respond(reject, false)
                    vim.schedule(function()
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, orig)
                        vim.bo[bufnr].modified = false
                    end)
                end,
            },
        }
    end
end

local function show_status_mark()
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
end

local function override_buf_get_chat()
    local cc = require "codecompanion"
    local orig_buf_get_chat = cc.buf_get_chat
    cc.buf_get_chat = function(bufnr)
        if bufnr == nil or bufnr == 0 then
            bufnr = vim.api.nvim_get_current_buf()
        end
        return M.overrides[bufnr] or orig_buf_get_chat(bufnr)
    end
end

function M.config()
    override_chat_submit()
    override_chat_update_metadata()
    override_acp_request_permission()
    show_status_mark()
    override_buf_get_chat()

    require("codecompanion").setup {
        opts = {
            log_level = "DEBUG",
            language = "Japanese",
        },
        adapters = {
            acp = {
                opencode = function()
                    return require("codecompanion.adapters").extend("opencode", {
                        commands = {
                            default = {
                                "unshare",
                                "--user",
                                "--map-root-user",
                                "--mount",
                                "--pid",
                                "--fork",
                                "--kill-child",
                                "sh",
                                "-c",
                                [[
                                    cwd=$1; r=/mnt
                                    mount -t tmpfs tmpfs $r
                                    mkdir -p $r/usr $r/etc $r/proc $r/dev $r/tmp $r/.old
                                    mount --rbind /usr $r/usr
                                    mount --rbind /etc $r/etc
                                    mount --rbind /dev $r/dev
                                    mount -t proc proc $r/proc
                                    ln -s usr/bin $r/bin; ln -s usr/lib $r/lib; ln -s usr/lib $r/lib64
                                    for d in "$@"; do mkdir -p "$r$d"; mount --rbind "$d" "$r$d"; done
                                    cd $r; pivot_root . .old; umount -l /.old; cd "$cwd"
                                    exec opencode acp
                                ]],
                                "sh",
                                vim.fn.getcwd(),
                                vim.env.HOME .. "/.local/share/opencode",
                                vim.env.HOME .. "/.config/opencode",
                                "/run/systemd/resolve",
                            },
                        },
                        defaults = {
                            session_config_options = {
                                mode = "plan",
                            },
                        },
                    })
                end,
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
                            local mode = M.toggle_mode(chat)
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
                        approval_mode = "ask",
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
        mode = { "i", "n", "x" },
        desc = "Code Companion Toggle",
    },
    {
        "<C-j>",
        function()
            M.float_send {}
        end,
        mode = { "n", "i" },
        desc = "Code Companion Float",
    },
    {
        "<C-j>",
        function()
            M.float_send {
                with_location = true,
            }
        end,
        mode = { "x" },
        desc = "Code Companion Float",
    },
    {
        "<C-S-j>",
        function()
            M.float_send {
                new = true,
            }
        end,
        mode = { "n", "i" },
        desc = "Code Companion Float",
    },
    {
        "<C-S-j>",
        function()
            M.float_send {
                with_location = true,
                new = true,
            }
        end,
        mode = { "x" },
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
            M.float_send {
                with_location = true,
            }
        end,
        desc = "CodeCompanion Float",
        mode = { "n", "x" },
    },
    {
        "<Leader>jJ",
        function()
            M.float_send {
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
    {
        "<Leader>jm",
        function()
            local cc = require "codecompanion"
            local chat = cc.buf_get_chat(vim.api.nvim_get_current_buf()) or cc.last_chat()
            if not chat then
                vim.api.nvim_create_autocmd("User", {
                    once = true,
                    pattern = "CodeCompanionACPSessionPost",
                    callback = function()
                        if not chat then
                            return
                        end
                        vim.defer_fn(function()
                            M.acp.select_session_options(chat)
                            vim.cmd.stopinsert()
                        end, 100)
                    end,
                })
                ---@diagnostic disable-next-line: cast-local-type
                chat = cc.chat { context = {} }
                return
            end
            M.acp.select_session_options(chat)
        end,
        desc = "CodeCompanion ACP Session Options",
    },
}

return M
