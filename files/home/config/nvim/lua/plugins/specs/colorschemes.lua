local schemes = {
    { name = "tokyonight-moon", plugin = "tokyonight.nvim" },
    { name = "kanagawa-wave",   plugin = "kanagawa.nvim" },
    { name = "gruvbox",         plugin = "gruvbox.nvim" },
    { name = "onedark",         plugin = "onedark.nvim" },
    { name = "colorful",        plugin = "mini.base16" }
}

vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        math.randomseed(os.time())
        local selected = schemes[math.random(1, #schemes)]

        local ok_lazy, lazy = pcall(require, "lazy")
        if ok_lazy then
            lazy.load({ plugins = { selected.plugin } })
        end

        local status_ok, _ = pcall(vim.cmd.colorscheme, selected.name)
        if not status_ok then
            vim.notify("Failed to load colorscheme: " .. selected.name, vim.log.levels.ERROR)
        end
    end
})

return {
    { -- tokyonight
        "folke/tokyonight.nvim",
    },
    { -- kanagawa
        "rebelot/kanagawa.nvim",
    },
    { -- gruvbox
        "ellisonleao/gruvbox.nvim",
    },
    { -- onedark
        "navarasu/onedark.nvim",
    },
    { -- solarized osaka
        "craftzdog/solarized-osaka.nvim",
    },
    { -- mini base16
        "nvim-mini/mini.base16",
    },
}
