local info = require "utils.info"

return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                pathStrict = true,
                path = { "?.lua", "?/init.lua" },
            },
            workspace = {
                library = info.path.is_nvim_related() and (
                    vim.list_extend(
                        vim.api.nvim_get_runtime_file("lua", true),
                        {
                            vim.env.VIMRUNTIME,
                            "${3rd}/luv/library",
                            "${3rd}/busted/library",
                            "${3rd}/luassert/library",
                        }
                    )
                ) or {},
                checkThirdParty = false,
            },
            diagnostics = {
                globals = info.path.is_nvim_related() and {
                    "vim"
                } or {},
                disable = info.path.is_nvim_related() and {
                    "duplicate-doc-field",
                    "duplicate-doc-alias",
                    "missing-fields",
                } or {},
            }
        },
    },
}
