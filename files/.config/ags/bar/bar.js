const hyprland       = await Service.import('hyprland')
const audio          = await Service.import('audio')
const bluetooth      = await Service.import('bluetooth')
const network        = await Service.import('network')
const battery        = await Service.import('battery')
const powerProfiles  = await Service.import('powerprofiles')
const mpris          = await Service.import('mpris')
const systemtray     = await Service.import('systemtray')
const notifications  = await Service.import('notifications')


function clock(interval) {
  return Variable({}, {
    poll: [interval, () => {
      const date = new Date()
      return {
        get month()   { return ("00"   + (date.getMonth()+1)).slice(-2) },
        get date()    { return ("00"   + date.getDate()     ).slice(-2) },
        get year()    { return ("0000" + date.getFullYear() ).slice(-4) },
        get hours()   { return ("00"   + date.getHours()    ).slice(-2) },
        get minutes() { return ("00"   + date.getMinutes()  ).slice(-2) },
        get seconds() { return ("00"   + date.getSeconds()  ).slice(-2) },
      }
    }]
  })
}

function barClock(show_date=false, show_second=false) {

  const CLOCK = clock(1000)

  const left_revealer = Widget.Revealer(
    {
      revealChild: show_date,
      transitionDuration: 500,
      transition: 'slide_left',
    },
    Widget.Label({
      label: CLOCK.bind().as(({
        month: M,
        date: D,
        year: Y,
      }) => {
        return `${M}-${D}-${Y} `
      })
    })
  )

  const right_revealer = Widget.Revealer(
    {
      revealChild: show_second,
      transitionDuration: 500,
      transition: 'slide_right',
    },
    Widget.Label({
      label: CLOCK.bind().as(({
        seconds: s,
      }) => {
        return `:${s}`
      })
    })
  )

  const label = Widget.Label({
    label: CLOCK.bind().as(({
      hours: h,
      minutes: m,
    }) => {
        return `${h}:${m}`
      })
  })

  const BarClock = Widget.Box({
    class_name: "bar-clock",
    child: Widget.EventBox(
      {
        onPrimaryClick: self => {
          left_revealer.reveal_child = !left_revealer.reveal_child
        },
        onSecondaryClick: self => {
          right_revealer.reveal_child = !right_revealer.reveal_child
        },
      },
      Widget.Box({
        children: [
          left_revealer,
          label,
          right_revealer,
        ]
      })
    )
  })

  return BarClock
}


function barBattery() {

  const BarBattery = Widget.Button({
    onClicked: () => {
      switch (powerProfiles.active_profile) {
          case 'balanced':
              powerProfiles.active_profile = 'power-saver';
              break;
          default:
              powerProfiles.active_profile = 'balanced';
              break;
      };
    },
    child: Widget.Box({
      class_names: Utils.merge([
        battery.bind('charging'),
        battery.bind('percent'),
        powerProfiles.bind('active_profile'),
      ], (charging, percent, profile) => {
        const class_names = ["bar-battery"]
        if (charging) {
          class_names.push("bar-battery-charging")
        } else {
          class_names.push("bar-battery-not-charging")
        }
        if (percent < 10) {
          class_names.push("bar-battery-critical")
        } else if (percent < 30) {
          class_names.push("bar-battery-low")
        } else if (percent < 60) {
          class_names.push("bar-battery-middle")
        } else {
          class_names.push("bar-battery-high")
        }
        class_names.push(`bar-battery-profile-${profile}`)
        return class_names
      }),
      tooltipText: Utils.merge([
        battery.bind('charging'),
        battery.bind('percent'),
        powerProfiles.bind('active_profile'),
      ], (charging, percent, profile) => {
        return `${percent}% (${charging ? "charging": "not charging"})\n${profile}`
      }),
      children: [
        Widget.Label({
          label: Utils.merge([
            battery.bind('charging'),
            battery.bind('percent'),
            powerProfiles.bind('active_profile'),
          ], (charging, percent, profile) => {
            let label = ""
            if (profile === 'power-saver') {
              label += "󰌪 "
            }
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
  })

  return BarBattery
}


function barNetworkWifi() {

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
                return "󰤨 "
              } else if (strength >= 60) {
                return "󰤥 "
              } else if (strength >= 30) {
                return "󰤢 "
              } else if (strength >= 10) {
                return "󰤟 "
              } else {
                return "󰤯 "
              }
            } else {
              return "󰤮 "
            }
          } else {
            return "󰤫 "
          }
        })
      })
    ]
  })

  return BarNetworkWifi
}

function barNetworkWired() {

  const BarNetworkWired = Widget.Box({
    class_name: "bar-network-wired",
    children: [
      Widget.Label({
        label: Utils.merge([
          network.wifi.bind('internet'),
          network.wifi.bind('state'),
        ], (internet, state) => {
          if (internet === 'connected') {
            return " "
          } else {
            return ""
          }
        })
      })
    ]
  })

  return BarNetworkWired
}

