local uv = vim.uv or vim.loop

local function path_contains(path, target)
    if not path or not target then return false end
    return string.find(path, target, 1, true) ~= nil
end

local function in_config_dir(path)
    return path_contains(path, vim.fn.stdpath("config"))
end

local function in_nvim_repo(path)
    return path_contains(path, "/nvim")
end

local function is_nvim_related()
    local path = uv.cwd()
    return in_config_dir(path) or in_nvim_repo(path)
end

return {
    filetypes = { "lua", "neovim-lua" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                pathStrict = true,
                path = { "?.lua", "?/init.lua" },
            },
            workspace = {
                library = is_nvim_related() and (
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
                globals = is_nvim_related() and {
                    "vim"
                } or {},
                disable = is_nvim_related() and {
                    "duplicate-doc-field",
                    "duplicate-doc-alias",
                    "missing-fields",
                } or {},
            }
        },
    },
}
