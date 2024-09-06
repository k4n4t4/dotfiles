msg.info [[Loaded "rc.lua"]]
require "unique_instance"


-- Lousy

local lousy = require "lousy"

lousy.theme.init(lousy.util.find_config("theme.lua"))


require "adblock"
require "adblock_chrome"
require "adblock_wm"
require "binds"
require "binds_chrome"
require "bookmarks"
require "bookmarks_chrome"
require "chrome"
require "chrome_wm"
require "clear_data"
require "cmdhist"
require "completion"
require "domain_props"
require "editor"
require "error_page"
require "error_page_wm"
require "follow"
require "follow_selected"
require "follow_selected_wm"
require "follow_wm"
require "formfiller"
require "formfiller_wm"
require "go_input"
require "go_next_prev"
require "go_up"
require "gopher"
require "help_chrome"
require "hide_scrollbars"
require "history"
require "history_chrome"
require "image_css"
require "image_css_wm"
require "introspector_chrome"
require "keysym"
require "markdown"
require "modes"
require "newtab_chrome"
require "noscript"
require "open_editor"
require "proxy"
require "quickmarks"
require "readline"
require "referer_control_wm"
require "search"
require "select"
require "select_wm"
require "session"
require "settings"
require "settings_chrome"
require "styles"
require "tab_favicons"
require "tabgroups"
require "tabhistory"
require "tabmenu"
require "taborder"
require "undoclose"
require "userscripts"
require "vertical_tabs"
require "view_source"
require "viewpdf"
require "webinspector"
require "webview"
require "webview_wm"




-- Downloads

local downloads = require "downloads"
require "downloads_chrome"

downloads.default_dir = os.getenv("HOME") .. "/tmp"
downloads.add_signal("download-location", function (uri, file)
  if not file or file == "" then
    file = ( string.match(uri, "/([^/]+)$") or
      string.match(uri, "^%w+://(.+)") or
      string.gsub(uri, "/", "_") or "untitled")
  end
  return downloads.default_dir .. "/" .. file
end)


require "modes"
require "binds"

local window = require "window"
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


window.new {
  "about:blank"
}
