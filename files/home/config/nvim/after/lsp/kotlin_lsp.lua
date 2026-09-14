return {
    root_dir = function(bufnr, on_dir)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local dir = vim.fs.dirname(bufname)

        on_dir(dir)
    end,

    single_file_support = true,
}
