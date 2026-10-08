local M = {}

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
                opencode = {
                    cmd = { "opencode", "--standalone" },
                },
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
        "<leader>jc",
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
}

return M
