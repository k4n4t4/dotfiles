import app from "ags/gtk4/app"
import { createBinding, createComputed, With } from "ags"

import Mpris from "gi://AstalMpris"


export default function() {
  const mpris = Mpris.get_default()

  const class_names = createComputed([
    createBinding(mpris, 'players'),
  ], (players) => {
    const class_names = []
    if (players.length > 0) {
      class_names.push("exist-player")
    } else {
      class_names.push("not-exist-player")
    }
    return class_names
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
        <button cssClasses={class_names} onClicked={() => {app.toggle_window("Media")}}>
          <label tooltipText={tooltip_text} label="󰎆 " />
        </button>
      )
    } else {
      return <box />
    }
  })

  return (
    <box class="mpris">
      <With value={icon}>
        {icon => icon}
      </With>
    </box>
  )
}
