import { execAsync } from "ags/process"
import { createBinding, createComputed } from "ags"

import Network from "gi://AstalNetwork"


export default function BarNetwork(): JSX.Element {
  const network = Network.get_default()


  function BarNetWorkWifi(): JSX.Element {

    const wifi_status = createComputed([
      createBinding(network.wifi, 'strength'),
      createBinding(network.wifi, 'internet'),
      createBinding(network.wifi, 'enabled'),
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
      } else {
        return ""
      }
    })

    const tooltip_text = createComputed([
      createBinding(network.wifi, 'ssid'),
      createBinding(network.wifi, 'strength'),
    ], (ssid, strength) => {
      return `${ssid || "Unknown"} (${strength})`
    })

    return (<label $type="named" name="wifi" class="bar-network-wifi" tooltipText={tooltip_text} label={wifi_status} />)
  }

  function BarNetWorkWired(): JSX.Element {

    const wired_status = createComputed([
      createBinding(network.wifi, 'internet'),
    ], (internet) => {
      switch (internet) {
        case Network.Internet.CONNECTED:
          return " "
        default:
          return ""
      }
    })

    return (<label $type="named" name="wired" class="bar-network-wired" label={wired_status} />)
  }

  function BarNetWorkUnknown(): JSX.Element {
    return (<label $type="named" name="unknown" class="bar-network-unknown" label="?" />)
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
    <button onClicked={onClick} class="bar-network">
      <stack
        visibleChildName={createBinding(network, 'primary').as(
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
    </button>
  )
}
