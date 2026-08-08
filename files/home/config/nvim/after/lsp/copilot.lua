local function get_indent(text)
    local match = text:match('^%s+')
    return match or ''
end

local function normalize_indent(text)
    local indent = get_indent(text)
    if not indent or #indent == 0 then
        return text
    end

    local lines = {}
    for line in text:gmatch('[^\r\n]+') do
        if line:find('^' .. indent) then
            table.insert(lines, line:sub(#indent + 1))
        else
            table.insert(lines, line)
        end
    end
    return table.concat(lines, '\n')
end

return {
    root_dir = function(bufnr, callback)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local basename = vim.fs.basename(fname)
        local disable_patterns = {
            '%f[%w]env%f[%W]',
            '%f[%w]conf%f[%W]',
            '%f[%w]local%f[%W]',
            '%f[%w]private%f[%W]',
        }
        for _, pattern in ipairs(disable_patterns) do
            if basename:lower():match(pattern) then
                return
            end
        end

        local root_markers = {
            '.git',
            'Makefile',
            'package.json',
            'Cargo.toml',
            'go.mod',
            'pyproject.toml',
            'setup.py',
            'requirements.txt',
        }
        local root_dir = vim.fs.root(bufnr, root_markers)
        if root_dir then callback(root_dir) end
    end,
    on_init = function(client)
        -- Convert inline completion to regular completion

        client.server_capabilities.completionProvider = { triggerCharacters = {} }
        local orig_request = client.request
        client.request = function(self, method, params, handler, bufnr)
            if method ~= 'textDocument/completion' then
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

            return orig_request(self, 'textDocument/inlineCompletion', inline_params, function(err, result, ctx)
                if err or not result or not result.items then
                    handler(err, { isIncomplete = false, items = {} }, ctx)
                    return
                end

                local items = {}
                for _, item in ipairs(result.items) do
                    local label = item.insertText:gsub('^%s+', ''):gsub('%s+$', '')
                    local normalized_text = normalize_indent(item.insertText)
                    local language = vim.bo[target_bufnr].filetype or vim.bo[target_bufnr].ft or 'code'
                    local documentation = string.format('```%s\n%s\n```', language, normalized_text)

                    table.insert(items, {
                        label = label,
                        insertText = item.insertText,
                        textEdit = item.range and {
                            newText = item.insertText,
                            range = item.range,
                        } or nil,
                        kind_icon = "",
                        kind_hl = "Normal",
                        score_offset = 600,
                        detail = item.detail or "Copilot",
                        documentation = {
                            kind = 'markdown',
                            value = documentation,
                        },
                        menu = "[Copilot]"
                    })
                end

                handler(err, { isIncomplete = false, items = items }, ctx)
            end, target_bufnr)
        end
    end,
}
