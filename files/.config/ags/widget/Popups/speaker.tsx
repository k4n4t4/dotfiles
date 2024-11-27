import { Astal } from "astal/gtk3"
import { Variable, bind } from "astal"

import Wp from "gi://AstalWp"


export default function PopupAudioSpeaker(): JSX.Element {
  const wp = Wp.get_default()
  const speaker = wp?.audio.default_speaker!


  function onDragged(self: Astal.Slider) {
      speaker.volume = self.value
  }

  const label = (
    <label
      className="popups-audio-speaker-label"
      label="speaker"
    />
  )

  const slider = (
    <slider
      className="popups-audio-speaker-slider"
      hexpand
      onDragged={onDragged}
      value={bind(speaker, 'volume')}
    />
  )

  const status = (
    <label
      className="popups-audio-speaker-status"
      label={bind(Variable.derive([
        bind(speaker, 'volume'),
        bind(speaker, 'mute'),
      ], (volume, isMuted) => {
        return `${Math.round(volume * 100)}%${isMuted ? " mute" : ""}`
      }))}
    />
  )

  return (
    <box vertical name="speaker" className="popups-audio-speaker">
      {label}
      {slider}
      {status}
    </box>
  )
}
