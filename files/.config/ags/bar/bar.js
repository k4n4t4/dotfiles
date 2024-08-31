const hyprland  = await Service.import('hyprland')
const audio     = await Service.import('audio')
const bluetooth = await Service.import('bluetooth')
const network   = await Service.import('network')
const battery   = await Service.import('battery')


function clock(interval) {
  return Variable(0, {
    poll: [interval, () => {
      const date = new Date()
      return {
        get date()    { return ("00"   + date.getDate()     ).slice(-2) },
        get month()   { return ("00"   + (date.getMonth()+1)).slice(-2) },
        get year()    { return ("0000" + date.getFullYear() ).slice(-4) },
        get hours()   { return ("00"   + date.getHours()    ).slice(-2) },
        get minutes() { return ("00"   + date.getMinutes()  ).slice(-2) },
        get seconds() { return ("00"   + date.getSeconds()  ).slice(-2) },
      }
    }]
  })
}

const BarClock = Widget.Box({
  class_name: "bar-clock",
  tooltipText: clock(1000).bind().as(({
    month: M,
    date: D,
    year: Y,
    hours: h,
    minutes: m,
    seconds: s,
  }) => {
    return `${M}-${D}-${Y} ${h}:${m}:${s}`
  }),
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
  tooltipText: Utils.merge([
    battery.bind('charging'),
    battery.bind('percent'),
  ], (charging, percent) => {
    return `${percent}% (${charging ? "charging": "not charging"})`
  }),
  children: [
    Widget.Label({
      label: Utils.merge([
        battery.bind('charging'),
        battery.bind('percent'),
      ], (charging, percent) => {
        let label = ""
        if (percent >= 100) {
          label += "󰁹"
        } else if (percent >= 90) {
          label += "󰂂"
        } else if (percent >= 80) {
          label += "󰂁"
        } else if (percent >= 70) {
          label += "󰂀"
        } else if (percent >= 60) {
          label += "󰁿"
        } else if (percent >= 50) {
          label += "󰁾"
        } else if (percent >= 40) {
          label += "󰁽"
        } else if (percent >= 30) {
          label += "󰁼"
        } else if (percent >= 20) {
          label += "󰁻"
        } else if (percent >= 10) {
          label += "󰁺"
        } else {
          label += "󰂎"
        }
        if (charging) {
          label += "󱐋"
        } else {
          label += ""
        }
        return label
      })
    }),
  ]
})


const BarNetworkWifi = Widget.Box({
  class_name: "bar-network-wifi",
  tooltipText: Utils.merge([
    network.wifi.bind('ssid'),
    network.wifi.bind('strength'),
  ], (ssid, strength) => {
    return `${ssid || "Unknown"} (${strength})`
  }),
  children: [
    Widget.Label({
      label: Utils.merge([
        network.wifi.bind('strength'),
        network.wifi.bind('internet'),
        network.wifi.bind('enabled'),
      ], (strength, internet, enabled) => {
        if (enabled) {
          if (internet === "connected") {
            if (strength >= 80) {
              return "󰤨"
            } else if (strength >= 60) {
              return "󰤥"
            } else if (strength >= 30) {
              return "󰤢"
            } else if (strength >= 10) {
              return "󰤟"
            } else {
              return "󰤯"
            }
          } else {
            return "󰤮"
          }
        } else {
          return "󰤫"
        }
      })
    })
  ]
})

const BarNetworkWired = Widget.Box({
  class_name: "bar-network-wired",
  children: [
    Widget.Label({
      label: Utils.merge([
        network.wifi.bind('internet'),
        network.wifi.bind('state'),
      ], (internet, state) => {
        if (internet === 'connected') {
          return ""
        } else {
          return ""
        }
      })
    })
  ]
})

const BarNetwork = Widget.Box({
  class_name: "bar-network",
  children: [
    Widget.Stack({
      children: {
        wifi: BarNetworkWifi,
        wired: BarNetworkWired,
      },
      shown: network.bind('primary').as(primary => primary || 'wifi')
    })
  ]
})


const BarBluetooth = Widget.Box({
  class_name: "bar-bluetooth",
  children: [
    Widget.Label({
      label: Utils.merge([
        bluetooth.bind('enabled'),
      ], (enabled) => {
        if (enabled) {
          return "󰂯"
        } else {
          return "󰂲"
        }
      })
    })
  ]
})


const BarAudio = Widget.Box({
  class_name: "bar-audio",
  tooltipText: Utils.merge([
    audio.speaker.bind('volume'),
    audio.speaker.bind('is-muted'),
    audio.microphone.bind('volume'),
    audio.microphone.bind('is-muted'),
  ], (volume, isMuted, mic_volume, mic_isMuted) => {
    return `volume: ${Math.round(volume * 100)}%${isMuted ? " mute" : ""}\n`
         + `mic-volume: ${Math.round(mic_volume * 100)}%${mic_isMuted ? " mute" : ""}`
  }),
  children: [
    Widget.Label({
      label: Utils.merge([
        audio.speaker.bind('volume'),
        audio.speaker.bind('is-muted'),
      ], (volume, isMuted) => {
        if (isMuted) {
          return "󰝟"
        } else {
          if (volume >= 0.6) {
            return "󰕾"
          } else if (volume >= 0.2) {
            return "󰖀"
          } else {
            return "󰕿"
          }
        }
      })
    })
  ]
})


const BarTitle = Widget.Box({
  class_name: "bar-title",
  children: [
    Widget.Label({
      label: Utils.merge([
        hyprland.bind('active')
      ], (active) => {
          return `${active.client.title}`
      })
    })
  ]
})


const BarWorkspaces = Widget.Box({
  class_name: "bar-workspaces",
  children: hyprland.bind('workspaces').as(workspaces => {
    const children = []
    for (let workspace of workspaces) {
      children.push(Widget.Button({
        class_name: hyprland.bind('active').as(active => {
          let class_name = "bar-workspace"
          if (active.workspace.id === workspace.id) {
            class_name += " bar-current-workspace"
          }
          return class_name
        }),
        onClicked: () => {
          hyprland.messageAsync(`dispatch workspace ${workspace.id}`)
        },
        child: Widget.Box({
          children: [
            Widget.Label(workspace.name)
          ]
        })
      }))
    }
    return children
  })
})


const Bar = monitor => Widget.Window({
  class_name: "bar",
  monitor,
  name: `bar-${monitor}`,
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  layer: 'bottom',
  margins: [5, 5, 5, 5],
  keymode: 'none',
  child: Widget.CenterBox({
    startWidget: BarStart,
    centerWidget: BarCenter,
    endWidget: BarEnd,
  })
})

const BarStart = Widget.Box({
  hpack: 'start',
  children: [
    BarWorkspaces,
  ]
})

const BarCenter = Widget.Box({
  hpack: 'center',
  children: [
    BarTitle,
  ]
})

const BarEnd = Widget.Box({
  hpack: 'end',
  children: [
    BarAudio,
    BarBluetooth,
    BarNetwork,
    BarBattery,
    BarClock,
  ]
})

export default Bar
