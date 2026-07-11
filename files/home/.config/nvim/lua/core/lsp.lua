local info = require "utils.info"

local mason_bin = info.path.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

vim.lsp.enable {
    "html",
    "emmet_language_server",
    "omnisharp",
    "jdtls",
    "ts_ls",
    "powershell_es",
    "lua_ls",
    "bashls",
}

-- filetype
vim.filetype.add {
    extension = {
        jsp = "jsp",
    },
}

-- treesitter
vim.treesitter.language.register("html", "jsp")


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
    callback = vim.schedule_wrap(function(event)
        local set = vim.keymap.set

        local buf = event.buf
        if vim.b[buf].lsp_keymap_mapped then return end
        vim.b[buf].lsp_keymap_mapped = true

        set('n', '<Leader>lf', vim.lsp.buf.format, { buffer = buf, desc = "Format" })
        set('n', '<Leader>ln', vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
        set('n', '<Leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = "Definition" })
        set('n', '<Leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = "Type Definition" })
        set('n', '<Leader>lc', vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
        set('n', '<Leader>lr', vim.lsp.buf.references, { buffer = buf, desc = "References" })
        set('n', '<Leader>li', vim.lsp.buf.implementation, { buffer = buf, desc = "Implementation" })
        set('n', '<Leader>lD', vim.lsp.buf.declaration, { buffer = buf, desc = "Declaration" })

        local lsp = require "utils.lsp"

        set('n', '<Leader>lh', function()
            lsp.hover {
                border = "none",
                focusable = true,
                winblend = 10,
            }
        end, { buffer = buf, desc = "Hover" })
        set('n', '<Leader>ls', function()
            lsp.signature_help {
                border = "none",
                focusable = true,
                winblend = 10,
            }
        end, { buffer = buf, desc = "Signature Help" })
        set('n', 'K', function()
            lsp.hover {
                border = "none",
                focusable = true,
                winblend = 10,
            }
        end, { buffer = buf, desc = "Hover" })
        set('n', '<C-k>', function()
            lsp.signature_help {
                border = "none",
                focusable = true,
                winblend = 10,
            }
        end, { buffer = buf, desc = "Signature Help" })

        set('n', 'gd', function() vim.lsp.buf.definition() end, { buffer = buf, desc = "Definition" })
        set('n', 'gi', function() vim.lsp.buf.implementation() end, { buffer = buf, desc = "Implementation" })
    end),
})
