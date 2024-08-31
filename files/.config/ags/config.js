import Bar from "./bar/bar.js"
import NotificationPopups from "./notifications/notifications.js"


const MONITOR = 0

App.config({
  style: "./style.css",
  windows: [
    Bar(MONITOR),
    NotificationPopups(MONITOR),
  ]
})
