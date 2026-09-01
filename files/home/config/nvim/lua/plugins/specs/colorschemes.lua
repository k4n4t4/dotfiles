local use_random_colorscheme = true

if use_random_colorscheme then
    local schemes = {
        { name = "tokyonight-moon", plugin = "tokyonight.nvim" },
        { name = "kanagawa-wave",   plugin = "kanagawa.nvim" },
        { name = "gruvbox",         plugin = "gruvbox.nvim" },
        { name = "onedark",         plugin = "onedark.nvim" },
        { name = "nightfox",        plugin = "nightfox.nvim" },
        { name = "solarized-osaka", plugin = "solarized-osaka.nvim" },
        { name = "colorful",        plugin = "mini.base16" }
    }

    vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
            math.randomseed(os.time())
            local selected = schemes[math.random(1, #schemes)]

            if selected.plugin then
                local ok_lazy, lazy = pcall(require, "lazy")
                if ok_lazy then
                    lazy.load({ plugins = { selected.plugin } })
                end
            end

            pcall(vim.cmd.colorscheme, selected.name)
        end
    })
end


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
        opts = { transparent = false },
    },
    { -- nightfox
        "EdenEast/nightfox.nvim",
    },
    { -- mini base16
        "nvim-mini/mini.base16",
    },
}
