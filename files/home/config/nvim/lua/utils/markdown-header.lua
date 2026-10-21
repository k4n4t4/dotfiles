local M = {}

local defaults = {
    debounce_ms = 0,
    render_delay_ms = 0,
    sizes = { 2, 1.5, 1.17, 1, 0.83, 0.67 },
    foregrounds = {
        'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
    },
    backgrounds = {
    },
    conceallevel = 2,
    require_kitty_env = true,
}

local ns
local group
local timer
local render_timer
local key_ns
local opts = vim.deepcopy(defaults)
local cache = {}
local last_mark_state = {}

local function is_kitty()
    if not opts.require_kitty_env then
        return true
    end
    return vim.env.KITTY_WINDOW_ID ~= nil or vim.env.TERM == 'xterm-kitty'
end

local function plain_title(text)
    text = text:gsub('!%[([^%]]*)%](%b())', '%1')
    text = text:gsub('%[([^%]]+)%](%b())', '%1')
    text = text:gsub('%[([^%]]+)%]%[[^%]]*%]', '%1')
    text = text:gsub('`+([^`]-)`+', '%1')
    text = text:gsub('%*%*(.-)%*%*', '%1')
    text = text:gsub('__(.-)__', '%1')
    text = text:gsub('~~(.-)~~', '%1')
    text = text:gsub('%*(.-)%*', '%1')
    text = text:gsub('_(.-)_', '%1')
    text = text:gsub('<[^>]+>', '')
    text = text:gsub('\\([%p])', '%1')
    text = text:gsub('[%c]', ' ')
    return vim.trim(text)
end

local function heading_from_line(line, row)
    local indent, hashes, spacing, raw = line:match('^(%s*)(#+)([ \t]+)(.*)$')
    if not hashes then
        return nil
    end

    local level = #hashes
    if level < 1 or level > 6 then
        return nil
    end

    local before_closing = raw:match('^(.-)%s+#+%s*$')
    if before_closing then
        raw = before_closing
    end
    raw = raw:gsub('%s+$', '')
    local title = plain_title(raw)
    if title == '' then
        return nil
    end

    local indent_col = #indent
    local start_col = indent_col + #hashes + #spacing
    local end_col = start_col + #raw
    if end_col <= start_col then
        return nil
    end

    return {
        row = row,
        level = level,
        indent_col = indent_col,
        start_col = start_col,
        end_col = end_col,
        conceal_end_col = #line,
        title = title,
    }
end

