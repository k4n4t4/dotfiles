return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "stevearc/aerial.nvim",
  },
  config = function()
    local telescope = require "telescope"
    local actions = require "telescope.actions"
    telescope.setup {
      defaults = {
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        aerial = {
          format_symbol = function(symbol_path, filetype)
            if filetype == "json" or filetype == "yaml" then
              return table.concat(symbol_path, ".")
            else
              return symbol_path[#symbol_path]
            end
          end,
          show_columns = "both",
        }
      },
    }
    telescope.load_extension "fzf"
    telescope.load_extension "aerial"
  end,
  keys = {
    { mode = "n", "<LEADER>t",  "<CMD>Telescope<CR>",                           desc = "Telescope" },
    { mode = "n", "<LEADER>tt", "<CMD>Telescope<CR>",                           desc = "Telescope" },
    { mode = "n", "<LEADER>tk", "<CMD>Telescope keymaps<CR>",                   desc = "Telescope Keymaps" },
    { mode = "n", "<LEADER>tf", "<CMD>Telescope find_files<CR>",                desc = "Telescope Find Files" },
    { mode = "n", "<LEADER>tg", "<CMD>Telescope live_grep<CR>",                 desc = "Telescope Live Grep" },
    { mode = "n", "<LEADER>tb", "<CMD>Telescope buffers<CR>",                   desc = "Telescope Buffers" },
    { mode = "n", "<LEADER>th", "<CMD>Telescope help_tags<CR>",                 desc = "Telescope Help Tags" },
    { mode = "n", "<LEADER>t/", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope Current Buffer Fuzzy Finder" },
    { mode = "n", "<LEADER>ta", "<CMD>Telescope aerial<CR>",                    desc = "Telescope Aerial" },
    { mode = "n", "<LEADER>tz", "<CMD>Telescope fzf<CR>",                       desc = "Telescope fzf" },
  },
}
