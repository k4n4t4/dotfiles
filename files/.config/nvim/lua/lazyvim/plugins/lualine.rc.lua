return {
  'nvim-lualine/lualine.nvim',
  enabled = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VeryLazy',
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {
          'mode',
          {
            function()
              local format = {}
              local macro = vim.fn.reg_recording()
              if macro ~= "" then
                table.insert(format, "@" .. macro)
              end
              return table.concat(format, "")
            end
          }
        },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'selectioncount', 'progress' },
        lualine_z = { 'location' }
      },
    }
  end,
}
