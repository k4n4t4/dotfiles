return function()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  local project_actions = require "telescope._extensions.project.actions"
  telescope.setup {
    defaults = {
      borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' };
      mappings = {
        n = {
          ['<ESC>'] = actions.close;
        };
      };
    };
    extensions = {
      fzf = {
        fuzzy = true;
        override_generic_sorter = true;
        override_file_sorter = true;
        case_mode = 'smart_case';
      };
      project = {
        base_dirs = {
          '~/dotfiles';
        };
        hidden_files = true;
        theme = "dropdown";
        order_by = "asc";
        search_by = "title";
        sync_with_nvim_tree = true;
        on_project_selected = function(prompt_bufnr)
          project_actions.change_working_directory(prompt_bufnr, false)
          require('neo-tree.command').execute {
            action = "focus";
          }
        end;
        mappings = {
          n = {
            ['d'] = project_actions.delete_project;
            ['r'] = project_actions.rename_project;
            ['c'] = project_actions.add_project;
            ['C'] = project_actions.add_project_cwd;
            ['f'] = project_actions.find_project_files;
            ['b'] = project_actions.browse_project_files;
            ['s'] = project_actions.search_in_project_files;
            ['R'] = project_actions.recent_project_files;
            ['o'] = project_actions.next_cd_scope;
            ['w'] = project_actions.change_working_directory;
            ['W'] = project_actions.change_workspace;
          };
        }
      };
    };
  }
  telescope.load_extension "fzf"
  telescope.load_extension "project"
end
