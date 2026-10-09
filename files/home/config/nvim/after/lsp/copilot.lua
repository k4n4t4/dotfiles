local function get_indent(text)
    local match = text:match "^%s+"
    return match or ""
end

local function normalize_indent(text)
    local indent = get_indent(text)
    if not indent or #indent == 0 then
        return text
    end

    local lines = {}
    for line in text:gmatch "[^\r\n]+" do
        if line:find("^" .. indent) then
            table.insert(lines, line:sub(#indent + 1))
        else
            table.insert(lines, line)
        end
    end
    return table.concat(lines, "\n")
end

local function byte_col(bufnr, row, character)
    local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""

    local ok, col = pcall(vim.str_byteindex, line, "utf-16", character)

    if ok then
        return math.min(col, #line)
    end

    return math.min(character, #line)
end

local function setup_completion(client)
    client.server_capabilities.completionProvider = { triggerCharacters = {} }
    local orig_request = client.request
    client.request = function(self, method, params, handler, bufnr)
        if method ~= "textDocument/completion" then
            return orig_request(self, method, params, handler, bufnr)
        end

        local target_bufnr = bufnr or vim.uri_to_bufnr(params.textDocument.uri)

        local inline_params = {
            textDocument = params.textDocument,
            position = params.position,
            context = { triggerKind = 2 },
            formattingOptions = {
                tabSize = vim.bo[target_bufnr].tabstop,
                insertSpaces = vim.bo[target_bufnr].expandtab,
            },
        }

        return orig_request(self, "textDocument/inlineCompletion", inline_params, function(err, result, ctx)
            if err or not result or not result.items then
                handler(err, { isIncomplete = false, items = {} }, ctx)
                return
            end

            local items = {}
            for _, item in ipairs(result.items) do
                local label = item.insertText:gsub("^%s+", ""):gsub("%s+$", "")
                local normalized_text = normalize_indent(item.insertText)
                local language = vim.bo[target_bufnr].filetype or vim.bo[target_bufnr].ft or "code"
                local documentation = string.format("```%s\n%s\n```", language, normalized_text)

                table.insert(items, {
                    label = label,
                    insertText = item.insertText,
                    textEdit = item.range and {
                        newText = item.insertText,
                        range = item.range,
                    } or nil,
                    kind_icon = "",
                    kind_hl = "Normal",
                    kind_name = "Copilot",
                    kind = 15,
                    score_offset = 55,
                    detail = item.detail or "Copilot",
                    documentation = {
                        kind = "markdown",
                        value = documentation,
                    },
                    menu = "[Copilot]",
                })
            end

            handler(err, { isIncomplete = false, items = items }, ctx)
        end, target_bufnr)
    end
end

local nes
do
    local M = {}

    M.suggestions = {}

    M.client = nil
    M.namespace = nil
    M.group = nil

    local function bump(bufnr)
        local g = (vim.b[bufnr].nes_generation or 0) + 1
        vim.b[bufnr].nes_generation = g
        return g
    end

    local function is_stale(bufnr, generation, version)
        if not vim.api.nvim_buf_is_valid(bufnr) or vim.b[bufnr].nes_generation ~= generation then
            return true
        end
        return version ~= nil and vim.lsp.util.buf_versions[bufnr] ~= version
    end

    local function get_win(bufnr)
        local winid = vim.fn.bufwinid(bufnr)
        if winid ~= -1 then
            return winid
        end
    end

    local function notify(msg, level)
        vim.notify("[Copilot NES] " .. msg, level)
    end

    local function normalize_edit(bufnr, item)
        local range = item.range
        local text = item.newText or item.text

        if
            type(range) ~= "table"
            or type(range.start) ~= "table"
            or type(range["end"]) ~= "table"
            or type(text) ~= "string"
        then
            return
        end

        local srow, erow = range.start.line, range["end"].line

        if srow < 0 or erow < srow or erow >= vim.api.nvim_buf_line_count(bufnr) then
            return
        end

        local scol = byte_col(bufnr, srow, range.start.character)
        local ecol = byte_col(bufnr, erow, range["end"].character)

        if table.concat(vim.api.nvim_buf_get_text(bufnr, srow, scol, erow, ecol, {}), "\n") == text then
            return
        end

        local display, whole = text, false

        if ecol == 0 and erow > srow then
            erow = erow - 1
            ecol = #(vim.api.nvim_buf_get_lines(bufnr, erow, erow + 1, false)[1] or "")
            display = display:gsub("\n$", "")
            whole = true
        elseif srow == erow and scol == 0 and ecol == 0 and srow > 0 and text:sub(-1) == "\n" then
            srow = srow - 1
            erow = srow
            scol = #(vim.api.nvim_buf_get_lines(bufnr, srow, srow + 1, false)[1] or "")
            ecol = scol
            display = "\n" .. text:sub(1, -2)
        end

        return {
            srow = srow,
            scol = scol,
            erow = erow,
            ecol = ecol,
            text = display,
            whole = whole,
            command = item.command,
            lsp = { range = range, newText = text },
        }
    end

    local function attach(bufnr)
        vim.api.nvim_clear_autocmds {
            group = M.group,
            buf = bufnr,
            event = { "ModeChanged", "TextChanged" },
        }

        local timer = assert(vim.uv.new_timer())

        vim.api.nvim_create_autocmd({ "ModeChanged", "TextChanged" }, {
            group = M.group,
            buf = bufnr,
            callback = function(e)
                if e.event == "ModeChanged" and e.match ~= "i:n" then
                    return
                end

                M.clear(bufnr)
                timer:stop()
                timer:start(
                    300,
                    0,
                    vim.schedule_wrap(function()
                        if vim.api.nvim_buf_is_valid(bufnr) then
                            M.request(bufnr)
                        end
                    end)
                )
            end,
        })

        local cmd = vim.api.nvim_buf_create_user_command

        cmd(bufnr, "CopilotNESRequest", function()
            M.request(bufnr)
        end, { desc = "Request a Copilot next edit suggestion" })
        cmd(bufnr, "CopilotNESAccept", function()
            M.accept_suggestion(bufnr)
        end, { desc = "Accept the pending Copilot next edit" })
        cmd(bufnr, "CopilotNESMove", function(o)
            M.move_suggestion(bufnr, o.bang)
        end, { bang = true, desc = "Jump to the next Copilot NES (! for previous)" })
        cmd(bufnr, "CopilotNESClear", function()
            M.clear(bufnr)
        end, { desc = "Clear the pending Copilot next edit" })

        if vim.bo[bufnr].buftype == "" then
            M.client:notify("textDocument/didFocus", { textDocument = { uri = vim.uri_from_bufnr(bufnr) } })
        end
    end

    function M.setup(client)
        M.client = client
        M.namespace = vim.api.nvim_create_namespace(("CopilotNES_%d"):format(client.id))
        M.group = vim.api.nvim_create_augroup(("CopilotNES_%d"):format(client.id), { clear = true })

        vim.api.nvim_set_hl(0, "CopilotNesAdd", { link = "DiffAdd", default = true })
        vim.api.nvim_set_hl(0, "CopilotNesDelete", { link = "DiffDelete", default = true })
        vim.api.nvim_set_hl(0, "CopilotNesIcon", { link = "DiagnosticHint", default = true })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = M.group,
            callback = function(ev)
                if ev.data and ev.data.client_id == client.id then
                    attach(ev.buf)
                end
            end,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
            group = M.group,
            callback = function(ev)
                if ev.data and ev.data.client_id == client.id then
                    M.clear(ev.buf)
                end
            end,
        })

        vim.api.nvim_create_autocmd("BufWipeout", {
            group = M.group,
            callback = function(ev)
                M.suggestions[ev.buf] = nil
            end,
        })
    end

    function M.clear(bufnr)
        bump(bufnr)
        M.clear_suggestion(bufnr)
    end

    function M.request(bufnr)
        local generation = bump(bufnr)
        M.clear_suggestion(bufnr)
        return M.request_nes(bufnr, generation)
    end

    function M.clear_suggestion(bufnr)
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        vim.api.nvim_buf_clear_namespace(bufnr, M.namespace, 0, -1)

        M.suggestions[bufnr] = nil
    end

    function M.add_virtual_lines(bufnr, row, lines, above)
        local virtual_lines = {}

        for _, line in ipairs(lines) do
            table.insert(virtual_lines, {
                { line, "CopilotNesAdd" },
            })
        end

        if #virtual_lines == 0 then
            return
        end

        vim.api.nvim_buf_set_extmark(bufnr, M.namespace, row, 0, {
            virt_lines = virtual_lines,
            virt_lines_above = above or false,
            priority = 201,
            strict = false,
        })
    end

    function M.render_edit(bufnr, e)
        local old_lines = vim.api.nvim_buf_get_lines(bufnr, e.srow, e.erow + 1, false)
        local is_insertion = not e.whole and e.srow == e.erow and e.scol == e.ecol
        local is_deletion = e.text == ""

        if is_insertion and is_deletion then
            return false
        end

        if is_deletion then
            vim.api.nvim_buf_set_extmark(bufnr, M.namespace, e.srow, e.scol, {
                end_row = e.erow,
                end_col = e.ecol,
                hl_group = "CopilotNesDelete",
                priority = 200,
                strict = false,
            })
            return e.srow
        end

        local new_lines = vim.split(e.text, "\n", { plain = true })

        if is_insertion and #new_lines == 1 then
            vim.api.nvim_buf_set_extmark(bufnr, M.namespace, e.srow, e.scol, {
                virt_text = { { e.text, "CopilotNesAdd" } },
                virt_text_pos = "inline",
                priority = 201,
            })
            return e.srow
        end

        if is_insertion and #new_lines > 1 and e.scol == #old_lines[1] and new_lines[1] == "" then
            M.add_virtual_lines(bufnr, e.srow, vim.list_slice(new_lines, 2), false)
            return e.srow
        end

        if is_insertion and #new_lines > 1 and e.scol == 0 and new_lines[#new_lines] == "" then
            M.add_virtual_lines(bufnr, e.srow, vim.list_slice(new_lines, 1, #new_lines - 1), true)
            return math.max(e.srow - 1, 0)
        end

        local last_old = old_lines[#old_lines] or ""

        new_lines[1] = (old_lines[1] or ""):sub(1, e.scol) .. new_lines[1]
        new_lines[#new_lines] = new_lines[#new_lines] .. last_old:sub(e.ecol + 1)

        vim.api.nvim_buf_set_extmark(bufnr, M.namespace, e.srow, 0, {
            end_row = e.erow,
            end_col = #last_old,
            hl_group = "CopilotNesDelete",
            priority = 200,
            strict = false,
        })

        M.add_virtual_lines(bufnr, e.erow, new_lines, false)

        return e.srow
    end

    function M.cursor_matches_edit(bufnr, e, cursor_row, cursor_col)
        if e.srow == e.erow and e.scol == e.ecol then
            if cursor_row ~= e.srow then
                return false
            end

            if cursor_col == e.scol then
                return true
            end

            local line = vim.api.nvim_buf_get_lines(bufnr, e.srow, e.srow + 1, false)[1] or ""

            return e.scol == #line and #line > 0 and cursor_col == vim.fn.byteidx(line, vim.fn.strchars(line) - 1)
        end

        if cursor_row < e.srow or cursor_row > e.erow then
            return false
        end

        if cursor_row == e.srow and cursor_col < e.scol then
            return false
        end

        return not (cursor_row == e.erow and cursor_col >= e.ecol)
    end

    function M.request_nes(bufnr, generation)
        if is_stale(bufnr, generation) then
            return
        end

        local winid = get_win(bufnr)

        if not winid then
            return
        end

        local version = vim.lsp.util.buf_versions[bufnr]

        if version == nil then
            return
        end

        local params = vim.lsp.util.make_position_params(winid, "utf-16")

        ---@diagnostic disable-next-line: inject-field
        params.textDocument.version = version

        local ok, request_err = M.client:request("textDocument/copilotInlineEdit", params, function(err, result)
            if is_stale(bufnr, generation, version) then
                return
            end

            if err then
                notify("Request failed: " .. vim.inspect(err), vim.log.levels.ERROR)
                return
            end

            if type(result) ~= "table" or type(result.edits) ~= "table" or #result.edits == 0 then
                return
            end

            M.clear_suggestion(bufnr)

            local edits = {}

            for _, item in ipairs(result.edits) do
                local edit = normalize_edit(bufnr, item)
                local sign_row = edit and M.render_edit(bufnr, edit)

                if sign_row then
                    edit.sign_row = sign_row
                    table.insert(edits, edit)
                end
            end

            if #edits == 0 then
                return
            end

            table.sort(edits, function(a, b)
                if a.srow ~= b.srow then
                    return a.srow < b.srow
                end
                return a.scol < b.scol
            end)

            M.suggestions[bufnr] = { edits = edits, version = version }

            for _, edit in ipairs(edits) do
                vim.api.nvim_buf_set_extmark(bufnr, M.namespace, edit.srow, 0, {
                    sign_text = " ",
                    sign_hl_group = "CopilotNesIcon",
                    priority = 201,
                    strict = false,
                })
                M.client:notify("textDocument/didShowInlineEdit", { item = { command = edit.command } })
            end
        end, bufnr)

        if not ok then
            notify("Could not send request: " .. vim.inspect(request_err), vim.log.levels.ERROR)
        end
    end

    local function current(bufnr)
        local state = M.suggestions[bufnr]

        if state and state.version == vim.lsp.util.buf_versions[bufnr] then
            return state.edits
        end
    end

    function M.has_suggestion(bufnr)
        return current(bufnr) ~= nil
    end

    local function pending(bufnr)
        local edits, winid = current(bufnr), get_win(bufnr)

        if not (edits and winid) then
            return
        end

        local cursor = vim.api.nvim_win_get_cursor(winid)

        return edits, winid, cursor[1] - 1, cursor[2]
    end

    function M.request_or_move_or_accept(bufnr, backward, cycle)
        if not M.has_suggestion(bufnr) then
            return M.request(bufnr)
        end

        M.accept_or_move(bufnr, backward, cycle)
    end

    function M.accept_or_move(bufnr, backward, cycle)
        local edits, _, row, col = pending(bufnr)

        if not edits then
            return
        end

        for _, e in ipairs(edits) do
            if M.cursor_matches_edit(bufnr, e, row, col) then
                return M.accept_suggestion(bufnr)
            end
        end

        M.move_suggestion(bufnr, backward, cycle)
    end

    function M.move_suggestion(bufnr, backward, cycle)
        local edits, winid, row, col = pending(bufnr)

        if not edits then
            return
        end

        local step = backward and -1 or 1
        local target

        for i = backward and #edits or 1, backward and 1 or #edits, step do
            local e = edits[i]
            local d = e.srow == row and e.scol - col or e.srow - row

            if d * step > 0 then
                target = e
                break
            end
        end

        target = target or (cycle and (backward and edits[#edits] or edits[1]))

        if target then
            vim.api.nvim_win_set_cursor(winid or 0, { target.srow + 1, target.scol })
        end
    end

    function M.accept_suggestion(bufnr)
        local edits, _, row, col = pending(bufnr)

        if not edits then
            return
        end

        local selected

        for _, e in ipairs(edits) do
            if M.cursor_matches_edit(bufnr, e, row, col) then
                -- 複数一致したら推測しない
                if selected then
                    return
                end

                selected = e
            end
        end

        if not selected then
            return
        end

        local ok, err = pcall(vim.lsp.util.apply_text_edits, { selected.lsp }, bufnr, "utf-16")

        M.clear_suggestion(bufnr)

        if not ok then
            notify("Apply failed: " .. tostring(err), vim.log.levels.ERROR)
            return
        end

        local command = selected.command

        if type(command) == "table" and type(command.command) == "string" then
            M.client:request("workspace/executeCommand", {
                command = command.command,
                arguments = command.arguments or {},
            }, function(request_err)
                if request_err then
                    notify("Accept notification failed: " .. vim.inspect(request_err), vim.log.levels.WARN)
                end
            end, bufnr)
        end
    end

    nes = M
end

return {
    root_dir = function(bufnr, callback)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local basename = vim.fs.basename(fname)
        local disable_patterns = {
            "%f[%w]env%f[%W]",
            "%f[%w]conf%f[%W]",
            "%f[%w]local%f[%W]",
            "%f[%w]private%f[%W]",
        }
        for _, pattern in ipairs(disable_patterns) do
            if basename:lower():match(pattern) then
                return
            end
        end

        local root_markers = {
            ".git",
            "Makefile",
            "package.json",
            "Cargo.toml",
            "go.mod",
            "pyproject.toml",
            "setup.py",
            "requirements.txt",
        }
        local root_dir = vim.fs.root(bufnr, root_markers)
        if root_dir then
            callback(root_dir)
        end
    end,
    on_init = function(client)
        setup_completion(client)
        nes.setup(client)

        vim.api.nvim_create_autocmd("LspAttach", {
            group = nes.group,
            callback = function(ev)
                if not (ev.data and ev.data.client_id == client.id) then
                    return
                end

                vim.keymap.set("n", "<c-j>", function()
                    nes.request_or_move_or_accept(ev.buf, false, true)
                end, { buffer = ev.buf, desc = "Copilot NES: request or move or accept" })

                vim.keymap.set("n", "<c-s-j>", function()
                    nes.request_or_move_or_accept(ev.buf, true, true)
                end, { buffer = ev.buf, desc = "Copilot NES: request or move or accept (previous)" })

                vim.keymap.set("n", "<leader>jr", function()
                    nes.request(ev.buf)
                end, { buffer = ev.buf, desc = "Copilot NES: request" })

                vim.keymap.set("n", "<leader>ja", function()
                    nes.accept_suggestion(ev.buf)
                end, { buffer = ev.buf, desc = "Copilot NES: accept" })

                vim.keymap.set("n", "<leader>jc", function()
                    nes.clear(ev.buf)
                end, { buffer = ev.buf, desc = "Copilot NES: clear" })

                vim.keymap.set("n", "]n", function()
                    nes.move_suggestion(ev.buf)
                end, { buffer = ev.buf, desc = "Copilot NES: next" })

                vim.keymap.set("n", "[n", function()
                    nes.move_suggestion(ev.buf, true)
                end, { buffer = ev.buf, desc = "Copilot NES: previous" })
            end,
        })
    end,
}
