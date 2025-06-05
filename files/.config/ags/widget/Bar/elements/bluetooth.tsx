import { bind } from "astal"

import Bluetooth from "gi://AstalBluetooth"


export default function BarBluetooth(): JSX.Element {
  const bluetooth = Bluetooth.get_default()

  const bluetooth_status = bind(bluetooth, 'isConnected').as(connected => {
    if (connected) {
      return "󰂯"
    } else {
      return "󰂲"
    }
  })

  const icon = bind(bluetooth, 'isPowered').as(powered => {
    if (powered) {
      return <box className="bar-bluetooth">
        <label label={bluetooth_status} />
      </box>
    } else {
      return <box />
    }
  })

  return (
    <box>
      {icon}
    </box>
  )
}
