import { createBinding, With } from "ags"

import Bluetooth from "gi://AstalBluetooth"


export default function() {
  const bluetooth = Bluetooth.get_default()

  const bluetooth_status = createBinding(bluetooth, 'isConnected').as(connected => {
    if (connected) {
      return "󰂯"
    } else {
      return "󰂲"
    }
  })

  const icon = createBinding(bluetooth, 'isPowered').as(powered => {
    if (powered) {
      return (<label label={bluetooth_status} />)
    } else {
      return (<box />)
    }
  })

  return (
    <box class="bluetooth">
      <With value={icon}>
        {icon => icon}
      </With>
    </box>
  )
}
