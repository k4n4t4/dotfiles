import app from "ags/gtk4/app"
import { createBinding, createState } from "ags"

import Mpris from "gi://AstalMpris"


export default function BarMpris(): JSX.Element {
  const mpris = Mpris.get_default()

  const class_name = createBinding(createState.derive([
    createBinding(mpris, 'players'),
  ], (players) => {
    const class_names = ["bar-mpris"]
    if (players.length > 0) {
      class_names.push("bar-mpris-exist-player")
    }
    return class_names.join(" ")
  }))

  const tooltip_text = createBinding(createState.derive([
    createBinding(mpris, 'players'),
  ], (players) => {
      let str = ""
      for (let player of players) {
        str += player.title + "\n"
      }
      return str
  }))

  const icon = createBinding(mpris, 'players').as(players => {
    if (players.length > 0) {
      return (
        <eventbox onClick={() => {app.toggle_window("Media")}}>
          <box class={class_name}>
            <label label="󰎆 " />
          </box>
        </eventbox>
      )
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
