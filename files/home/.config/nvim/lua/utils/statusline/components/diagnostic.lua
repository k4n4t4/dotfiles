return function(opts)
    local default_props = {
        ERROR = { icon = "!", hi = "DiagnosticError" },
        WARN  = { icon = "*", hi = "DiagnosticWarn" },
        INFO  = { icon = "i", hi = "DiagnosticInfo" },
        HINT  = { icon = "?", hi = "DiagnosticHint" },
    }
    local props = opts and vim.tbl_deep_extend("force", default_props, opts) or default_props

    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local severity_list = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
    }

    local components = {}
    for _, severity in ipairs(severity_list) do
        local diags = vim.diagnostic.get(bufnr, { severity = severity })
        if diags and #diags > 0 then
            local name = vim.diagnostic.severity[severity]
            local prop = props[name] or { icon = "·", hi = props.ERROR.hi }
            table.insert(components, {
                hl = prop.hi,
                content = prop.icon .. #diags
            })
        end
    end

    if #components == 0 then
        return nil
    end

    return components
end
