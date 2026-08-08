--[[ GENERAL SETTINGS ]]--

-- exrc
vim.opt.exrc = true

-- default shell
vim.opt.shell = "fish"

-- nvim server
vim.env.EDITOR = "nvim --server \"$NVIM\" --remote-tab"

-- mouse
vim.opt.mouse = "a"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- filename characters
vim.opt.isfname:append("@-@")

-- encoding
vim.opt.fileencodings = {
    "utf-8",
    "utf-16",
    "iso-2022-jp",
    "euc-jp",
    "sjis",
    "cp932",
    "latin1",
    "ucs2le",
    "ucs-2",
    "default",
}

-- undo
vim.opt.undofile = true


--[[ EDITING SETTINGS ]]--

-- indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- virtualedit
vim.opt.virtualedit = "block"

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- incremental command
vim.opt.inccommand = "split"

-- winblend
vim.opt.winblend = 25

-- popup menu
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winborder = "none"
vim.opt.pumborder = "none"

-- complete
if true then
    vim.opt.complete:append('o')
    vim.opt.autocomplete = true
    vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy' }

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if not client then return end
            if not client:supports_method('textDocument/completion') then return end
            vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
                autotrigger = true,
                convert = function(item)
                    local abbr = item.label
                    abbr = abbr:gsub('%b()', ''):gsub('%b{}', '')
                    abbr = abbr:match('[%w_.]+.*') or abbr
                    abbr = #abbr > 15 and abbr:sub(1, 14) .. '…' or abbr
                    local menu = item.detail or ''
                    menu = #menu > 15 and menu:sub(1, 14) .. '…' or menu
                    return { abbr = abbr, menu = menu }
                end,
            })
        end,
    })

    vim.keymap.set({ 'i', 's' }, '<Tab>', function()
        if vim.fn.pumvisible() == 1 then
            return '<C-n>'
        elseif vim.snippet.active({ direction = 1 }) then
            return '<Cmd>lua vim.snippet.jump(1)<CR>'
        else
            return '<Tab>'
        end
    end, { expr = true })

    vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
        if vim.fn.pumvisible() == 1 then
            return '<C-p>'
        elseif vim.snippet.active({ direction = -1 }) then
            return '<Cmd>lua vim.snippet.jump(-1)<CR>'
        else
            return '<S-Tab>'
        end
    end, { expr = true })

    vim.keymap.set('i', '<CR>', function()
        if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ 'selected' }).selected ~= -1 then
            return '<C-y>'
        end
        return '<CR>'
    end, { expr = true })

    vim.keymap.set('i', '<C-e>', function()
        return vim.fn.pumvisible() == 1 and '<C-e>' or '<C-e>'
    end, { expr = true })

    vim.opt.wildmode = 'noselect:lastused,full'
    vim.opt.wildoptions = 'pum,fuzzy'
    vim.opt.wildignorecase = true

    vim.api.nvim_create_autocmd('CmdlineChanged', {
        pattern = { ':', '/', '?' },
        callback = function() vim.fn.wildtrigger() end,
    })

    local sig_timer = nil

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if not client or not client:supports_method('textDocument/signatureHelp') then return end

            local trigger_chars = (client.server_capabilities.signatureHelpProvider or {}).triggerCharacters or {}
            local retrigger_chars = (client.server_capabilities.signatureHelpProvider or {}).retriggerCharacters or {}
            local chars = vim.list_extend(vim.deepcopy(trigger_chars), retrigger_chars)

            vim.api.nvim_create_autocmd('InsertCharPre', {
                buffer = ev.buf,
                callback = function()
                    if vim.fn.pumvisible() == 1 then return end
                    local char = vim.v.char
                    if not vim.tbl_contains(chars, char) then return end
                    if sig_timer then sig_timer:stop() end
                    sig_timer = vim.defer_fn(function()
                        vim.lsp.buf.signature_help({ focusable = false })
                    end, 50)
                end,
            })
        end,
    })

    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'signature help' })
end


--[[ UI SETTINGS ]]--

-- line number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldcolumn = "auto"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- help
vim.opt.helpheight = 15

--statusline
vim.opt.cmdheight = 0
vim.opt.laststatus = 3

-- tabline
vim.opt.showtabline = 2

-- shortmess
vim.opt.shortmess:append 'I'

-- bell
vim.opt.belloff = "all"

-- scrolloff
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- listchars
vim.opt.list = true
vim.opt.listchars = {
    tab      = ">-",
    extends  = ">",
    precedes = "<",
    trail    = "-",
    nbsp     = "+",
    conceal  = "@",
}

-- fillchars
vim.opt.fillchars = {
    eob = " ",
    fold = "·",
    foldopen = "v",
    foldsep = " ",
    foldinner = " ",
    foldclose = ">",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
    diff = "┃",
    msgsep = "‾",
}

-- diagnostic
vim.diagnostic.config {
    virtual_text = true,
    update_in_insert = false,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "!",
            [vim.diagnostic.severity.WARN] = "*",
            [vim.diagnostic.severity.INFO] = "i",
            [vim.diagnostic.severity.HINT] = "?",
        },
    },
}
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "NONE", default = false })

-- filetype
vim.filetype.add {
    extension = {
        jsp = "jsp",
    },
}

-- treesitter
vim.treesitter.language.register("html", "jsp")
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
    callback = function(_)
        local ok, _ = pcall(vim.treesitter.start)
        if ok then
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt.foldtext = ""
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end
    end,
})

--[[ BUILTIN PLUGINS ]]--

-- disable builtin plugins
vim.opt.loadplugins = false

-- enable man plugin
vim.cmd.runtime("plugin/man.lua")
