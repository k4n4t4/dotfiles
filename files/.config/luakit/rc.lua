msg.info [[Loaded "rc.lua"]]


-- Unique Instance

local unique_instance = require "unique_instance"
unique_instance.open_links_in_new_window = false


-- Luakit

luakit.process_limit = 4


-- Soup

soup.accept_policy = "always"
soup.cookies_storage = luakit.data_dir .. "/cookies.db"


-- Lousy

local lousy = require "lousy"
lousy.theme.init(lousy.util.find_config("theme.lua"))


-- Downloads

local downloads = require "downloads"
local downloads_chrome = require "downloads_chrome"

downloads.default_dir = os.getenv("HOME") .. "/tmp"
downloads.add_signal("download-location", function (uri, file)
  if not file or file == "" then
    file = ( string.match(uri, "/([^/]+)$") or
      string.match(uri, "^%w+://(.+)") or
      string.gsub(uri, "/", "_") or "untitled")
  end
  return downloads.default_dir .. "/" .. file
end)


-- Binds and Modes

local modes = require "modes"
local binds = require "binds"


-- Settings

local settings = require "settings"
local settings_chrome = require "settings_chrome"

settings.window.home_page = "luakit://newtab"
settings.window.scroll_step = 20
settings.window.zoom_step = 0.2
settings.webview.zoom_level = 80
settings.window.close_with_last_tab = true

settings.window.search_engines.duckduckgo = "https://duckduckgo.com/?q=%s"
settings.window.search_engines.default = settings.window.search_engines.duckduckgo

settings.webview.user_agent = "Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0"


----------------------------------------------

local adblock = require "adblock"
local adblock_chrome = require "adblock_chrome"

local webinspector = require "webinspector"

local proxy = require "proxy"

local gopher = require "gopher"

local clear_data = require "clear_data"

local undoclose = require "undoclose"

local tabhistory = require "tabhistory"

local userscripts = require "userscripts"

local bookmarks = require "bookmarks"
local bookmarks_chrome = require "bookmarks_chrome"

local viewpdf = require "viewpdf"

local follow = require "follow"

local cmdhist = require "cmdhist"

local search = require "search"

local taborder = require "taborder"

local history = require "history"
local history_chrome = require "history_chrome"

local help_chrome = require "help_chrome"
local binds_chrome = require "binds_chrome"

local completion = require "completion"

local open_editor = require "open_editor"
local editor = require "editor"
editor.editor_cmd = "st -f 'ComicShannsMono Nerd Font Mono-14' -i -t nvim nvim"

-- local noscript = require "noscript"

local follow_selected = require "follow_selected"
local go_input = require "go_input"
local go_next_prev = require "go_next_prev"
local go_up = require "go_up"

require_web_module("referer_control_wm")

local styles = require "styles"
local image_css = require "image_css"
local newtab_chrome = require "newtab_chrome"
local error_page = require "error_page"
local view_source = require "view_source"

----------------------------------------------


-- Window

local window = require "window"
local webview = require "webview"
local log_chrome = require "log_chrome"

window.add_signal("build", function (w)
    w.sbar.l.layout:pack(lousy.widget.uri())
    w.sbar.l.layout:pack(lousy.widget.hist())
    w.sbar.l.layout:pack(lousy.widget.progress())

    w.sbar.r.layout:pack(lousy.widget.buf())
    w.sbar.r.layout:pack(log_chrome.widget())
    w.sbar.r.layout:pack(lousy.widget.ssl())
    w.sbar.r.layout:pack(lousy.widget.tabi())
    w.sbar.r.layout:pack(lousy.widget.scroll())
end)


window.new { }
