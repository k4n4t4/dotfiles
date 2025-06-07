import { App, Astal, Gdk } from "astal/gtk3"
import { Variable, bind } from "astal"

import Backlight from "../../services/backlight"
import Wp from "gi://AstalWp"

import PopupAudioSpeaker from "./speaker"
import PopupAudioMicrophone from "./microphone"
import PopupBacklight from "./backlight"


export default function Popups(gdkmonitor: Gdk.Monitor) {
  const wp = Wp.get_default()
  const speaker = wp?.audio.default_speaker!
  const mic = wp?.audio.default_microphone!
  const backlight = Backlight.get_default()

  const shown = Variable("speaker")

  const stack = (
    <stack
      shown={bind(shown)}
      children={[
        <PopupAudioSpeaker />,
        <PopupAudioMicrophone />,
        <PopupBacklight />,
      ]}
    />
  )

  return (
    <window
      name="Popups"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.IGNORE}
      anchor={0}
      layer={Astal.Layer.OVERLAY}
      application={App}
      setup={self => {
        let timer: any = undefined
        let prevent = true
        setTimeout(() => {prevent = false}, 1000)
        function show(name: string) {
          if (prevent) return
            if (!self.visible) {
              self.visible = true
            }
            shown.set(name)
            if (timer !== undefined) {
              clearTimeout(timer)
            }
            timer = setTimeout(() => {
              self.visible = false
              timer = undefined
            }, 1500)
        }
        let speaker_tmp_volume = 0
        let speaker_tmp_mute = false
        speaker.connect('notify', speaker => {
          if (speaker_tmp_volume !== speaker.volume || speaker_tmp_mute !== speaker.mute) {
            speaker_tmp_volume = speaker.volume
            speaker_tmp_mute = speaker.mute
            show('speaker')
          }
        })
        let mic_tmp_volume = 0
        let mic_tmp_mute = false
        mic.connect('notify', mic => {
          if (mic_tmp_volume !== mic.volume || mic_tmp_mute !== mic.mute) {
            mic_tmp_volume = mic.volume
            mic_tmp_mute = mic.mute
            show('microphone')
          }
        })
        backlight.connect('notify', _backlight => {
          show('backlight')
        })
      }}
      visible={false}
    >
      <box className="popups">
        {stack}
      </box>
    </window>
  )
}