function barNetwork() {

  const BarNetwork = Widget.Box({
    class_name: "bar-network",
    children: [
      Widget.Stack({
        children: {
          wifi: barNetworkWifi(),
          wired: barNetworkWired(),
        },
        shown: network.bind('primary').as(primary => primary || 'wifi')
      })
    ]
  })

  return BarNetwork
}


function barBluetooth() {

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

  return BarBluetooth
}


function barAudio() {

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

  return BarAudio
}


function barTitle() {

  const BarTitle = Widget.Box({
    class_name: "bar-title",
    children: [
      Widget.Label({
        truncate: "end",
        maxWidthChars: 50,
        label: Utils.merge([
          hyprland.bind('active')
        ], (active) => {
            return `${active.client.title}`
        })
      })
    ]
  })

  return BarTitle
}


function barWorkspaces() {

  const BarWorkspaces = Widget.Box({
    class_name: "bar-workspaces",
    children: hyprland.bind('workspaces').as(workspaces => {
      const children = []
      for (let workspace of workspaces) {
        children.push(Widget.Button({
          onClicked: () => {
            hyprland.messageAsync(`dispatch workspace ${workspace.name}`)
          },
          child: Widget.Box({
            class_names: hyprland.bind('active').as(active => {
              let class_names = ["bar-workspace"]
              if (active.workspace.id === workspace.id) {
                class_names.push("bar-current-workspace")
              }
              return class_names
            }),
            children: [
              Widget.Label(workspace.name)
            ]
          })
        }))
      }
      return children
    })
  })

  return BarWorkspaces
}


function barMpris() {

  const BarMpris = Widget.Box({
    class_names: mpris.bind("players").as(players => {
      const class_names = ["bar-mpris"]
      if (players.length > 0) {
        class_names.push("bar-mpris-exist-player")
      }
      return class_names
    }),
    tooltipText: mpris.bind("players").as(players => {
      let str = ""
      for (let player of players) {
        str += player['track-title'] + "\n"
      }
      return str
    }),
    children: [
      Widget.Button({
        onClicked: () => {
          App.toggleWindow("media")
        },
        child: Widget.Label({
          label: "󰎆 "
        })
      })
    ]
  })

  return BarMpris
}


function barSystemTray() {

  const systemTrayItem = item => Widget.Box({
    class_name: "bar-systemtray-item",
    child: Widget.Button({
      tooltipMarkup: item.bind('tooltip_markup'),
      onPrimaryClick: (_, event) => item?.activate(event),
      onSecondaryClick: (_, event) => item?.openMenu(event),
      child: Widget.Icon().bind('icon', item, 'icon'),
    })
  })

  const BarSystemTray = Widget.Box({
    class_names: systemtray.bind('items').as(items => {
      let class_names = ["bar-systemtray"]
      if (items.length === 0) {
        class_names.push("bar-systemtray-empty")
      } else {
        class_names.push("bar-systemtray-exist")
      }
      return class_names
    }),
    children: systemtray.bind('items').as(items => {
      let itemsWidgets = []
      for (let item of items) {
        itemsWidgets.push(systemTrayItem(item))
      }
      return itemsWidgets
    })
  })

  return BarSystemTray
}


function barNotifications() {

  const BarNotifications = Widget.Box({
    class_names: notifications.bind("notifications").as(notifications => {
      const class_names = ["bar-notifications"]
      if (notifications.length > 0) {
        class_names.push("bar-notifications-exist")
      }
      return class_names
    }),
    tooltipText: notifications.bind("notifications").as(notifications => {
      return `${notifications.length}`
    }),
    children: [
      Widget.Button({
        onClicked: () => {
          App.toggleWindow("notifications-notifications")
        },
        onSecondaryClick: () => {
          notifications.clear()
        },
        child: Widget.Label({
          label: " "
        })
      })
    ]
  })

  return BarNotifications
}


const Bar = monitor => Widget.Window({
  class_name: "bar-window",
  monitor,
  name: `bar-${monitor}`,
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  layer: 'top',
  keymode: 'none',
  child: Widget.CenterBox({
    class_name: "bar",
    startWidget: BarStart,
    centerWidget: BarCenter,
    endWidget: BarEnd,
  })
})

const BarStart = Widget.Box({
  class_name: "bar-left",
  hpack: 'start',
  children: [
    barWorkspaces(),
  ]
})

const BarCenter = Widget.Box({
  class_name: "bar-center",
  hpack: 'center',
  children: [
    barTitle(),
  ]
})

const BarEnd = Widget.Box({
  class_name: "bar-right",
  hpack: 'end',
  children: [
    barSystemTray(),
    barMpris(),
    barAudio(),
    barBluetooth(),
    barNetwork(),
    barBattery(),
    barClock(false, true),
    barNotifications(),
  ]
})

export default Bar
