import { Astal } from "astal/gtk3"
import { Variable, bind } from "astal"

import Backlight from "../../services/backlight"


export default function PopupBacklight(): JSX.Element {
  const backlight = Backlight.get_default()


  function onDragged(self: Astal.Slider) {
      backlight.screen = self.value
  }

  const label = (
    <label
      className="popups-backlight-label"
      label="backlight"
    />
  )

  const slider = (
    <slider
      className="popups-backlight-slider"
      hexpand
      onDragged={onDragged}
      value={bind(backlight, 'screen')}
    />
  )

  const status = (
    <label
      className="popups-backlight-status"
      label={bind(Variable.derive([
        bind(backlight, 'screen'),
      ], (value) => {
        return `${Math.round(value * 100)}%`
      }))}
    />
  )

  return (
    <box vertical name="backlight" className="popups-backlight">
      {label}
      {slider}
      {status}
    </box>
  )
}
