local info = require "utils.info"

return {
    cmd = { "lua-language-server" };
    filetypes = { "lua" };
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT";
                pathStrict = true;
                path = { "?.lua", "?/init.lua" };
            };
            workspace = {
                library = info.is.nvim() and (
                    vim.list_extend(
                        vim.api.nvim_get_runtime_file("lua", true),
                        {
                            vim.env.VIMRUNTIME,
                            "${3rd}/luv/library",
                            "${3rd}/busted/library",
                            "${3rd}/luassert/library",
                        }
                    )
                ) or {};
                checkThirdParty = false;
            };
            diagnostics = {
                globals = info.is.nvim() and {
                    "vim"
                } or {};
                disable = info.is.nvim() and {
                    "duplicate-doc-field",
                    "duplicate-doc-alias",
                    "missing-fields",
                } or {};
            }
        };
    };
}
