import Pango from "gi://Pango?version=1.0"

import { createState } from "ags"
import Hyprland from "gi://AstalHyprland"


export default function BarTitle(): JSX.Element {
  const hyprland = Hyprland.get_default()

  const [label, set_label] = createState("")
  hyprland.connect('event', (_source, event) => {
    switch (event) {
      case 'activewindowv2':
      case 'windowtitle':
      case 'windowtitlev2':
        if (hyprland.focused_client) {
          set_label(hyprland.focused_client.title)
        } else {
          set_label("")
        }
        break
    }
  })

  return (<label class="bar-title" ellipsize={Pango.EllipsizeMode.END} max-width-chars={50} label={label} />)
}
