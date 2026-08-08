return {
    root_dir = function(bufnr, callback)
        local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
        local disable_patterns = { 'env', 'conf', 'local', 'private' }
        local is_disabled = vim.iter(disable_patterns):any(function(pattern)
            return string.match(fname, pattern)
        end)
        if is_disabled then
            return
        end
        local root_dir = vim.fs.root(bufnr, { '.git' })
        if root_dir then
            return callback(root_dir)
        end
    end,
    on_init = function(client)
        -- inline completion to completion

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
                    table.insert(items, {
                        label = label,
                        insertText = item.insertText,
                        textEdit = item.range and { newText = item.insertText, range = item.range } or nil,
                        kind = item.kind or 1,
                        score_offset = 600,
                    })
                end

                handler(err, { isIncomplete = false, items = items }, ctx)
            end, target_bufnr)
        end
    end,
}
