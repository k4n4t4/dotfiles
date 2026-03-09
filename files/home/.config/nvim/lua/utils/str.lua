local M = {}

function M.serialize(value)
    if type(value) == "table" then
        local result = "{"
        for k, v in pairs(value) do
            result = result .. "[" .. M.serialize(k) .. "]=" .. M.serialize(v) .. ","
        end
        return result .. "}"
    elseif type(value) == "string" then
        return string.format("%q", value)
    else
        return tostring(value)
    end
end

--- Trims leading and trailing whitespace.
--- @param s string
--- @return string
function M.trim(s)
    return s:match("^%s*(.-)%s*$")
end

--- Trims leading whitespace.
--- @param s string
--- @return string
function M.ltrim(s)
    return s:match("^%s*(.*)")
end

--- Trims trailing whitespace.
--- @param s string
--- @return string
function M.rtrim(s)
    return s:match("(.-)%s*$")
end

--- Splits a string by a separator.
--- @param s string
--- @param sep string Separator string
--- @param plain? boolean If true, treat sep as a plain string (not a pattern). Default: true.
--- @return string[]
function M.split(s, sep, plain)
    if plain == nil then plain = true end
    local result = {}
    local pattern = plain and vim.pesc(sep) or sep
    local last = 1
    while true do
        local i, j = s:find(pattern, last)
        if not i then
            table.insert(result, s:sub(last))
            break
        end
        table.insert(result, s:sub(last, i - 1))
        last = j + 1
    end
    return result
end

