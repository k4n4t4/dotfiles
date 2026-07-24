import { createBinding, createState, With } from "ags"

import Hyprland from "gi://AstalHyprland"


export default function() {
  const hyprland = Hyprland.get_default()

  const [current_submap, set_current_submap] = createState("");

  createBinding(hyprland, "connect")

  hyprland.connect("submap", (_, name) => {
    set_current_submap(name)
  })

  return (
    <box>
      <With value={current_submap}>
        {name => name === "" ? (<box />) : (<label class="submap" label={name} />)}
      </With>
    </box>
  )
}
