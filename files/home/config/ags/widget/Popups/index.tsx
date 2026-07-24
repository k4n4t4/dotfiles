import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"

import Backlight from "../../services/backlight"
import Wp from "gi://AstalWp"

import PopupAudioSpeaker from "./speaker"
import PopupAudioMicrophone from "./microphone"
import PopupBacklight from "./backlight"


export default function Popups(gdkmonitor: Gdk.Monitor) {
  const wp = Wp.get_default()
  const speaker = wp?.audio.default_speaker!
  const mic = wp?.audio.default_microphone
  const backlight = Backlight.get_default()

  let stackRef: Gtk.Stack | null = null

  return (
    <window
      name="Popups"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.IGNORE}
      anchor={0}
      layer={Astal.Layer.OVERLAY}
      application={app}
      $={self => {
        let timer: any = undefined
        let prevent = true
        setTimeout(() => { prevent = false }, 1000)
        function show(name: string) {
          if (prevent) return
          if (!self.visible) {
            self.visible = true
          }
          stackRef?.set_visible_child_name(name)
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
        if (mic) {
          let mic_tmp_volume = 0
          let mic_tmp_mute = false
          mic.connect('notify', mic => {
            if (mic_tmp_volume !== mic.volume || mic_tmp_mute !== mic.mute) {
              mic_tmp_volume = mic.volume
              mic_tmp_mute = mic.mute
              show('microphone')
            }
          })
        }
        backlight.watchScreen(() => show('backlight'))
      }}
      visible={false}
    >
      <box class="popups">
        <stack $={s => { stackRef = s }}>
          <PopupAudioSpeaker $type="named" />
          <PopupAudioMicrophone $type="named" />
          <PopupBacklight $type="named" />
        </stack>
      </box>
    </window>
  )
}
