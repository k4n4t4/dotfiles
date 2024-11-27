import { Astal } from "astal/gtk3"
import { Variable, bind } from "astal"

import Wp from "gi://AstalWp"


export default function PopupAudioMicrophone(): JSX.Element {
  const wp = Wp.get_default()
  const mic = wp?.audio.default_microphone!

  function onDragged(self: Astal.Slider) {
      mic.volume = self.value
  }

  const label = (
    <label
      className="popups-audio-microphone-label"
      label="microphone"
    />
  )

  const slider = (
    <slider
      className="popups-audio-microphone-slider"
      hexpand
      onDragged={onDragged}
      value={bind(mic, 'volume')}
    />
  )

  const status = (
    <label
      className="popups-audio-microphone-status"
      label={bind(Variable.derive([
        bind(mic, 'volume'),
        bind(mic, 'mute'),
      ], (volume, isMuted) => {
        return `${Math.round(volume * 100)}%${isMuted ? " mute" : ""}`
      }))}
    />
  )

  return (
    <box vertical name="microphone" className="popups-audio-microphone">
      {label}
      {slider}
      {status}
    </box>
  )
}
