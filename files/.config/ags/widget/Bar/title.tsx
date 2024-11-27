import { bind, Variable } from "astal"

import Hyprland from "gi://AstalHyprland"


export default function BarTitle(): JSX.Element {
  const hyprland = Hyprland.get_default()

  let tmp_label = ""
  const label = bind(Variable.derive([
    bind(hyprland, 'focused_client'),
    bind(hyprland, 'clients'),
  ], (active, clients) => {
    if (clients.length === 0) {
      tmp_label = ""
    }
    if (active?.title) {
      tmp_label = active.title
      return active.title
    } else {
      return tmp_label
    }
  }))

  return (
    <box className="bar-title" >
      <label truncate max-width-chars={50} label={label} />
    </box>
  )
}
