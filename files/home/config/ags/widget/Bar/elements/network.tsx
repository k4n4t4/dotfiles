import { createBinding, createComputed } from "ags"

import Network from "gi://AstalNetwork"
import { runNmtui } from "../../../utils"


export default function() {
  const network = Network.get_default()

  function BarNetWorkWifi() {
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

    return (<label $type="named" name="wifi" class="wifi" tooltipText={tooltip_text} label={wifi_status} />)
  }

  function BarNetWorkWired() {
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

    return (<label $type="named" name="wired" class="wired" label={wired_status} />)
  }

  function BarNetWorkUnknown() {
    return (<label $type="named" name="unknown" class="unknown" label="?" />)
  }

  return (
    <button onClicked={() => {runNmtui()}} class="network">
      <stack
        visibleChildName={createBinding(network, 'primary').as(
          (primary: Network.Primary): string => {
            switch (primary) {
              case Network.Primary.UNKNOWN: return "unknown"
              case Network.Primary.WIFI: return "wifi"
              case Network.Primary.WIRED: return "wired"
            }
          }
        )}
      >
        <BarNetWorkUnknown />
        <BarNetWorkWifi />
        <BarNetWorkWired />
      </stack>
    </button>
  )
}
