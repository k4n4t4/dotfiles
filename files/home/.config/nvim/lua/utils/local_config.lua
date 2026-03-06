local M = {}

---@alias FiletypeConfig {
---    indent?: { expandtab?: boolean, tabstop?: number, shiftwidth?: number };
---    wrap?: boolean;
---    colorcolumn?: string;
---    spell?: boolean;
---    textwidth?: number;
---    number?: boolean;
---    signcolumn?: string|boolean;
---    cursorline?: boolean;
---    run?: fun();
---}

---@alias LocalConfig {
---    shell?: string;
---    colorscheme?: {
---        name?: string;
---        transparent?: boolean | TransparentConfig;
---    };
---    number?: {
---        enable?: boolean;
---        relative?: boolean;
---        toggle_relative_number?: boolean;
---    } | boolean;
---    mouse?: string|boolean;
---    indent?: {
---        expandtab?: boolean;
---        tabstop?: number;
---        shiftwidth?: number;
---    };
---    scrolloff?: number | { vertical?: number, horizontal?: number };
---    clipboard?: string|false;
---    cursorline?: boolean | { enable?: boolean, opt?: string };
---    signcolumn?: string|boolean;
---    cmdheight?: number;
---    laststatus?: number;
---    pumblend?: number;
---    pumheight?: number;
---    splitbelow?: boolean;
---    splitright?: boolean;
---    undofile?: boolean;
---    wrap?: boolean;
---    diagnostic?: vim.diagnostic.Opts;
---    ui?: {
---        statusline?: boolean;
---        tabline?: boolean;
---        statuscolumn?: boolean;
---    };
---    filetype?: table<string, FiletypeConfig>;
---    run?: fun();
---}

---@type LocalConfig
M.config = {}

M.group = vim.api.nvim_create_augroup("LocalConfig", { clear = true })

--- Stores the given config as the active local config without applying it.
---@param config LocalConfig?
---@return nil
function M.set_config(config)
    M.config = config or {}
end

--- Stores and immediately applies the given local config.
---@param config LocalConfig?
---@return nil
function M.setup(config)
    M.set_config(config)
    M.load(M.config)
end

--- Applies buffer-local options for filetype-specific config.
---@param ft_config FiletypeConfig
---@return nil
function M.load_local(ft_config)
    local o = vim.opt_local

    if ft_config.indent then
        if ft_config.indent.expandtab ~= nil then o.expandtab = ft_config.indent.expandtab end
        if ft_config.indent.tabstop then o.tabstop = ft_config.indent.tabstop end
        if ft_config.indent.shiftwidth then o.shiftwidth = ft_config.indent.shiftwidth end
    end

    if ft_config.wrap ~= nil then o.wrap = ft_config.wrap end
    if ft_config.colorcolumn then o.colorcolumn = ft_config.colorcolumn end
    if ft_config.spell ~= nil then o.spell = ft_config.spell end
    if ft_config.textwidth then o.textwidth = ft_config.textwidth end
    if ft_config.number ~= nil then o.number = ft_config.number end

    if ft_config.signcolumn ~= nil then
        if ft_config.signcolumn == false then o.signcolumn = "no"
        elseif ft_config.signcolumn == true then o.signcolumn = "yes"
        else o.signcolumn = ft_config.signcolumn end
    end

    if ft_config.cursorline ~= nil then o.cursorline = ft_config.cursorline end

    if ft_config.run then ft_config.run() end
end

