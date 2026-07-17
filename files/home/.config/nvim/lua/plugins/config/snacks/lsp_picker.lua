local M = {}

function M.lsp_picker()
    local snacks = require "snacks"

    local items = {}

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        local item = {
            name = client.name,
            id = client.id,
        }
        table.insert(items, item)
    end

    snacks.picker.select(
        items,
        {
            format_item = function(item)
                if not item then return "" end
                return string.format("%s (ID: %d)", item.name, item.id)
            end,
        },
        function(item, _)
            if not item then return end

            local client = vim.lsp.get_client_by_id(item.id)

            if not client then
                vim.notify("No LSP client found with ID: " .. item.id, vim.log.levels.WARN,
                { title = "LSP List" })
                return
            end

            local sub_items = {
                { text = "Restart LSP" },
                { text = "Stop LSP" },
            }

            snacks.picker.select(
                sub_items,
                {
                    format_item = function(sub_item)
                        if not sub_item then return "" end
                        return sub_item.text
                    end,
                },
                function(sub_item, _)
                    if not sub_item then return end
                    if sub_item.text == "Stop LSP" then
                        vim.notify("Stopping LSP: " .. client.name, vim.log.levels.INFO,
                        { title = "LSP List" })
                        client:stop()
                    elseif sub_item.text == "Restart LSP" then
                        vim.notify("Restarting LSP: " .. client.name, vim.log.levels.INFO,
                        { title = "LSP List" })
                        client:_restart()
                    end
                end
            )
        end
    )
end

function M.lsp_picker_all()
    local mason_registry = require("mason-registry")
    local mason_lspconfig = require("mason-lspconfig")

    if not mason_registry then return end
    if not mason_lspconfig then return end

    local mlsp_mappings = mason_lspconfig.get_mappings()

    local snacks = require "snacks"

    local items = {}

    for _, package in ipairs(mason_registry.get_installed_packages()) do
        local plsp_name = mlsp_mappings.package_to_lspconfig[package.name]
        if plsp_name then
            local enabled = vim.lsp.is_enabled(plsp_name)
            local config = vim.lsp.config[plsp_name]
            local item = {
                name = package.name,
                file = package:get_install_path(),
                enabled = enabled,
                config = config,
            }
            table.insert(items, item)
        end
    end

    snacks.picker.select(
        items,
        {
            format_item = function(item)
                if not item then return "" end
                local status = item.enabled and "[Enabled]" or "[Disabled]"
                local file_types = item.config and item.config.filetypes and
                table.concat(item.config.filetypes, ", ") or "N/A"
                return string.format("%s %s : %s", item.name, status, file_types)
            end,
        },
        function(item, _)
            if not item then return end

            local package = mason_registry.get_package(item.name)
            local plsp_name = mlsp_mappings.package_to_lspconfig[package.name]
            if not plsp_name then
                vim.notify("No LSP mapping found for package: " .. package.name, vim.log.levels.WARN,
                { title = "Mason" })
                return
            end

            local enabled = vim.lsp.is_enabled(plsp_name)

            local sub_items = {}

            if enabled then
                sub_items = {
                    { text = "Restart LSP" },
                    { text = "Disable LSP" },
                }
            else
                sub_items = {
                    { text = "Enable LSP" },
                }
            end

            snacks.picker.select(
                sub_items,
                {
                    format_item = function(sub_item)
                        if not sub_item then return "" end
                        return sub_item.text
                    end,
                },
                function(sub_item, _)
                    if not sub_item then return end
                    if sub_item.text == "Enable LSP" then
                        vim.notify("Enabling LSP: " .. plsp_name, vim.log.levels.INFO,
                        { title = "Mason" })
                        vim.lsp.enable(plsp_name)
                    elseif sub_item.text == "Disable LSP" then
                        vim.notify("Disabling LSP: " .. plsp_name, vim.log.levels.INFO,
                        { title = "Mason" })
                        local client = vim.lsp.get_clients({ name = plsp_name })[1]
                        if client then
                            client:stop()
                            vim.lsp.enable(plsp_name, false)
                        end
                    elseif sub_item.text == "Restart LSP" then
                        vim.notify("Restarting LSP: " .. plsp_name, vim.log.levels.INFO,
                        { title = "Mason" })
                        local client = vim.lsp.get_clients({ name = plsp_name })[1]
                        if client then
                            client:stop()
                            vim.lsp.enable(plsp_name)
                        end
                    end
                end
            )
        end
    )
end

return M
