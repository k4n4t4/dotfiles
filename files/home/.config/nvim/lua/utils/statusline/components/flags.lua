local function get_opt(bufnr, name)
    return vim.api.nvim_get_option_value(name, { buf = bufnr })
end

local function is_readonly(b)
    return vim.api.nvim_buf_is_valid(b) and get_opt(b, "readonly") or false
end

local function is_modifiable(b)
    return vim.api.nvim_buf_is_valid(b) and get_opt(b, "modifiable") or false
end

local function modified(b)
    return vim.api.nvim_buf_is_valid(b) and get_opt(b, "modified") or false
end

return function(opts)
    local default_props = {
        hi = "StlFileFlag",
        preview = "p",
        readonly = "r",
        modified = "+",
        unmodifiable = "-",
    }
    local props = opts and vim.tbl_deep_extend("force", default_props, opts) or default_props

    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

    local flags = ""

    if vim.o.previewwindow then flags = flags .. props.preview end

    if is_readonly(bufnr) then
        flags = flags .. props.readonly
    elseif is_modifiable(bufnr) then
        if modified(bufnr) then
            flags = flags .. props.modified
        end
    else
        flags = flags .. props.unmodifiable
    end

    if flags == "" then
        return nil
    end

    return {
        hl = props.hi,
        content = flags,
    }
end
