return {
    cmd = {
        "julia",
        "--project=@.",
        "--startup-file=no",
        "--history-file=no",
        "-e",
        [[ using LanguageServer; runserver() ]],
    },
    cmd_env = {
        JULIA_LOAD_PATH = ((os.getenv "JULIA_LOAD_PATH" or "@:@stdlib"):gsub(
            ":@stdlib",
            ":" .. vim.fn.expand "~/.julia/environments/nvim-lspconfig" .. ":@stdlib"
        )),
    },
    settings = {
        julia = {
            format = {
                ops = true,
            },
        },
    },
    filetypes = { "julia" },
}
