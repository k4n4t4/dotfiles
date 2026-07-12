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
    local info = require("utils.info").buf

    local flags = ""

    if vim.o.previewwindow then
        flags = flags .. props.preview
    end

    if info.is_readonly(bufnr) then
        flags = flags .. props.readonly
    elseif info.is_modifiable(bufnr) then
        if info.modified(bufnr) then
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