--- Applies the given local config.
---@param config LocalConfig?
---@return nil
function M.load(config)
    config = config or {}

    M.group = vim.api.nvim_create_augroup("LocalConfig", { clear = true })

    -- shell
    if config.shell then
        vim.opt.shell = config.shell
    end

    -- colorscheme
    if config.colorscheme then
        if config.colorscheme.name then
            pcall(vim.cmd.colorscheme, config.colorscheme.name)
        end
        if config.colorscheme.transparent then
            local t = require("utils.transparent")
            if config.colorscheme.transparent == true then
                t.enable()
            elseif type(config.colorscheme.transparent) == "table" then
                t.enable(config.colorscheme.transparent --[[@as TransparentConfig]])
            end
        end
    end

    -- number (boolean shorthand or table)
    if config.number ~= nil then
        if config.number == false then
            vim.opt.number = false
        elseif config.number == true then
            vim.opt.number = true
        else
            vim.opt.number = config.number.enable ~= false
            if config.number.relative == false then
                vim.opt.relativenumber = false
                require("utils.toggle_relnumber").disable()
            else
                vim.opt.relativenumber = true
                if config.number.toggle_relative_number then
                    require("utils.toggle_relnumber").enable()
                end
            end
        end
    end

    -- mouse (true="a", false=""/"", nil → "")
    if config.mouse ~= nil then
        if config.mouse == true then
            vim.opt.mouse = "a"
        elseif config.mouse == false then
            vim.opt.mouse = ""
        else
            vim.opt.mouse = config.mouse
        end
    else
        vim.opt.mouse = ""
    end

    -- indent
    if config.indent then
        if config.indent.expandtab ~= nil then vim.opt.expandtab = config.indent.expandtab end
        if config.indent.tabstop then vim.opt.tabstop = config.indent.tabstop end
        if config.indent.shiftwidth then vim.opt.shiftwidth = config.indent.shiftwidth end
    end

    -- scrolloff (number for both, or table for vertical/horizontal)
    if config.scrolloff ~= nil then
        if type(config.scrolloff) == "number" then
            vim.opt.scrolloff = config.scrolloff
            vim.opt.sidescrolloff = config.scrolloff
        elseif type(config.scrolloff) == "table" then
            if config.scrolloff.vertical ~= nil then vim.opt.scrolloff = config.scrolloff.vertical end
            if config.scrolloff.horizontal ~= nil then vim.opt.sidescrolloff = config.scrolloff.horizontal end
        end
    end

    -- clipboard (false to disable)
    if config.clipboard ~= nil then
        if config.clipboard == false then
            vim.opt.clipboard = ""
        else
            vim.opt.clipboard = config.clipboard
        end
    end

    -- cursorline (boolean or { enable, opt })
    if config.cursorline ~= nil then
        if type(config.cursorline) == "boolean" then
            vim.opt.cursorline = config.cursorline
        elseif type(config.cursorline) == "table" then
            if config.cursorline.enable ~= nil then vim.opt.cursorline = config.cursorline.enable end
            if config.cursorline.opt then vim.opt.cursorlineopt = config.cursorline.opt end
        end
    end

    -- signcolumn (boolean or string)
    if config.signcolumn ~= nil then
        if config.signcolumn == false then
            vim.opt.signcolumn = "no"
        elseif config.signcolumn == true then
            vim.opt.signcolumn = "yes"
        else
            vim.opt.signcolumn = config.signcolumn
        end
    end

    -- cmdheight
    if config.cmdheight ~= nil then vim.opt.cmdheight = config.cmdheight end

    -- laststatus
    if config.laststatus ~= nil then vim.opt.laststatus = config.laststatus end

    -- pumblend
    if config.pumblend ~= nil then vim.opt.pumblend = config.pumblend end

    -- pumheight
    if config.pumheight ~= nil then vim.opt.pumheight = config.pumheight end

    -- splitbelow / splitright
    if config.splitbelow ~= nil then vim.opt.splitbelow = config.splitbelow end
    if config.splitright ~= nil then vim.opt.splitright = config.splitright end

    -- undofile
    if config.undofile ~= nil then vim.opt.undofile = config.undofile end

    -- wrap
    if config.wrap ~= nil then vim.opt.wrap = config.wrap end

    -- diagnostic
    if config.diagnostic then
        vim.diagnostic.config(config.diagnostic)
    end

    -- ui components (disable by clearing vim options)
    if config.ui then
        if config.ui.statusline == false then
            vim.opt.statusline = " "
            vim.opt.laststatus = 0
            vim.opt.showcmdloc = "last"
            if config.cmdheight == nil then
                vim.opt.cmdheight = 1
            end
        end
        if config.ui.tabline == false then
            vim.opt.showtabline = 0
        end
        if config.ui.statuscolumn == false then
            vim.opt.statuscolumn = ""
            if config.signcolumn == nil then
                vim.opt.signcolumn = "auto"
            end
        end
    end

    -- Re-apply deferred settings after core/options.lua's Ready handler
    local has_deferred = config.splitbelow ~= nil or config.splitright ~= nil
        or config.clipboard ~= nil or config.pumblend ~= nil
        or config.pumheight ~= nil or config.diagnostic

    if has_deferred then
        vim.api.nvim_create_autocmd("User", {
            group = M.group,
            pattern = "Ready",
            once = true,
            callback = function()
                if config.splitbelow ~= nil then vim.opt.splitbelow = config.splitbelow end
                if config.splitright ~= nil then vim.opt.splitright = config.splitright end
                if config.clipboard ~= nil then
                    vim.opt.clipboard = config.clipboard == false and "" or config.clipboard
                end
                if config.pumblend ~= nil then vim.opt.pumblend = config.pumblend end
                if config.pumheight ~= nil then vim.opt.pumheight = config.pumheight end
                if config.diagnostic then
                    local current = vim.diagnostic.config() or {}
                    vim.diagnostic.config(vim.tbl_deep_extend("force", current, config.diagnostic))
                end
            end,
        })
    end

    -- filetype-specific settings
    if config.filetype then
        vim.api.nvim_create_autocmd("FileType", {
            group = M.group,
            pattern = vim.tbl_keys(config.filetype),
            callback = function(args)
                local ft_config = config.filetype[args.match]
                if ft_config then
                    M.load_local(ft_config)
                end
            end,
        })
    end

    -- custom function
    if config.run then
        config.run()
    end
end

return M
