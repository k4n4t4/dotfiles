import Bar from "./bar/bar.js"
import Popups from "./popups/popups.js"
import Notification from "./notifications/notifications.js"
import Media from "./media/media.js"


const MONITOR = 0

App.config({
  style: "./style.css",
  windows: [
    Notification.NotificationPopups(MONITOR),
    Notification.NotificationNotifications(MONITOR),
    Media(MONITOR),
    Bar(MONITOR),
    Popups(MONITOR),
  ]
})
