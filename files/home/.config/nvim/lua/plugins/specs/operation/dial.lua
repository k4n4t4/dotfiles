return {
    "monaqa/dial.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local dial = require "dial.config"
        local augend = require "dial.augend"

        dial.augends:register_group {
            default = {
                augend.integer.alias.decimal,
                augend.integer.alias.decimal_int,
                augend.integer.alias.hex,
                augend.integer.alias.octal,
                augend.integer.alias.binary,
                augend.date.alias["%Y/%m/%d"],
                augend.date.alias["%m/%d/%Y"],
                augend.date.alias["%d/%m/%Y"],
                augend.date.alias["%m/%d/%y"],
                augend.date.alias["%d/%m/%y"],
                augend.date.alias["%m/%d"],
                augend.date.alias["%-m/%-d"],
                augend.date.alias["%Y-%m-%d"],
                augend.date.alias["%Y年%-m月%-d日"],
                augend.date.alias["%Y年%-m月%-d日(%ja)"],
                augend.date.alias["%H:%M:%S"],
                augend.date.alias["%H:%M"],
                augend.constant.alias.ja_weekday,
                augend.constant.alias.ja_weekday_full,
                augend.constant.alias.bool,
                augend.constant.alias.alpha,
                augend.constant.alias.Alpha,
                augend.semver.alias.semver,
                -- augend.paren.alias.quote;
                -- augend.paren.alias.brackets;
                augend.paren.alias.lua_str_literal,
                augend.paren.alias.rust_str_literal,
                augend.misc.alias.markdown_header,
            },
        }
    end,
    keys = {
        { mode = 'n', "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  desc = "Increment" },
        { mode = 'n', "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  desc = "Decrement" },
        { mode = 'n', "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "gIncrement" },
        { mode = 'n', "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "gDecrement" },
        { mode = 'v', "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  desc = "vIncrement" },
        { mode = 'v', "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  desc = "vDecrement" },
        { mode = 'v', "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, desc = "gvIncrement" },
        { mode = 'v', "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, desc = "gvDecrement" },
    },
}
