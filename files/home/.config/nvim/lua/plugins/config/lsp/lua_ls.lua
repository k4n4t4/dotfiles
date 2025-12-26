local cwd = vim.uv.cwd()
local is_nvim = cwd ~= nil and (
    string.find(cwd, vim.fn.stdpath("config"), 1, true) ~= nil or
    string.find(cwd, "/nvim", 1, true) ~= nil
)

return {
    filetypes = { "lua" };
    settings = {
        Lua = {
            cmd = { "lua-language-server" };
            runtime = {
                version = "LuaJIT";
                pathStrict = true;
                path = { "?.lua", "?/init.lua" };
            };
            workspace = {
                library = is_nvim and (
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
                globals = is_nvim and { "vim" } or {};
                disable = is_nvim and { "duplicate-doc-field" };
            }
        };
    };
}
