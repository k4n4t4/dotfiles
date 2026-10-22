local M = {}

local ext_ns = vim.api.nvim_create_namespace "ui_mark_ext"
local provider_ns = vim.api.nvim_create_namespace "ui_mark_provider"
local group = vim.api.nvim_create_augroup("UiMark", { clear = true })

local opts = { delay_ms = 12 }
local next_id, next_ns = 0, 0
local namespaces = {}
local marks = {} -- marks[buf][id] = { ns = ns, render = fn }
local mirrors = {} -- mirrors[buf] = { { ns, src_ns, filter, render }, ... }
local painted = {} -- painted[key] = true (what is currently on the terminal)
local timer = vim.uv.new_timer()

local flush

local function schedule_flush()
    timer:stop()
    timer:start(
        opts.delay_ms,
        0,
        vim.schedule_wrap(function()
            flush()
        end)
    )
end

local function resolve_buf(buf)
    return (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
end

-- render() may return a string, or a list of { seq, dr?, dc? } for several spots
local function add(want, win, sp, seq)
    if type(seq) == "table" then
        for _, p in ipairs(seq) do
            local r, c = sp.row + (p.dr or 0), sp.col + (p.dc or 0)
            want[table.concat({ win, r, c, p.seq }, ":")] = { row = r, col = c, seq = p.seq }
        end
    elseif seq then
        want[table.concat({ win, sp.row, sp.col, seq }, ":")] = { row = sp.row, col = sp.col, seq = seq }
    end
end

local function emit(want, win, buf, info, cursor_row, id, row, col, render, details)
    local sp = vim.fn.screenpos(win, row + 1, col + 1)
    if sp.row <= 0 or sp.col <= 0 then
        return
    end
    local seq = render {
        id = id,
        win = win,
        buf = buf,
        row = row,
        col = col,
        screen_row = sp.row,
        screen_col = sp.col,
        right_edge = info.wincol + info.width - 1,
        bottom_edge = info.winrow + info.height - 1,
        cursor_row = cursor_row,
        details = details,
    }
    add(want, win, sp, seq)
end

-- Returns { [key] = { row, col, seq } } for everything that should be on screen
local function collect()
    local want = {}
    local cur = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bm, ml = marks[buf], mirrors[buf]
        if bm or ml then
            local info = vim.fn.getwininfo(win)[1]
            local cursor_row = win == cur and vim.api.nvim_win_get_cursor(win)[1] - 1 or nil

            for id, m in pairs(bm or {}) do
                local pos = vim.api.nvim_buf_get_extmark_by_id(buf, ext_ns, id, { details = true })
                if pos[1] and not (pos[3] and pos[3].invalid) then
                    emit(want, win, buf, info, cursor_row, id, pos[1], pos[2], m.render, pos[3])
                end
            end

            for _, mr in ipairs(ml or {}) do
                local ems = vim.api.nvim_buf_get_extmarks(
                    buf,
                    mr.src_ns,
                    { info.topline - 1, 0 },
                    { info.botline - 1, -1 },
                    { details = true }
                )
                for _, em in ipairs(ems) do
                    if not mr.filter or mr.filter(em[4], em[2], em[3]) then
                        emit(want, win, buf, info, cursor_row, em[1], em[2], em[3], mr.render, em[4])
                    end
                end
            end
        end
    end
    return want
end

flush = function()
    -- Do not paint over the command line or a completion popup
    if vim.fn.mode() == "c" or vim.fn.pumvisible() == 1 then
        return
    end

    local want = collect()

    -- Something on the terminal is no longer wanted: the only way to erase it
    -- is a full repaint, so repaint and let the next flush draw everything.
    for key in pairs(painted) do
        if not want[key] then
            painted = {}
            vim.cmd "redraw!"
            schedule_flush()
            return
        end
    end

    local parts = {}
    for key, v in pairs(want) do
        if not painted[key] then
            painted[key] = true
            parts[#parts + 1] = ("\27[%d;%dH"):format(v.row, v.col) .. v.seq
        end
    end
    if #parts == 0 then
        return
    end

    parts[#parts + 1] = "\27[0m"
    local win = vim.api.nvim_get_current_win()
    local c = vim.api.nvim_win_get_cursor(win)
    local sp = vim.fn.screenpos(win, c[1], c[2] + 1)
    if sp.row > 0 and sp.col > 0 then
        parts[#parts + 1] = ("\27[%d;%dH"):format(sp.row, sp.col)
    end
    vim.api.nvim_ui_send(table.concat(parts))
end

function M.create_namespace(name)
    if not namespaces[name] then
        next_ns = next_ns + 1
        namespaces[name] = next_ns
    end
    return namespaces[name]
end

-- o.render(ctx) -> escape sequence string (or list of { seq, dr, dc }), nil to hide
-- o.end_col: attach the mark to the range [col, end_col) on the same row;
--            deleting that whole range removes the overlay
-- o.id: pass an existing id to update it
function M.set(buf, ns, row, col, o)
    buf = resolve_buf(buf)
    local id = o.id
    if not id then
        next_id = next_id + 1
        id = next_id
    end
    vim.api.nvim_buf_set_extmark(buf, ext_ns, row, col, {
        id = id,
        strict = false,
        end_row = o.end_col and row or nil,
        end_col = o.end_col,
        invalidate = o.end_col ~= nil or nil,
        undo_restore = false,
    })
    marks[buf] = marks[buf] or {}
    local prev = marks[buf][id]
    marks[buf][id] = { ns = ns, render = o.render or (prev and prev.render) }
    schedule_flush()
    return id
end

function M.get(buf, id)
    local pos = vim.api.nvim_buf_get_extmark_by_id(resolve_buf(buf), ext_ns, id, {})
    if pos[1] then
        return pos[1], pos[2]
    end
end

function M.del(buf, ns, id)
    buf = resolve_buf(buf)
    local bm = marks[buf]
    if not bm or not bm[id] or (ns and bm[id].ns ~= ns) then
        return false
    end
    vim.api.nvim_buf_del_extmark(buf, ext_ns, id)
    bm[id] = nil
    schedule_flush()
    return true
end

-- ns == nil clears every mark in the buffer
function M.clear(buf, ns)
    buf = resolve_buf(buf)
    local bm = marks[buf]
    if not bm then
        return
    end
    for id, m in pairs(bm) do
        if not ns or m.ns == ns then
            vim.api.nvim_buf_del_extmark(buf, ext_ns, id)
            bm[id] = nil
        end
    end
    schedule_flush()
end

-- Draw overlays at every extmark of another namespace that passes o.filter
-- o.filter(details, row, col) -> boolean, o.render(ctx) as in set()
function M.mirror(buf, ns, src_ns, o)
    buf = resolve_buf(buf)
    mirrors[buf] = mirrors[buf] or {}
    table.insert(mirrors[buf], { ns = ns, src_ns = src_ns, filter = o.filter, render = o.render })
    schedule_flush()
end

function M.unmirror(buf, ns)
    buf = resolve_buf(buf)
    local list = mirrors[buf] or {}
    for i = #list, 1, -1 do
        if not ns or list[i].ns == ns then
            table.remove(list, i)
        end
    end
    schedule_flush()
end

-- Call when the terminal may have lost the overlays (e.g. <C-l>, resize)
function M.invalidate()
    painted = {}
    schedule_flush()
end

function M.setup(o)
    opts = vim.tbl_extend("force", opts, o or {})
end

-- Neovim redrew a window: re-check what should be on screen
vim.api.nvim_set_decoration_provider(provider_ns, {
    on_win = function()
        return false
    end,
    on_end = function()
        schedule_flush()
    end,
})

vim.api.nvim_create_autocmd({ "VimResized", "ColorScheme", "FocusGained" }, {
    group = group,
    callback = M.invalidate,
})

vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(a)
        marks[a.buf] = nil
        mirrors[a.buf] = nil
        schedule_flush()
    end,
})

vim.on_key(function(key, typed)
    if key == "\12" or typed == "\12" then
        vim.schedule(M.invalidate)
    end
end, provider_ns)

return M
