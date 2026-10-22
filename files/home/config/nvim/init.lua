vim.loader.enable()

if vim.g.vscode then
    require "hosts.vscode"
    return
end

if vim.g.neovide then
    require "hosts.neovide"
end

require "core"
require "plugins"

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
    pattern = "*.md",
    callback = function(_)
        local um = require "utils.ui_mark"
        local ns = um.create_namespace "heading-overlay"
        local src = vim.api.nvim_get_namespaces()["render-markdown.nvim"]

        um.mirror(0, ns, src, {
            filter = function(d)
                return d.hl_group and d.hl_group:match "^RenderMarkdownH%dBg$"
            end,
            render = function(_)
                return "\27]66;s=2;★\7"
            end,
        })
    end,
})
