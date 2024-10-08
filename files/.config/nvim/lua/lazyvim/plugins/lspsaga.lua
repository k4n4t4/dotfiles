return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    symbol_in_winbar = {
      enable = true,
    },
    outline = {
      layout = 'float',
    },
    callhierarchy = {
      layout = 'float',
    },
    code_action = {
      show_server_name = true,
    },
    ui = {
      border = 'single',
      code_action = '',
    },
  },
  event = 'VeryLazy',
  keys = {
    { mode = 'n', '<LEADER>go',  "<CMD>Lspsaga outline<CR>",                 desc = "Lspsaga Outline" },
    { mode = 'n', '<LEADER>gf',  "<CMD>Lspsaga finder<CR>",                  desc = "Lspsaga Finder" },
    { mode = 'n', '<LEADER>gc',  "<CMD>Lspsaga callhierarchy<CR>",           desc = "Lspsaga Callhierarchy" },
    { mode = 'n', '<LEADER>ga',  "<CMD>Lspsaga code_action<CR>",             desc = "Lspsaga CodeAction" },
    { mode = 'n', '<LEADER>gd',  "<CMD>Lspsaga peek_definition<CR>",         desc = "Lspsaga PeekDefinition" },
    { mode = 'n', '<LEADER>gt',  "<CMD>Lspsaga peek_type_definition<CR>",    desc = "Lspsaga PeekTypeDefinition" },
    { mode = 'n', '<LEADER>ggd', "<CMD>Lspsaga goto_definition<CR>",         desc = "Lspsaga GotoDefinition" },
    { mode = 'n', '<LEADER>ggt', "<CMD>Lspsaga goto_type_definition<CR>",    desc = "Lspsaga GotoTypeDefinition" },
    { mode = 'n', '<LEADER>g]',  "<CMD>Lspsaga diagnostic_jump_next<CR>",    desc = "Lspsaga DiagnosticJumpNext" },
    { mode = 'n', '<LEADER>g[',  "<CMD>Lspsaga diagnostic_jump_prev<CR>",    desc = "Lspsaga DiagnosticJumpPrev" },
    { mode = 'n', '<LEADER>gd',  "<CMD>Lspsaga show_cursor_diagnostics<CR>", desc = "Lspsaga ShowCursorDiagnostics" },
    { mode = 'n', '<LEADER>gD',  "<CMD>Lspsaga show_buf_diagnostics<CR>",    desc = "Lspsaga ShowBufDiagnostics" },
    { mode = 'n', '<LEADER>gt',  "<CMD>Lspsaga term_toggle<CR>",             desc = "Lspsaga FloatTerminal" },
    { mode = 'n', '<LEADER>gh',  "<CMD>Lspsaga hover_doc<CR>",               desc = "Lspsaga Hover" },
    { mode = 'n', '<LEADER>gr',  "<CMD>Lspsaga rename<CR>",                  desc = "Lspsaga Rename" },
  },
}
