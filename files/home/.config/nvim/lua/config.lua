local config = require("utils.local_config")

config.set_config {
    colorscheme = {
        name = "onedark";
        transparent = true;
    };
    number = {
        enable = true;
        relative = true;
        toggle_relative_number = true;
    };
    mouse = true;
    shell = "fish";
}

config.load(config.config)
