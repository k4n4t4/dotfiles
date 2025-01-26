import { bind, Variable } from "astal"

import Hyprland from "gi://AstalHyprland"


export default function BarSubmap(): JSX.Element {
  const hyprland = Hyprland.get_default()

  const current_submap = Variable("");

  bind(hyprland, "connect")

  hyprland.connect("submap", (_, name) => {
    current_submap.set(name)
  })

  const submap = bind(current_submap).as(name => {
    if (name === "") {
      return (
        <box />
      )
    } else {
      return (
        <box className="bar-submap">
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
