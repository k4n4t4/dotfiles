local M = {}

---@alias LocalConfig {
---    shell?: string;
---    colorscheme?: {
---        name?: string;
---        transparent?: boolean;
---    };
---    number?: {
---        enable?: boolean;
---        relative?: boolean;
---        toggle_relative_number?: boolean;
---    } | boolean;
---    mouse?: string|boolean;
---    shell?: string;
---    run?: fun();
---}

---@type LocalConfig
M.config = {}

---@param config LocalConfig?
---@return nil
function M.set_config(config)
    M.config = config or {}
end

---@param config LocalConfig?
---@return nil
function M.setup(config)
    M.set_config(config)

    vim.api.nvim_create_autocmd("VimEnter", {
        once = true;
        callback = function()
            M.load(M.config)
        end;
    })
end

---@param config LocalConfig?
---@return nil
function M.load(config)
    config = config or {}

    if config then
        if config.shell then
            vim.opt.shell = config.shell
        end

        if config.colorscheme then
            if config.colorscheme.transparent then
                local plugins_transparent = require("utils.transparent")
                plugins_transparent.setup {}
            end
            if config.colorscheme.name then
                pcall(vim.cmd.colorscheme, config.colorscheme.name)
            end
        end

        if config.number then
            if config.number.enable == false then
                vim.opt.number = false
            else
                vim.opt.number = true
            end
            if config.number.relative == false then
                vim.opt.relativenumber = false
                require("utils.toggle_relnumber").disable()
            else
                vim.opt.relativenumber = true
                if config.number.toggle_relative_number then
                    require("utils.toggle_relnumber").enable()
                end
            end
        elseif config.number == false then
            vim.opt.number = false
        end

        if config.mouse then
            if config.mouse == true then
                vim.opt.mouse = "a"
            else
                vim.opt.mouse = config.mouse
            end
        else
            vim.opt.mouse = ""
        end

        if config.run then
            config.run()
        end
    end
end


return M