local function read_headings(buf)
    local tick = vim.api.nvim_buf_get_changedtick(buf)
    local old = cache[buf]
    if old and old.tick == tick then
        return old.headings
    end

    local headings = {}
    local ok, trees = pcall(function()
        local parser = vim.treesitter.get_parser(buf, 'markdown')
        if not parser then
            return nil
        end
        return parser:parse()
    end)
    if not ok or not trees then
        cache[buf] = { tick = tick, headings = headings }
        return headings
    end

    local function visit(node)
        if node:type() == 'atx_heading' then
            local row = node:start()
            local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
            if line then
                local heading = heading_from_line(line, row)
                if heading then
                    headings[#headings + 1] = heading
                end
            end
        end
        for child in node:iter_children() do
            visit(child)
        end
    end

    for _, tree in ipairs(trees) do
        visit(tree:root())
    end

    table.sort(headings, function(a, b)
        if a.row == b.row then
            return a.start_col < b.start_col
        end
        return a.row < b.row
    end)
    cache[buf] = { tick = tick, headings = headings }
    return headings
end

local function size_for(level)
    local scale = opts.sizes[level]
    if scale == nil then
        return { s = 1 }
    end

    if type(scale) ~= 'number' or scale <= 0 or scale > 7 then
        vim.notify(
            ('Invalid Kitty heading size for H%d: %s (expected a number > 0 and <= 7)')
            :format(level, tostring(scale)),
            vim.log.levels.WARN
        )
        return { s = 1 }
    end

    local nearest = math.floor(scale + 0.5)
    if math.abs(scale - nearest) < 0.000001 then
        return { s = nearest }
    end

    local cells = math.ceil(scale)
    local ratio = scale / cells
    local best_n, best_d, best_error = 1, 2, math.huge
    for d = 2, 15 do
        for n = 1, d - 1 do
            local err = math.abs(ratio - n / d)
            if err < best_error then
                best_n, best_d, best_error = n, d, err
            end
        end
    end

    return { s = cells, n = best_n, d = best_d, v = 2 }
end

local function extra_rows(size)
    return math.max(0, (size.s or 1) - 1)
end

local function metadata(size)
    local bits = {}
    if size.s then bits[#bits + 1] = ('s=%d'):format(size.s) end
    if size.n then bits[#bits + 1] = ('n=%d'):format(size.n) end
    if size.d then bits[#bits + 1] = ('d=%d'):format(size.d) end
    if size.v then bits[#bits + 1] = ('v=%d'):format(size.v) end
    if size.h then bits[#bits + 1] = ('h=%d'):format(size.h) end
    if #bits == 0 then
        return 's=1'
    end
    return table.concat(bits, ':')
end

local function color_code(value, foreground)
    if not value then
        return nil
    end
    local r = math.floor(value / 65536) % 256
    local g = math.floor(value / 256) % 256
    local b = value % 256
    return ('%d;2;%d;%d;%d'):format(foreground and 38 or 48, r, g, b)
end

local function sgr_for(level)
    local fg_name = opts.foregrounds[level]
    local bg_name = opts.backgrounds[level]
    local fg = fg_name and vim.api.nvim_get_hl(0, { name = fg_name, link = false }) or {}
    local bg = bg_name and vim.api.nvim_get_hl(0, { name = bg_name, link = false }) or {}
    local codes = { '0' }
    local fc = color_code(fg.fg, true)
    local bc = color_code(bg.bg, false)
    if fc then codes[#codes + 1] = fc end
    if bc then codes[#codes + 1] = bc end
    if fg.bold then codes[#codes + 1] = '1' end
    if fg.italic then codes[#codes + 1] = '3' end
    if fg.underline then codes[#codes + 1] = '4' end
    if fg.strikethrough then codes[#codes + 1] = '9' end
    return '\27[' .. table.concat(codes, ';') .. 'm'
end

local function truncate_cells(text, max_cells)
    if max_cells <= 0 then
        return ''
    end
    local total = vim.fn.strdisplaywidth(text)
    if total <= max_cells then
        return text
    end

    local chars = vim.fn.strchars(text)
    local out, width = {}, 0
    local limit = math.max(0, max_cells - 1)
    for i = 0, chars - 1 do
        local ch = vim.fn.strcharpart(text, i, 1)
        local w = vim.fn.strdisplaywidth(ch)
        if width + w > limit then
            break
        end
        out[#out + 1] = ch
        width = width + w
    end
    if max_cells >= 1 then
        out[#out + 1] = '…'
    end
    return table.concat(out)
end

local function visible_width(win)
    local info = vim.fn.getwininfo(win)[1]
    if not info then
        return vim.o.columns
    end
    return info.wincol + info.width - 1
end

local function add_markers(buf, headings, cursor_row)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    for _, heading in ipairs(headings) do
        local size = size_for(heading.level)
        local rows = extra_rows(size)
        local virt_lines = {}
        for _ = 1, rows do
            virt_lines[#virt_lines + 1] = { { ' ', 'Normal' } }
        end

        local mark = {
            end_row = heading.row,
            end_col = heading.conceal_end_col,
            priority = 3000,
        }
        if heading.row ~= cursor_row then
            mark.conceal = ''
        end
        if #virt_lines > 0 then
            mark.virt_lines = virt_lines
            mark.virt_lines_above = false
            mark.virt_lines_leftcol = true
        end

        vim.api.nvim_buf_set_extmark(buf, ns, heading.row, heading.indent_col, mark)
    end
end

local function render_overlays(visible, current_win, current_buf)
    local parts = {}
    local cursor = vim.api.nvim_win_get_cursor(current_win)
    local cursor_pos = vim.fn.screenpos(current_win, cursor[1], cursor[2] + 1)

    for _, item in ipairs(visible) do
        local win = item.win
        local buf = item.buf
        local right_edge = visible_width(win)
        local info = vim.fn.getwininfo(win)[1]
        local bottom_edge = info and (info.winrow + info.height - 1) or vim.o.lines

        for _, heading in ipairs(item.headings) do
            local cursor_is_on_heading = buf == current_buf and heading.row == cursor[1] - 1
            if not cursor_is_on_heading then
                local pos = vim.fn.screenpos(win, heading.row + 1, heading.indent_col + 1)
                local size = size_for(heading.level)
                local height = size.s or 1
                if pos.row > 0
                    and pos.col > 0
                    and pos.col <= right_edge
                    and pos.row + height - 1 <= bottom_edge
                then
                    local available = right_edge - pos.col + 1
                    local max_cells = height > 1 and math.floor(available / height) or available
                    local title = truncate_cells(heading.title, max_cells)
                    if title ~= '' then
                        parts[#parts + 1] = ('\27[%d;%dH'):format(pos.row, pos.col)
                        parts[#parts + 1] = sgr_for(heading.level)
                        parts[#parts + 1] = ('\27]66;%s;%s\7'):format(metadata(size), title)
                    end
                end
            end
        end
    end

    if #parts == 0 then
        return
    end

    parts[#parts + 1] = '\27[0m'
    if cursor_pos.row > 0 and cursor_pos.col > 0 then
        parts[#parts + 1] = ('\27[%d;%dH'):format(cursor_pos.row, cursor_pos.col)
    end
    vim.api.nvim_ui_send(table.concat(parts))
end

local function visible_markdown_windows()
    local visible = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'markdown' then
                visible[#visible + 1] = {
                    win = win,
                    buf = buf,
                    headings = read_headings(buf),
                }
            end
        end
    end
    return visible
end

local function draw_latest()
    if not vim.api.nvim_ui_send or not is_kitty() then
        return
    end
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    local visible = visible_markdown_windows()
    if #visible > 0 then
        render_overlays(visible, current_win, current_buf)
    end
end

local function refresh()
    if not vim.api.nvim_ui_send or not is_kitty() then
        return
    end

    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    local cursor_row = vim.api.nvim_win_get_cursor(current_win)[1] - 1
    local visible = {}

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'markdown' then
                if vim.wo[win].conceallevel < opts.conceallevel then
                    vim.wo[win].conceallevel = opts.conceallevel
                end
                local active_row = buf == current_buf and cursor_row or nil
                local tick = vim.api.nvim_buf_get_changedtick(buf)
                local state = last_mark_state[buf]
                if not state or state.tick ~= tick or state.cursor_row ~= active_row then
                    local headings = read_headings(buf)
                    add_markers(buf, headings, active_row)
                    last_mark_state[buf] = { tick = tick, cursor_row = active_row }
                end
                local headings = read_headings(buf)
                visible[#visible + 1] = { win = win, buf = buf, headings = headings }
            end
        end
    end

    vim.cmd('redraw!')

    if render_timer then
        render_timer:stop()
    end

    if #visible == 0 then
        return
    end

    if render_timer then
        render_timer:start(opts.render_delay_ms, 0, vim.schedule_wrap(draw_latest))
    else
        vim.defer_fn(draw_latest, opts.render_delay_ms)
    end
end

local function schedule()
    if render_timer then
        render_timer:stop()
    end
    if not timer then
        refresh()
        return
    end
    timer:stop()
    timer:start(opts.debounce_ms, 0, vim.schedule_wrap(refresh))
end

local function install_redraw_listener()
    key_ns = key_ns or vim.api.nvim_create_namespace('kitty-markdown-headings-keys')
    vim.on_key(function(key, typed)
        if key == '\12' or typed == '\12' then
            vim.schedule(schedule)
        end
    end, key_ns)
end

function M.setup(user_opts)
    opts = vim.tbl_deep_extend('force', vim.deepcopy(defaults), user_opts or {})
    ns = ns or vim.api.nvim_create_namespace('kitty-markdown-headings')
    group = group or vim.api.nvim_create_augroup('KittyMarkdownHeadings', { clear = true })
    if timer then
        timer:stop()
        timer:close()
    end
    timer = vim.uv.new_timer()

    if render_timer then
        render_timer:stop()
        render_timer:close()
    end
    render_timer = vim.uv.new_timer()

    install_redraw_listener()

    vim.api.nvim_create_autocmd({
        'BufEnter',
        'BufWinEnter',
        'CursorMoved',
        'CursorMovedI',
        'TextChanged',
        'TextChangedI',
        'InsertLeave',
        'ModeChanged',
        'WinEnter',
        'WinScrolled',
        'WinResized',
        'VimResized',
        'TabEnter',
        'TabLeave',
        'WinClosed',
        'ColorScheme',
    }, {
        group = group,
        callback = schedule,
    })

    schedule()
end

return M
