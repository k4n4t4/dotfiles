return {
    "nvim-telescope/telescope.nvim";
    dependencies = {
        "nvim-lua/plenary.nvim";
        "nvim-telescope/telescope-project.nvim";
        "nvim-telescope/telescope-ui-select.nvim";
        {
            "nvim-telescope/telescope-fzf-native.nvim";
            build = "make";
        };
    };
    config = function()
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
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        previewer = false;
                        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' };
                    }
                };
                ["fzf"] = {
                    fuzzy = true;
                    override_generic_sorter = true;
                    override_file_sorter = true;
                    case_mode = 'smart_case';
                };
                ["project"] = {
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
        telescope.load_extension "ui-select"
        telescope.load_extension "fzf"
        telescope.load_extension "project"
    end;
    cmd = "Telescope";
    keys = {
        { mode = 'n', "<LEADER>tt", "<CMD>Telescope<CR>",                           desc = "Telescope" },
        { mode = 'n', "<LEADER>tk", "<CMD>Telescope keymaps<CR>",                   desc = "Telescope Keymaps" },
        { mode = 'n', "<LEADER>tr", "<CMD>Telescope oldfiles<CR>",                   desc = "Telescope Oldfiles" },
        { mode = 'n', "<LEADER>tf", "<CMD>Telescope find_files<CR>",                desc = "Telescope Find Files" },
        { mode = 'n', "<LEADER>tg", "<CMD>Telescope live_grep<CR>",                 desc = "Telescope Live Grep" },
        { mode = 'n', "<LEADER>tb", "<CMD>Telescope buffers<CR>",                   desc = "Telescope Buffers" },
        { mode = 'n', "<LEADER>th", "<CMD>Telescope help_tags<CR>",                 desc = "Telescope Help Tags" },
        { mode = 'n', "<LEADER>t/", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope Current Buffer Fuzzy Finder" },
        { mode = 'n', "<LEADER>tz", "<CMD>Telescope fzf<CR>",                       desc = "Telescope fzf" },
        { mode = 'n', "<LEADER>tp", "<CMD>Telescope project<CR>",                   desc = "Telescope Project" },
    };
}
