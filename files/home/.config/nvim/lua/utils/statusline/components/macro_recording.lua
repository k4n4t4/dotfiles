return function(opts)
    local default_props = {
        prefix = "@",
        hi = "StlMacro",
    }
    local props = opts and vim.tbl_deep_extend("force", default_props, opts) or default_props

    local macro = vim.fn.reg_recording()
    if macro == "" then
        return nil
    end

    return {
        hl = props.hi,
        content = props.prefix .. macro,
    }
end

