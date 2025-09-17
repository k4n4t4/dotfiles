import { Astal } from "ags/gtk4"
import { createBinding, createState } from "ags"

import Wp from "gi://AstalWp"


export default function PopupAudioSpeaker(): JSX.Element {
  const wp = Wp.get_default()
  const speaker = wp?.audio.default_speaker!


  function onDragged(self: Astal.Slider) {
      speaker.volume = self.value
  }

  const label = (
    <label
      class="popups-audio-speaker-label"
      label="speaker"
    />
  )

  const slider = (
    <slider
      class="popups-audio-speaker-slider"
      hexpand
      onDragged={onDragged}
      value={createBinding(speaker, 'volume')}
    />
  )

  const status = (
    <label
      class="popups-audio-speaker-status"
      label={createBinding(createState.derive([
        createBinding(speaker, 'volume'),
        createBinding(speaker, 'mute'),
      ], (volume, isMuted) => {
        return `${Math.round(volume * 100)}%${isMuted ? " mute" : ""}`
      }))}
    />
  )

  return (
    <box vertical name="speaker" class="popups-audio-speaker">
      {label}
      {slider}
      {status}
    </box>
  )
}
