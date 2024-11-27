import { App } from "astal/gtk3"
import { bind, Variable } from "astal"

import Mpris from "gi://AstalMpris"


export default function BarMpris(): JSX.Element {
  const mpris = Mpris.get_default()

  const class_name = bind(Variable.derive([
    bind(mpris, 'players'),
  ], (players) => {
    const class_names = ["bar-mpris"]
    if (players.length > 0) {
      class_names.push("bar-mpris-exist-player")
    }
    return class_names.join(" ")
  }))

  const tooltip_text = bind(Variable.derive([
    bind(mpris, 'players'),
  ], (players) => {
      let str = ""
      for (let player of players) {
        str += player.title + "\n"
      }
      return str
  }))

  return (
    <eventbox onClick={() => {App.toggle_window("Media")}}>
      <box className={class_name} >
        <label tooltipText={tooltip_text} label="󰎆 " />
      </box>
    </eventbox>
  )
}
