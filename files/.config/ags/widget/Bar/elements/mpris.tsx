import app from "ags/gtk4/app"
import { createBinding, createComputed, With } from "ags"

import Mpris from "gi://AstalMpris"


export default function BarMpris(): JSX.Element {
  const mpris = Mpris.get_default()

  const class_name = createComputed([
    createBinding(mpris, 'players'),
  ], (players) => {
    const class_names = ["bar-mpris"]
    if (players.length > 0) {
      class_names.push("bar-mpris-exist-player")
    }
    return class_names.join(" ")
  })

  const tooltip_text = createComputed([
    createBinding(mpris, 'players'),
  ], (players) => {
      let str = ""
      for (let player of players) {
        str += player.title + "\n"
      }
      return str
  })

  const icon = createBinding(mpris, 'players').as(players => {
    if (players.length > 0) {
      return (
        <button onClicked={() => {app.toggle_window("Media")}}>
          <box class={class_name}>
            <label tooltipText={tooltip_text} label="󰎆 " />
          </box>
        </button>
      )
    } else {
      return <box />
    }
  })

  return (
    <box>
      <With value={icon}>
        {icon => icon}
      </With>
    </box>
  )
}
