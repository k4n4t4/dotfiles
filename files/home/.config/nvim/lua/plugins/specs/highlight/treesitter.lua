return {
    {
        "nvim-treesitter/nvim-treesitter";
        build = ":TSUpdate";
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    pcall(vim.treesitter.start)
                end;
            })
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    vim.wo[0][0].foldmethod = 'expr'
                    vim.opt.foldlevel = 99
                    vim.opt.foldlevelstart = 99
                end;
            })
        end;
        -- event = 'VeryLazy';
        lazy = false
    }
}
