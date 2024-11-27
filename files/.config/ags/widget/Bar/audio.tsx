import { Variable, bind } from "astal"

import Wp from "gi://AstalWp"


export default function BarAudio(): JSX.Element {
  const wp = Wp.get_default()
  const audio = wp?.audio.default_speaker!
  const mic = wp?.audio.default_microphone!


  const audio_status = bind(Variable.derive([
    bind(audio, 'volume'),
    bind(audio, 'mute'),
  ], (volume, isMuted) => {
    if (isMuted) {
      return "󰝟"
    } else {
      if (volume >= 0.6) {
        return "󰕾"
      } else if (volume >= 0.2) {
        return "󰖀"
      } else {
        return "󰕿"
      }
    }
  }))

  const tooltip_text = bind(Variable.derive([
    bind(audio, 'volume'),
    bind(audio, 'mute'),
    bind(mic, 'volume'),
    bind(mic, 'mute'),
  ], (volume, isMuted, mic_volume, mic_isMuted) => {
    return `volume: ${Math.round(volume * 100)}%${isMuted ? " mute" : ""}\n`
         + `mic-volume: ${Math.round(mic_volume * 100)}%${mic_isMuted ? " mute" : ""}`
  }))

  return (
    <box className="bar-audio">
      <label tooltipText={tooltip_text} label={audio_status} />
    </box>
  )
}
