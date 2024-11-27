import { bind } from "astal"

import Bluetooth from "gi://AstalBluetooth"


export default function BarBluetooth(): JSX.Element {
  const bluetooth = Bluetooth.get_default()

  const bluetooth_status = bind(bluetooth, 'is_connected').as(connected => {
    if (connected) {
      return "󰂯"
    } else {
      return "󰂲"
    }
  })

  return (
    <box className="bar-bluetooth">
      <label label={bluetooth_status} />
    </box>
  )
}
