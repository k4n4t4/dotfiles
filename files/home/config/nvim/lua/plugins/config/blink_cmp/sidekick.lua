local source = {}

local variables = {
    { label = "{buffers}", detail = "All open buffers" },
    { label = "{file}", detail = "Current file path" },
    { label = "{position}", detail = "Cursor position" },
    { label = "{line}", detail = "Current line" },
    { label = "{selection}", detail = "Visual selection" },
    { label = "{diagnostics}", detail = "Current buffer diagnostics" },
    { label = "{diagnostics_all}", detail = "Workspace diagnostics" },
    { label = "{quickfix}", detail = "Quickfix list" },
    { label = "{function}", detail = "Function at cursor" },
    { label = "{class}", detail = "Class or struct at cursor" },
    { label = "{this}", detail = "Current context or selection" },
}

function source.new()
    return setmetatable({}, { __index = source })
end

function source:get_trigger_characters()
    return { "{" }
end

function source:get_completions(ctx, callback)
    local cursor = ctx.cursor
    local line = vim.api.nvim_buf_get_lines(ctx.bufnr, cursor[1] - 1, cursor[1], false)[1] or ""

    local before = line:sub(1, cursor[2])
    local start_col = before:match ".*(){[^{}]*$"

    if not start_col then
        callback { items = {} }
        return
    end

    local after = line:sub(cursor[2] + 1)
    local end_col = cursor[2]

    if after:sub(1, 1) == "}" then
        end_col = end_col + 1
    end

    local items = {}

    for _, variable in ipairs(variables) do
        items[#items + 1] = {
            label = variable.label,
            detail = variable.detail,
            kind = require("blink.cmp.types").CompletionItemKind.Variable,
            textEdit = {
                newText = variable.label,
                range = {
                    start = {
                        line = cursor[1] - 1,
                        character = start_col - 1,
                    },
                    ["end"] = {
                        line = cursor[1] - 1,
                        character = end_col,
                    },
                },
            },
        }
    end

    callback { items = items }
end

return source
