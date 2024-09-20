import Bar from "./bar/bar.js"
import Popups from "./popups/popups.js"
import NotificationPopups from "./notifications/notifications.js"
import Media from "./media/media.js"


const MONITOR = 0

App.config({
  style: "./style.css",
  windows: [
    Bar(MONITOR),
    Popups(MONITOR),
    NotificationPopups(MONITOR),
    Media(MONITOR),
  ]
})
