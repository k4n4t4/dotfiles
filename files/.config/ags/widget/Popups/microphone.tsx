import { Astal } from "ags/gtk4"
import { createBinding, createState } from "ags"

import Wp from "gi://AstalWp"


export default function PopupAudioMicrophone(): JSX.Element {
  const wp = Wp.get_default()
  const mic = wp?.audio.default_microphone!

  function onDragged(self: Astal.Slider) {
      mic.volume = self.value
  }

  const label = (
    <label
      class="popups-audio-microphone-label"
      label="microphone"
    />
  )

  const slider = (
    <slider
      class="popups-audio-microphone-slider"
      hexpand
      onDragged={onDragged}
      value={createBinding(mic, 'volume')}
    />
  )

  const status = (
    <label
      class="popups-audio-microphone-status"
      label={createBinding(createState.derive([
        createBinding(mic, 'volume'),
        createBinding(mic, 'mute'),
      ], (volume, isMuted) => {
        return `${Math.round(volume * 100)}%${isMuted ? " mute" : ""}`
      }))}
    />
  )

  return (
    <box vertical name="microphone" class="popups-audio-microphone">
      {label}
      {slider}
      {status}
    </box>
  )
}
