---@diagnostic disable: undefined-global


-- options

vim.opt.eventignore = "FileType"
vim.opt.loadplugins = false
vim.opt.number = false
vim.opt.ambiwidth = "single"
vim.opt.wrap = true
vim.opt.display = "lastline"
vim.opt.breakat = " ^I!@*-+;:,./?"
vim.opt.linebreak = false
vim.opt.breakindent = false
vim.opt.showbreak = ""
vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:full"
vim.opt.cmdheight = 0
vim.opt.cmdwinheight = 10
vim.opt.laststatus = 0
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.list = false
vim.opt.belloff = "all"
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.shortmess:append 'I'
vim.opt.smarttab    = true
vim.opt.expandtab   = true
vim.opt.tabstop     = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth  = 2
vim.opt.smartindent = true
vim.opt.autoindent  = true
vim.opt.hlsearch    = true
vim.opt.incsearch   = true
vim.opt.wrapscan    = true
vim.opt.ignorecase  = true
vim.opt.smartcase   = true
vim.opt.inccommand  = "split"
vim.opt.swapfile    = false
vim.opt.undofile    = false
vim.opt.backup      = false
vim.opt.writebackup = false
vim.opt.mouse       = "a"
vim.opt.clipboard:append "unnamedplus"
vim.opt.autoread      = true
vim.opt.hidden        = true
vim.opt.confirm       = true
vim.opt.splitbelow    = true
vim.opt.splitright    = true
vim.opt.virtualedit   = "block"
vim.opt.gdefault      = false
vim.opt.whichwrap     = "b,s,h,l,~,<,>,[,]"
vim.opt.backspace     = { "indent", "eol", "nostop" }
vim.opt.nrformats     = { "bin", "octal", "hex" }
vim.opt.showmatch     = true
vim.opt.matchtime     = 1
vim.opt.matchpairs    = { "(:)", "{:}", "[:]", "<:>" }
vim.opt.completeopt   = { "menuone", "preview" }
vim.opt.viewoptions   = { "folds", "cursor", "curdir" }
vim.opt.synmaxcol     = 1000
vim.opt.termguicolors = true
vim.opt.background    = "dark"
vim.opt.scrollback    = 100000
vim.opt.scrolloff     = 0
vim.opt.title         = true


-- color

vim.cmd.colorscheme "vim"

vim.cmd.highlight { "Normal", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "NormalNC", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "Folded", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "FoldColumn", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "NonText", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "LineNr", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "CursorLineNr", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "SignColumn", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "CursorLineSign", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "TabLine", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "TabLineFill", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "EndOfBuffer", "guibg=none", "ctermbg=none" }

vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,t:block-Cursor"
vim.cmd.highlight { "Cursor", "guifg=#000000", "guibg=#0090ff" }

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank { hlgroup = "Visual", timeout = 150 }
    end,
})


-- keymap

for _, k in ipairs({
    "i", "a", "I", "A", "o", "O", "c", "C", "s", "S", "R",
    "gi", "gI", "<Insert>", "x", "X", "r", "p", "P", "u", "<C-r>", "J", "~", "<C-a>", "<C-x>", "."
}) do
    vim.keymap.set("n", k, "<nop>")
end
vim.keymap.set("n", "q", "<cmd>qa!<cr>")
vim.keymap.set('n', "<ESC>", "<CMD>qa!<CR>")


-- initialize

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        local top = tonumber(vim.env.KP_TOP)
        local row = top + tonumber(vim.env.KP_LINE) - 1
        local col = tonumber(vim.env.KP_COL)

        local tmp = vim.fn.tempname()

        vim.cmd.write({ tmp, bang = true })

        vim.api.nvim_create_autocmd("TermClose", {
            once = true,
            callback = function(e)
                vim.api.nvim_buf_set_lines(e.buf, -2, -1, false, {})
                vim.cmd(("normal! %dGzt%dG%d|"):format(top, row, col))
                vim.bo.modifiable = false
            end,
        })

        vim.cmd.terminal("cat " .. vim.fn.shellescape(tmp))
    end,
})
