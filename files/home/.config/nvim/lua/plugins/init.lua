local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local compiler = require("utils.compiler")
local specs_dir = vim.fn.stdpath("config") .. "/lua/plugins/specs/"
local cache_dir = vim.fn.stdpath("cache") .. "/lazy_specs/"

local files = vim.fn.glob(specs_dir .. "*/*.lua", false, true)
table.sort(files)

local entries = {}
for _, path in ipairs(files) do
    local key = path:sub(#specs_dir + 1):gsub("/", "_"):gsub("%.lua$", "") .. ".luac"
    table.insert(entries, { src = path, key = key })
end

local spec = compiler.load_merged(cache_dir, entries) or {}

require("lazy").setup {
    spec = spec,
    defaults = {
        lazy = true,
        version = false,
    },
    checker = {
        enabled = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            reset = true,
            disabled_plugins = {
                "tohtml",
                "editorconfig",
                "gzip",
                "man",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "osc52",
                "rplugin",
                "shada",
                "spellfile",
                "tarPlugin",
                "tutor",
                "zipPlugin",
            },
        },
    },
    change_detection = {
        enabled = true,
        notify = true,
    },
}

vim.keymap.set("n", "<leader>p", "<cmd>Lazy<CR>", { desc = "Plugin manager (lazy.nvim)" })
