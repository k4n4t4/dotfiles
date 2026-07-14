local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


-- highlight yank area
autocmd("TextYankPost", {
    group = augroup("TextYankPost", { clear = true }),
    callback = function()
        vim.highlight.on_yank { hlgroup = "Visual", timeout = 150 }
    end,
})

-- fcitx5
autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = vim.schedule_wrap(function()
        if vim.fn.executable("fcitx5") == 1 then
            autocmd({ "InsertLeave", "CmdlineLeave" }, {
                group = augroup("fcitx5", { clear = true }),
                callback = function()
                    local out = vim.fn.system { "fcitx5-remote" }
                    if out == "2\n" then
                        vim.fn.system { "fcitx5-remote", "-c" }
                    end
                end,
            })
        end
    end),
})

-- Windows IME
autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = vim.schedule_wrap(function()
        if vim.env.WSL_DISTRO_NAME ~= nil then
            autocmd({ "InsertLeave", "CmdlineLeave" }, {
                group = augroup("Windows IME", { clear = true }),
                callback = function()
                    vim.fn.jobstart({
                        'powershell.exe', '-NoProfile', '-NonInteractive', '-Command',
                        [[
                            Add-Type -TypeDefinition ]]..[[@"
                                using System;
                                using System.Runtime.InteropServices;
                                public class IME {
                                    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
                                    [DllImport("imm32.dll")]  public static extern IntPtr ImmGetDefaultIMEWnd(IntPtr hWnd);
                                    [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
                                }
                            ]].."\n"..[["@
                            $hwnd   = [IME]::GetForegroundWindow()
                            $imeWnd = [IME]::ImmGetDefaultIMEWnd($hwnd)
                            [IME]::SendMessage($imeWnd, 0x283, [IntPtr]0x6, [IntPtr]0)
                        ]],
                    })
                end,
            })
        end
    end),
})

-- restore cursor position
autocmd("BufReadPost", {
    group = augroup("RestoreCursorPosition", { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- unlist some filetypes and map q to close
autocmd("FileType", {
    group = augroup("UnlistSomeFileType", { clear = true }),
    pattern = {
        "help",
        "man",
        "lspinfo",
        "checkhealth",
        "qf",
        "query",
        "scratch",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- toggle relative number
local group = augroup("toggle_relative_number", { clear = true })

autocmd("InsertEnter", {
    group = group,
    callback = function()
        if vim.opt_local.number:get() then
            vim.opt_local.relativenumber = false
        end
    end,
})

autocmd("InsertLeave", {
    group = group,
    callback = function()
        if vim.opt_local.number:get() then
            vim.opt_local.relativenumber = true
        end
    end,
})
