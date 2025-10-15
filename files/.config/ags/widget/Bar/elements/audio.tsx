import { createBinding, createComputed } from "ags"

import Wp from "gi://AstalWp"


export default function() {
  const wp = Wp.get_default()
  const audio = wp?.audio.default_speaker!
  const mic = wp?.audio.default_microphone!


  const audio_status = createComputed([
    createBinding(audio, 'volume'),
    createBinding(audio, 'mute'),
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
  })

  const tooltip_text = createComputed([
    createBinding(audio, 'volume'),
    createBinding(audio, 'mute'),
    createBinding(mic, 'volume'),
    createBinding(mic, 'mute'),
  ], (volume, isMuted, mic_volume, mic_isMuted) => {
    return `volume: ${Math.round(volume * 100)}%${isMuted ? " mute" : ""}\n`
         + `mic-volume: ${Math.round(mic_volume * 100)}%${mic_isMuted ? " mute" : ""}`
  })

  return (<label class="audio" tooltipText={tooltip_text} label={audio_status} />)
}
