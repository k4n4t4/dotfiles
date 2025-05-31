import { Variable, bind } from "astal"

import Battery from "gi://AstalBattery"
import PowerProfiles from "gi://AstalPowerProfiles"


function batIcon(percent: number) {
  if (percent >= 100) return "󰁹"
  if (percent >= 90) return "󰂂"
  if (percent >= 80) return "󰂁"
  if (percent >= 70) return "󰂀"
  if (percent >= 60) return "󰁿"
  if (percent >= 50) return "󰁾"
  if (percent >= 40) return "󰁽"
  if (percent >= 30) return "󰁼"
  if (percent >= 20) return "󰁻"
  if (percent >= 10) return "󰁺"
  return "󰂎"
}


export default function BarBattery(): JSX.Element {
  const battery = Battery.get_default()
  const powerprofiles = PowerProfiles.get_default()

  if (battery.deviceType === 0) return (<box />)

  const bat_status = bind(Variable.derive([
    bind(battery, 'percentage'),
    bind(battery, 'charging'),
    bind(powerprofiles, 'active_profile'),
  ], (percentage, charging, profile) => {
    let label = ""
    const percent = Math.round(percentage * 100)

    label += profile === 'power-saver' ? "󰌪 " : ""
    label += batIcon(percent)
    label += charging ? "󱐋" : ""

    return label
  }))

  const class_name = bind(Variable.derive([
    bind(battery, 'percentage'),
    bind(battery, 'charging'),
    bind(powerprofiles, 'active_profile'),
  ], (percentage, charging, profile) => {

    const class_names = ["bar-battery"]
    const percent = Math.round(percentage * 100)

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

    return class_names.join(" ")
  }))

  const tooltip_text = bind(Variable.derive([
    bind(battery, 'percentage'),
    bind(battery, 'charging'),
    bind(powerprofiles, 'active_profile'),
  ], (percentage, charging, profile) => {
    const percent = percentage * 100
    return `${percent}% (${charging ? "charging": "not charging"})\n${profile}`
  }))


  function onClick() {
    switch (powerprofiles.active_profile) {
      case 'balanced':
        powerprofiles.active_profile = 'power-saver'
        break
      default:
        powerprofiles.active_profile = 'balanced'
        break
    }
  }

  return (
    <eventbox onClick={onClick}>
      <box className={class_name}>
        <label tooltipText={tooltip_text} label={bat_status} />
      </box>
    </eventbox>
  )
}
