return function()
    local which_key = require "which-key"
    which_key.setup {
        preset = 'modern';
        delay = 1000;
        win = {
            border = 'single';
        };
    };

    which_key.add {
        { "cs*",  group = "+surround change" },
        { "ds*",  group = "+surround delete" },
        { "ys*",  group = "+surround add" },
        { "S",    group = "+surround visual",  mode = "v" },
    }
end
