import { execAsync } from "astal/process"
import { Variable, bind } from "astal"

import Network from "gi://AstalNetwork"


export default function BarNetwork(): JSX.Element {
  const network = Network.get_default()


  function BarNetWorkWifi(): JSX.Element {

    const wifi_status = bind(Variable.derive([
      bind(network.wifi, 'strength'),
      bind(network.wifi, 'internet'),
      bind(network.wifi, 'enabled'),
    ], (strength, internet, enabled) => {
      if (enabled) {
        switch (internet) {
          case Network.Internet.CONNECTED:
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
          case Network.Internet.CONNECTING:
            return "󰤫 "
          case Network.Internet.DISCONNECTED:
            return "󰤮 "
        }
      }
    }))

    const tooltip_text = bind(Variable.derive([
      bind(network.wifi, 'ssid'),
      bind(network.wifi, 'strength'),
    ], (ssid, strength) => {
      return `${ssid || "Unknown"} (${strength})`
    }))

    return (
      <box name="wifi" className="bar-network-wifi">
        <label tooltipText={tooltip_text} label={wifi_status} />
      </box>
    )
  }

  function BarNetWorkWired(): JSX.Element {

    const wired_status = bind(Variable.derive([
      bind(network.wifi, 'internet'),
    ], (internet) => {
      switch (internet) {
        case Network.Internet.CONNECTED:
          return " "
        default:
          return ""
      }
    }))

    return (
      <box name="wired" className="bar-network-wired">
        <label label={wired_status} />
      </box>
    )
  }

  function BarNetWorkUnknown(): JSX.Element {
    return (
      <box name="unknown" className="bar-network-unknown">
        <label label="?" />
      </box>
    )
  }

  function onClick() {
    execAsync(`
      st -f 'ComicShannsMono Nerd Font Mono-14' -i env NEWT_COLORS='
      root=white,black
      roottext=yellow,black

      border=gray,black
      window=gray,black
      shadow=,
      title=white,black

      button=black,green
      actbutton=white,green
      compactbutton=black,cyan

      checkbox=black,yellow
      actcheckbox=green,yellow

      entry=black,lightgray
      disentry=white,black

      label=lightgray,black

      listbox=white,gray
      actlistbox=lightgray,black
      sellistbox=white,gray
      actsellistbox=black,green

      textbox=black,gray
      acttextbox=black,cyan

      emptyscale=,gray
      fullscale=,cyan

      helpline=yellow,cyan
      ' nmtui
    `)
  }


  return (
    <eventbox onClick={onClick}>
      <box className="bar-network">
        <stack
          shown={bind(network, 'primary').as(
            (primary: Network.Primary): string => {
              switch (primary) {
                case Network.Primary.UNKNOWN:
                  return "unknown"
                case Network.Primary.WIFI:
                  return "wifi"
                case Network.Primary.WIRED:
                  return "wired"
              }
            }
          )}
          children={[
            <BarNetWorkUnknown />,
            <BarNetWorkWifi />,
            <BarNetWorkWired />,
          ]}
        />
      </box>
    </eventbox>
  )
}
