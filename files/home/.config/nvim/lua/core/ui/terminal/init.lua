local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.7)
  local height = opts.height or math.floor(vim.o.lines * 0.7)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  vim.wo[win].winblend = opts.winblend or 0

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window {
        buf = state.floating.buf;
        winblend = 10;
    }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.term()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end


local keymap = vim.keymap
local set = keymap.set

-- terminal
set('t', '<esc>', "<C-\\><C-n>")
set('n', '<leader>kk', "<cmd>belowright 10split<cr><cmd>terminal<cr>", { desc = "Terminal" })
set("n", "<leader>kf", toggle_terminal, { desc = "Terminal (floating)" })
set('n', '<leader>K', "<cmd>terminal<cr>", { desc = "Terminal (full)" })
