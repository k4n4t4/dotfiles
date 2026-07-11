local M = {}

local info = require("utils.info")
local fs = require("utils.fs")

local group = vim.api.nvim_create_augroup("Utils_lsp", { clear = true })


function M.hover(opts)
    local params = vim.lsp.util.make_position_params(0, 'utf-8')
    vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result)
        if not (result and result.contents) then return end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        if vim.tbl_isempty(markdown_lines) then return end
        local _, winid = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", opts or {})

        if opts and opts.winblend then
            vim.wo[winid].winblend = opts.winblend
        end
    end)
end

function M.signature_help(opts)
    local params = vim.lsp.util.make_position_params(0, 'utf-8')
    vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(_, result)
        if not (result) then return end
        local markdown_lines = vim.lsp.util.convert_signature_help_to_markdown_lines(result, vim.bo.filetype) or {}
        if vim.tbl_isempty(markdown_lines) then return end
        local _, winid = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", opts or {})

        if opts and opts.winblend then
            vim.wo[winid].winblend = opts.winblend
        end
    end)
end

--- Returns a list of available null-ls source names for the current buffer's filetype.
--- @return string[] List of null-ls source names
function M.get_null_ls_sources()
    local sources = require "null-ls.sources"
    local availables = {}
    for _, available in pairs(sources.get_available(vim.bo.filetype)) do
        table.insert(availables, available.name)
    end
    return availables
end

--- Returns active LSP client names and null-ls sources for a buffer.
---@param bufnr number
---@return string[], table<string, string[]>
function M.get(bufnr)
    local clients = {}
    local others = {}
    for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
        if client.name == "null-ls" then
            others["null-ls"] = M.get_null_ls_sources()
        else
            table.insert(clients, client.name)
        end
    end
    return clients, others
end

return M
