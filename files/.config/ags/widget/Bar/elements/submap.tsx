import { createBinding, createState, With } from "ags"

import Hyprland from "gi://AstalHyprland"


export default function BarSubmap(): JSX.Element {
  const hyprland = Hyprland.get_default()

  const [current_submap, set_current_submap] = createState("");

  createBinding(hyprland, "connect")

  hyprland.connect("submap", (_, name) => {
    set_current_submap(name)
  })

  const submap = current_submap.as(name => {
    if (name === "") {
      return (<box />)
    } else {
      return (<label class="bar-submap" label={name} />)
    }
  })

  return (
    <box>
      <With value={submap}>
        {submap => submap}
      </With>
    </box>
  )
}