--- Returns true if `s` starts with `prefix`.
--- @param s string
--- @param prefix string
--- @return boolean
function M.starts_with(s, prefix)
    return s:sub(1, #prefix) == prefix
end

--- Returns true if `s` ends with `suffix`.
--- @param s string
--- @param suffix string
--- @return boolean
function M.ends_with(s, suffix)
    return suffix == "" or s:sub(-#suffix) == suffix
end

--- Returns true if `s` contains `substr`.
--- @param s string
--- @param substr string
--- @return boolean
function M.contains(s, substr)
    return s:find(substr, 1, true) ~= nil
end

--- Escapes all Lua pattern special characters in `s`.
--- @param s string
--- @return string
function M.escape_pattern(s)
    return vim.pesc(s)
end

--- Counts non-overlapping occurrences of `pattern` in `s`.
--- @param s string
--- @param pattern string Lua pattern
--- @return integer
function M.count(s, pattern)
    local n = 0
    local i = 1
    while true do
        local a, b = s:find(pattern, i)
        if not a then break end
        n = n + 1
        i = b + 1
    end
    return n
end

--- Returns the display width (terminal cell count) of `s`.
--- Handles multi-byte characters and CJK wide characters correctly.
--- @param s string
--- @return integer
function M.display_width(s)
    return vim.fn.strdisplaywidth(s)
end

--- Truncates `s` to at most `max_width` display cells.
--- Appends `suffix` (default `"…"`) when truncation occurs.
--- @param s string
--- @param max_width integer
--- @param suffix? string  Default: `"…"`
--- @return string
function M.truncate(s, max_width, suffix)
    if suffix == nil then suffix = "…" end
    local w = vim.fn.strdisplaywidth(s)
    if w <= max_width then return s end

    local sw = vim.fn.strdisplaywidth(suffix)
    local budget = max_width - sw
    if budget <= 0 then return suffix:sub(1, max_width) end

    -- Walk character by character until we exceed the budget.
    local nchars = vim.fn.strchars(s)
    local result = ""
    local cells = 0
    for i = 0, nchars - 1 do
        local ch = vim.fn.strcharpart(s, i, 1)
        local cw = vim.fn.strdisplaywidth(ch)
        if cells + cw > budget then break end
        result = result .. ch
        cells = cells + cw
    end
    return result .. suffix
end

--- Pads `s` on the right with `char` (default `" "`) to reach `width` display cells.
--- Does not truncate if `s` is already wider than `width`.
--- @param s string
--- @param width integer
--- @param char? string  Default: `" "`
--- @return string
function M.pad_right(s, width, char)
    if char == nil then char = " " end
    local w = vim.fn.strdisplaywidth(s)
    if w >= width then return s end
    return s .. char:rep(width - w)
end

--- Pads `s` on the left with `char` (default `" "`) to reach `width` display cells.
--- Does not truncate if `s` is already wider than `width`.
--- @param s string
--- @param width integer
--- @param char? string  Default: `" "`
--- @return string
function M.pad_left(s, width, char)
    if char == nil then char = " " end
    local w = vim.fn.strdisplaywidth(s)
    if w >= width then return s end
    return char:rep(width - w) .. s
end

--- Centers `s` within `width` display cells, padding with `char` (default `" "`).
--- Extra padding goes to the right when the total pad is odd.
--- @param s string
--- @param width integer
--- @param char? string  Default: `" "`
--- @return string
function M.center(s, width, char)
    if char == nil then char = " " end
    local w = vim.fn.strdisplaywidth(s)
    if w >= width then return s end
    local total = width - w
    local left = math.floor(total / 2)
    local right = total - left
    return char:rep(left) .. s .. char:rep(right)
end

M.stl = {}

--- Evaluates a statusline format string via `nvim_eval_statusline`.
--- @param str string  Statusline format string (may contain `%{}`, `%#HlGroup#`, etc.)
--- @param opts? { winid?: integer, maxwidth?: integer, use_tabline?: boolean, use_winbar?: boolean }
--- @return { str: string, width: integer, highlights: table }
function M.stl.eval(str, opts)
    opts = opts or {}
    local winid = opts.winid or vim.api.nvim_get_current_win()
    local eval_opts = {
        winid = winid,
        highlights = true,
    }
    if opts.maxwidth then
        eval_opts.maxwidth = opts.maxwidth
    end
    if opts.use_tabline then
        eval_opts.use_tabline = true
    end
    if opts.use_winbar then
        eval_opts.use_winbar = true
    end

    local result = vim.api.nvim_eval_statusline(str, eval_opts)
    return { str = result.str, width = result.width, highlights = result.highlights }
end

function M.stl.get_width(str, opts)
    return M.stl.eval(str, opts).width
end

--- Returns the rendered display width of a statusline format string.
--- @param str string
--- @param winid? integer  Default: current window
--- @return integer
function M.stl.width(str, winid)
    local result = vim.api.nvim_eval_statusline(str, {
        winid = winid or vim.api.nvim_get_current_win(),
        highlights = false,
    })
    return result.width
end

--- Returns the plain rendered text of a statusline format string (no highlight escapes).
--- @param str string
--- @param winid? integer  Default: current window
--- @return string
function M.stl.plain(str, winid)
    local result = vim.api.nvim_eval_statusline(str, {
        winid = winid or vim.api.nvim_get_current_win(),
        highlights = false,
    })
    return result.str
end

--- Returns the total display width available for a window's statusline.
--- Equivalent to the window width (statusline spans the full window width).
--- @param winid? integer  Default: current window
--- @return integer
function M.stl.available_width(winid)
    local w = winid or vim.api.nvim_get_current_win()
    return vim.api.nvim_win_get_width(w)
end

--- Truncates `str` so that the left side of a statusline fits within `max_width` cells.
--- `str` must be a plain string (no statusline format codes).
--- Uses `suffix` (default `"…"`) when truncation occurs.
--- @param str string  Plain string
--- @param max_width integer
--- @param suffix? string  Default: `"…"`
--- @return string
function M.stl.truncate(str, max_width, suffix)
    return M.truncate(str, max_width, suffix)
end

--- Fits `str` to exactly `width` display cells by truncating or right-padding.
--- `str` must be a plain string (no statusline format codes).
--- @param str string
--- @param width integer
--- @param suffix? string  Truncation suffix. Default: `"…"`
--- @param pad_char? string  Padding character. Default: `" "`
--- @return string
function M.stl.fit(str, width, suffix, pad_char)
    local w = vim.fn.strdisplaywidth(str)
    if w > width then
        return M.truncate(str, width, suffix)
    elseif w < width then
        return M.pad_right(str, width, pad_char)
    end
    return str
end

--- Computes the display width of the left and right halves of a statusline string,
--- split at the first `%=` separator.
--- Returns `{ left, right, total }` widths.
--- @param str string  Statusline format string containing `%=`
--- @param winid? integer  Default: current window
--- @return { left: integer, right: integer, total: integer }
function M.stl.halves(str, winid)
    local sep = str:find("%%=", 1, true)
    local w = winid or vim.api.nvim_get_current_win()
    if not sep then
        local total = M.stl.width(str, w)
        return { left = total, right = 0, total = total }
    end
    local left_str = str:sub(1, sep - 1)
    local right_str = str:sub(sep + 2)
    local left = M.stl.width(left_str, w)
    local right = M.stl.width(right_str, w)
    return { left = left, right = right, total = left + right }
end

M.tbl = {}

--- Evaluates a tabline format string via `nvim_eval_statusline` with `use_tabline = true`.
--- @param str string  Tabline format string (may contain `%{}`, `%#HlGroup#`, etc.)
--- @param opts? { winid?: integer, maxwidth?: integer }
--- @return { str: string, width: integer, highlights: table }
function M.tbl.eval(str, opts)
    opts = opts or {}
    local winid = opts.winid or vim.api.nvim_get_current_win()
    local eval_opts = {
        winid = winid,
        highlights = true,
        use_tabline = true,
    }
    if opts.maxwidth then
        eval_opts.maxwidth = opts.maxwidth
    end
    local result = vim.api.nvim_eval_statusline(str, eval_opts)
    return { str = result.str, width = result.width, highlights = result.highlights }
end

function M.tbl.get_width(str, opts)
    return M.tbl.eval(str, opts).width
end

--- Returns the rendered display width of a tabline format string.
--- @param str string
--- @param winid? integer  Default: current window
--- @return integer
function M.tbl.width(str, winid)
    local result = vim.api.nvim_eval_statusline(str, {
        winid = winid or vim.api.nvim_get_current_win(),
        highlights = false,
        use_tabline = true,
    })
    return result.width
end

--- Returns the plain rendered text of a tabline format string (no highlight escapes).
--- @param str string
--- @param winid? integer  Default: current window
--- @return string
function M.tbl.plain(str, winid)
    local result = vim.api.nvim_eval_statusline(str, {
        winid = winid or vim.api.nvim_get_current_win(),
        highlights = false,
        use_tabline = true,
    })
    return result.str
end

--- Returns the total display width available for the tabline (i.e., the editor width).
--- @return integer
function M.tbl.available_width()
    return vim.o.columns
end

--- Truncates `str` so that a tabline segment fits within `max_width` cells.
--- `str` must be a plain string (no tabline format codes).
--- Uses `suffix` (default `"…"`) when truncation occurs.
--- @param str string  Plain string
--- @param max_width integer
--- @param suffix? string  Default: `"…"`
--- @return string
function M.tbl.truncate(str, max_width, suffix)
    return M.truncate(str, max_width, suffix)
end

--- Fits `str` to exactly `width` display cells by truncating or right-padding.
--- `str` must be a plain string (no tabline format codes).
--- @param str string
--- @param width integer
--- @param suffix? string  Truncation suffix. Default: `"…"`
--- @param pad_char? string  Padding character. Default: `" "`
--- @return string
function M.tbl.fit(str, width, suffix, pad_char)
    local w = vim.fn.strdisplaywidth(str)
    if w > width then
        return M.truncate(str, width, suffix)
    elseif w < width then
        return M.pad_right(str, width, pad_char)
    end
    return str
end

--- Computes the display width of the left and right halves of a tabline string,
--- split at the first `%=` separator.
--- Returns `{ left, right, total }` widths.
--- @param str string  Tabline format string containing `%=`
--- @param winid? integer  Default: current window
--- @return { left: integer, right: integer, total: integer }
function M.tbl.halves(str, winid)
    local sep = str:find("%%=", 1, true)
    local w = winid or vim.api.nvim_get_current_win()
    if not sep then
        local total = M.tbl.width(str, w)
        return { left = total, right = 0, total = total }
    end
    local left_str = str:sub(1, sep - 1)
    local right_str = str:sub(sep + 2)
    local left = M.tbl.width(left_str, w)
    local right = M.tbl.width(right_str, w)
    return { left = left, right = right, total = left + right }
end

return M
