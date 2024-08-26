import Bar from "./bar/bar.js"

const MONITOR = 0

App.config({
  style: "./style.css",
  windows: [
    Bar(MONITOR)
  ]
})
