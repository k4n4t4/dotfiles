import { Astal, Gtk } from "ags/gtk4"
import { createBinding, createComputed } from "ags"

import Backlight from "../../services/backlight"


export default function PopupBacklight(): JSX.Element {
  const backlight = Backlight.get_default()


  function onDragged(self: Astal.Slider) {
      backlight.screen = self.value
  }

  const label = (
    <label
      class="popups-backlight-label"
      label="backlight"
    />
  )

  const slider = (
    <slider
      class="popups-backlight-slider"
      hexpand
      onChangeValue={onDragged}
      value={createBinding(backlight, 'screen')}
    />
  )

  const status = (
    <label
      class="popups-backlight-status"
      label={createComputed([
        createBinding(backlight, 'screen'),
      ], (value) => {
        return `${Math.round(value * 100)}%`
      })}
    />
  )

  return (
    <box name="backlight" orientation={Gtk.Orientation.VERTICAL} class="popups-backlight">
      {label}
      {slider}
      {status}
    </box>
  )
}
