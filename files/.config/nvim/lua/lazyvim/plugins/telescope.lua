return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-project.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "stevearc/aerial.nvim",
  },
  config = function()
    local telescope = require "telescope"
    local actions = require "telescope.actions"
    local project_actions = require "telescope._extensions.project.actions"
    telescope.setup {
      defaults = {
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        mappings = {
          n = {
            ['<ESC>'] = actions.close,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        aerial = {
          format_symbol = function(symbol_path, filetype)
            if filetype == "json" or filetype == "yaml" then
              return table.concat(symbol_path, '.')
            else
              return symbol_path[#symbol_path]
            end
          end,
          show_columns = 'both',
        },
        project = {
          base_dirs = {
            '~/dotfiles',
          },
          hidden_files = true,
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          sync_with_nvim_tree = true,
          on_project_selected = function(prompt_bufnr)
            project_actions.change_working_directory(prompt_bufnr, false)
            require('neo-tree.command').execute {
              action = "focus",
            }
          end,
          mappings = {
            n = {
              ['d'] = project_actions.delete_project,
              ['r'] = project_actions.rename_project,
              ['c'] = project_actions.add_project,
              ['C'] = project_actions.add_project_cwd,
              ['f'] = project_actions.find_project_files,
              ['b'] = project_actions.browse_project_files,
              ['s'] = project_actions.search_in_project_files,
              ['R'] = project_actions.recent_project_files,
              ['w'] = project_actions.change_working_directory,
              ['o'] = project_actions.next_cd_scope,
            },
            i = {
              ['<c-d>'] = project_actions.delete_project,
              ['<c-v>'] = project_actions.rename_project,
              ['<c-a>'] = project_actions.add_project,
              ['<c-A>'] = project_actions.add_project_cwd,
              ['<c-f>'] = project_actions.find_project_files,
              ['<c-b>'] = project_actions.browse_project_files,
              ['<c-s>'] = project_actions.search_in_project_files,
              ['<c-r>'] = project_actions.recent_project_files,
              ['<c-l>'] = project_actions.change_working_directory,
              ['<c-o>'] = project_actions.next_cd_scope,
              ['<c-w>'] = project_actions.change_workspace,
            }
          }
        },
      },
    }
    telescope.load_extension "fzf"
    telescope.load_extension "aerial"
    telescope.load_extension "project"
  end,
  cmd = "Telescope",
  keys = {
    { mode = 'n', "<LEADER>tt", "<CMD>Telescope<CR>",                           desc = "Telescope" },
    { mode = 'n', "<LEADER>tk", "<CMD>Telescope keymaps<CR>",                   desc = "Telescope Keymaps" },
    { mode = 'n', "<LEADER>tf", "<CMD>Telescope find_files<CR>",                desc = "Telescope Find Files" },
    { mode = 'n', "<LEADER>tg", "<CMD>Telescope live_grep<CR>",                 desc = "Telescope Live Grep" },
    { mode = 'n', "<LEADER>tb", "<CMD>Telescope buffers<CR>",                   desc = "Telescope Buffers" },
    { mode = 'n', "<LEADER>th", "<CMD>Telescope help_tags<CR>",                 desc = "Telescope Help Tags" },
    { mode = 'n', "<LEADER>t/", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope Current Buffer Fuzzy Finder" },
    { mode = 'n', "<LEADER>ta", "<CMD>Telescope aerial<CR>",                    desc = "Telescope Aerial" },
    { mode = 'n', "<LEADER>tz", "<CMD>Telescope fzf<CR>",                       desc = "Telescope fzf" },
    { mode = 'n', "<LEADER>tp", "<CMD>Telescope project<CR>",                   desc = "Telescope Project" },
  },
}
