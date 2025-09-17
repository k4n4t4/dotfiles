import { createBinding, createState } from "ags"

import Hyprland from "gi://AstalHyprland"


export default function BarSubmap(): JSX.Element {
  const hyprland = Hyprland.get_default()

  const current_submap = createState("");

  createBinding(hyprland, "connect")

  hyprland.connect("submap", (_, name) => {
    current_submap.set(name)
  })

  const submap = createBinding(current_submap).as(name => {
    if (name === "") {
      return (
        <box />
      )
    } else {
      return (
        <box class="bar-submap">
          <label label={name} />
        </box>
      )
    }
  })

  return (
    <box>
      {submap}
    </box>
  )
}
