local M = {}

local function input(on_submit)
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.6)
    local height = 5

    vim.api.nvim_buf_set_name(buf, "Sidekick Prompt")
    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].filetype = "markdown"
    vim.b[buf].sidekick_prompt = true

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Sidekick Prompt ",
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
    vim.cmd.startinsert()

    local function send()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local msg = table.concat(lines, "\n")

        if msg == "" then
            return
        end

        vim.api.nvim_win_close(win, true)

        on_submit(msg)
    end

    vim.keymap.set({ "n", "i" }, "<C-CR>", function()
        send()
    end, {
        buffer = buf,
        desc = "Send prompt to Sidekick",
    })

    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
end

function M.config()
    local cli_tool = "opencode"

    local sk = require "sidekick"
    local sk_cli = require "sidekick.cli"

    sk.setup {
        nes = {
            trigger = {
                events = {},
            },
        },
        cli = {
            watch = true,
            win = {
                layout = "right",
                split = {
                    width = 0,
                },
                config = function(win)
                    win.opts.split.width = math.floor(vim.o.columns * 0.3)
                end,
            },
            mux = {
                enabled = false,
                backend = "tmux",
            },
            tools = {
                opencode = require "plugins.config.sidekick.opencode",
            },
        },
    }

    for _, fn in ipairs { "toggle", "focus", "send" } do
        local orig = sk_cli[fn]
        sk_cli[fn] = function(o)
            return orig(vim.tbl_extend("keep", o or {}, { name = cli_tool, focus = true }))
        end
    end
end

M.keys = {
    {
        "<c-j>",
        function()
            require("sidekick").nes_jump_or_apply()
        end,
        desc = "NES Jump/Apply",
    },
    {
        "<leader>jn",
        function()
            require("sidekick.nes").update()
        end,
        desc = "Sidekick NES Request",
    },
    {
        "<leader>jr",
        function()
            require("sidekick.nes").clear()
        end,
        desc = "NES Reject",
    },
    {
        "<c-.>",
        function()
            require("sidekick.cli").focus()
        end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
    },
    {
        "<c-,>",
        function()
            require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
        mode = { "n", "t", "i", "x" },
    },
    {
        "<leader>jS",
        function()
            require("sidekick.cli").select()
        end,
        desc = "Select CLI",
    },
    {
        "<leader>jt",
        function()
            require("sidekick.cli").send { msg = "{this}" }
        end,
        mode = { "x", "n" },
        desc = "Send This",
    },
    {
        "<leader>js",
        function()
            require("sidekick.cli").send { msg = "{file}" }
        end,
        mode = { "n" },
        desc = "Send File",
    },
    {
        "<leader>js",
        function()
            require("sidekick.cli").send { msg = "{selection}" }
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
    },
    {
        "<leader>jp",
        function()
            require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
    },
    {
        "<leader>jj",
        function()
            input(function(msg)
                require("sidekick.cli").send { msg = msg }
            end)
        end,
        mode = { "n", "x" },
        desc = "Sidekick Input",
    },
}

return M
