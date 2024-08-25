const audio = await Service.import('audio')
const battery = await Service.import('battery')

/*

  # get speaker volume
  audio[('speaker' | 'microphone')].volume

  # bind speaker volume
  audio[('speaker' | 'microphone')].bind('volume')

*/


function clock(interval) {
  return Variable(0, {
    poll: [interval, () => {
      const date = new Date()
      return {
        get date()    { return ("00"   + date.getDate()    ).slice(-2) },
        get month()   { return ("00"   + date.getMonth()   ).slice(-2) },
        get year()    { return ("0000" + date.getFullYear()).slice(-4) },
        get hours()   { return ("00"   + date.getHours()   ).slice(-2) },
        get minutes() { return ("00"   + date.getMinutes() ).slice(-2) },
        get seconds() { return ("00"   + date.getSeconds() ).slice(-2) },
      }
    }]
  })
}

const BarClock = Widget.Box({
  class_name: "bar-clock",
  children: [
    Widget.Label({
      label: clock(1000 * 30).bind().as(({
        hours: h,
        minutes: m,
      }) => {
        return `${h}:${m}`
      })
    })
  ]
})

const BarBattery = Widget.Box({
  class_name: Utils.merge([
    battery.bind('charging'),
    battery.bind('percent'),
  ], (charging, percent) => {
    let class_name = "bar-battery"
    if (charging) {
      class_name += " bar-battery-charging"
    } else {
      class_name += " bar-battery-not-charging"
    }
    if (percent < 10) {
      class_name += " bar-battery-critical"
    } else if (percent < 30) {
      class_name += " bar-battery-low"
    } else if (percent < 60) {
      class_name += " bar-battery-middle"
    } else {
      class_name += " bar-battery-high"
    }
    return class_name
  }),
  children: [
    Widget.Label({
      label: battery.bind("percent").as(percent => {
        if (percent >= 100) {
          return "󰁹"
        } else if (percent >= 90) {
          return "󰂂"
        } else if (percent >= 80) {
          return "󰂁"
        } else if (percent >= 70) {
          return "󰂀"
        } else if (percent >= 60) {
          return "󰁿"
        } else if (percent >= 50) {
          return "󰁾"
        } else if (percent >= 40) {
          return "󰁽"
        } else if (percent >= 30) {
          return "󰁼"
        } else if (percent >= 20) {
          return "󰁻"
        } else if (percent >= 10) {
          return "󰁺"
        } else {
          return "󰂎"
        }
      })
    }),
    Widget.Label({
      label: battery.bind("charging").as(charging => {
        if (charging) {
          return "󱐋"
        } else {
          return ""
        }
      })
    })
  ]
})


const Bar = monitor => Widget.Window({
  class_name: "bar",
  monitor,
  name: `bar-${monitor}`,
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  layer: "bottom",
  margins: [5, 5, 5, 5],
  keymode: "none",
  child: Widget.Box({
    children: [
      BarStart,
      BarCenter,
      BarEnd,
    ]
  })
})

const BarStart = Widget.Box({
  hpack: "start",
  children: [
    Widget.Label({ label: "Hello AGS! <start>" })
  ]
})

const BarCenter = Widget.Box({
  hpack: "center",
  hexpand: true,
  children: [
    Widget.Label({ label: "Hello AGS! <center>" })
  ]
})

const BarEnd = Widget.Box({
  hpack: "end",
  children: [
    BarBattery,
    BarClock,
  ]
})

App.config({
  style: "./style.css",
  windows: [
    Bar(0)
  ]
})
