import { bind, Variable } from "astal"

import Hyprland from "gi://AstalHyprland"


export default function BarTitle(): JSX.Element {
  const hyprland = Hyprland.get_default()

  const label = Variable("")
  hyprland.connect('event', (_source, event) => {
    switch (event) {
      case 'activewindowv2':
      case 'windowtitle':
      case 'windowtitlev2':
        if (hyprland.focused_client) {
          label.set(hyprland.focused_client.title)
        } else {
          label.set("")
        }
        break
    }
  })

  return (
    <box className="bar-title" >
      <label truncate max-width-chars={50} label={bind(label)} />
    </box>
  )
}
