return {
    filetypes = { "lua", "neovim-lua" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                pathStrict = true,
                path = { "?.lua", "?/init.lua" },
            },
        },
    },
}
