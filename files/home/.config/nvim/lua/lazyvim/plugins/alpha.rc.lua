return {
  "goolord/alpha-nvim";
  enabled = false;
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                   ]],
      [[█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█]],
      [[█ █   █             █   █         █]],
      [[█ █▀▄ █  ▄▄▄  ▄▀▀▀▄ █   █ ▀ ▄▄▄▄  █]],
      [[█ █ ▀▄█ █▄▄▄█ █   █ ▀▄ ▄▀ █ █ █ █ █]],
      [[█ █   █ ▀▄▄▄▄ ▀▄▄▄▀  ▀▄▀  █ █ █ █ █]],
      [[█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█]],
      (function()
        local space = [[NeoVim                             ]]

        local version = vim.version()
        local format = {
          "Version ",
          version.major,
          ".",
          version.minor,
          ".",
          version.patch,
        }
        local str = table.concat(format, "")

        if #space < #str then
          return str
        end
        return string.sub(space, 1, #space - #str) .. str
      end)(),
    }

    local lazy = require("lazy")
    local stats = lazy.stats()

    dashboard.section.footer.val = {
      "Plugin Count: " .. stats.count,
    }

    dashboard.section.buttons.val = {
      dashboard.button("n", "  New File", "<CMD>enew<CR>"),
      dashboard.button("r", "  Recent File", "<CMD>Telescope oldfiles<CR>"),
      dashboard.button("f", "󰈞  Find File", "<CMD>Telescope find_files<CR>"),
      dashboard.button("g", "󱎸  Find Text", "<CMD>Telescope live_grep<CR>"),
      dashboard.button("t", "  Projects", "<CMD>Telescope project<CR>"),
      dashboard.button("p", "  Plugins", "<CMD>Lazy<CR>"),
      dashboard.button("u", "  Update Plugins", "<CMD>Lazy sync<CR>"),
      dashboard.button("s", "  Settings", "<CMD>e $MYVIMRC<CR><CMD>silent :cd %:p:h<CR>"),
      dashboard.button("q", "  Quit", "<CMD>qa<CR>"),
    }
    dashboard.section.buttons.opts = {
      cursor = 0,
      spacing = 1,
    }

    require("alpha").setup(dashboard.config)
  end;
  event = 'VimEnter';
}
