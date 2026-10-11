local M = {}

local function get_chat(bufnr)
    return require("codecompanion").buf_get_chat(bufnr or vim.api.nvim_get_current_buf())
end

local function get_option(bufnr, category, option_id)
    local chat = get_chat(bufnr)
    local connection = chat and chat.acp_connection
    if not connection then
        return chat
    end

    for _, option in ipairs(connection:get_config_options()) do
        if (not category or option.category == category) and (not option_id or option.id == option_id) then
            return chat, connection, option
        end
    end

    return chat, connection
end

local function flatten(option)
    return require("codecompanion.acp").flatten_config_options(option.options or {})
end

function M.current(bufnr, category, option_id)
    local _, _, option = get_option(bufnr, category, option_id)
    if not option then
        return nil
    end

    local name = option.currentValue
    for _, value in ipairs(flatten(option)) do
        if value.value == option.currentValue then
            name = value.name
            break
        end
    end

    return {
        id = option.id,
        category = option.category,
        value = option.currentValue,
        name = name,
    }
end

function M.list(bufnr, category, option_id)
    local ACP = require "codecompanion.acp"

    if option_id then
        local _, _, option = get_option(bufnr, category, option_id)
        return option and flatten(option) or {}
    end

    local chat = get_chat(bufnr)
    local connection = chat and chat.acp_connection
    if not connection then
        return {}
    end

    local result = {}
    for _, option in ipairs(connection:get_config_options()) do
        if not category or option.category == category then
            result[#result + 1] = {
                id = option.id,
                category = option.category,
                type = option.type,
                currentValue = option.currentValue,
                options = ACP.flatten_config_options(option.options or {}),
            }
        end
    end

    return result
end

function M.model(bufnr)
    local chat = get_chat(bufnr)
    local connection = chat and chat.acp_connection
    return connection and connection:get_models() or nil
end

function M.set(bufnr, category, value, option_id)
    local chat, connection, option = get_option(bufnr, category, option_id)
    if not connection or not option then
        return false
    end

    if not connection:set_config_option(option.id, value) then
        return false
    end

    chat:update_metadata()
    return true
end

function M.select_session_options(chat)
    if not chat.acp_connection then
        vim.notify("ACP connection not found", vim.log.levels.ERROR)
        return
    end

    ---@diagnostic disable-next-line: missing-fields
    local command = require("codecompanion.interactions.chat.slash_commands.builtin.acp_session_options").new {
        Chat = chat,
    }

    command:execute()
end

return M
