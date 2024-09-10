const audio = await Service.import('audio')


const PopupsAudioSpeaker = Widget.Box({
  class_name: "popups-audio-speaker",
  vertical: true,
  children: [
    Widget.Label({
      class_name: "popups-audio-speaker-label",
      label: "Speaker"
    }),
    Widget.Slider({
      class_name: "popups-audio-speaker-slider",
      hexpand: true,
      drawValue: false,
      onChange: ({value}) => {
        audio.speaker.volume = value
      },
      value: audio.speaker.bind('volume'),
    }),
    Widget.Label({
      class_name: "popups-audio-speaker-label",
      label: Utils.merge([
        audio.speaker.bind('volume'),
        audio.speaker.bind('is-muted'),
      ], (volume, isMuted) => {
          return `${Math.round(volume * 100)}%${isMuted ? " mute" : ""}`
      })
    })
  ]
})

const PopupsAudioMic = Widget.Box({
  class_name: "popups-audio-mic",
  vertical: true,
  children: [
    Widget.Label({
      class_name: "popups-audio-mic-label",
      label: "Microphone"
    }),
    Widget.Slider({
      class_name: "popups-audio-mic-slider",
      hexpand: true,
      drawValue: false,
      onChange: ({value}) => {
        audio.microphone.volume = value
      },
      value: audio.microphone.bind('volume'),
    }),
    Widget.Label({
      class_name: "popups-audio-mic-label",
      label: Utils.merge([
        audio.microphone.bind('volume'),
        audio.microphone.bind('is-muted'),
      ], (volume, isMuted) => {
          return `${Math.round(volume * 100)}%${isMuted ? " mute" : ""}`
      })
    })
  ]
})

const PopupsBacklight = Widget.Box({
  class_name: "popups-backlight",
  vertical: true,
  children: [
    Widget.Label({
      class_name: "popups-backlight-label",
      label: "Microphone"
    }),
    Widget.Slider({
      class_name: "popups-backlight-slider",
      hexpand: true,
      drawValue: false,
      onChange: ({value}) => {
        audio.microphone.volume = value
      },
      value: audio.microphone.bind('volume'),
    }),
    Widget.Label({
      class_name: "popups-backlight-label",
      label: Utils.merge([
        audio.microphone.bind('volume'),
        audio.microphone.bind('is-muted'),
      ], (volume, isMuted) => {
          return `${Math.round(volume * 100)}%${isMuted ? " mute" : ""}`
      })
    })
  ]
})


const Popups = monitor => Widget.Window({
  class_name: "popups-window",
  monitor,
  visible: false,
  name: `popups-${monitor}`,
  anchor: [],
  exclusivity: 'exclusive',
  layer: 'top',
  margins: [0, 0, 0, 0],
  keymode: 'none',
  setup: self => {

    let timer = undefined
    let prevent = true
    setTimeout(() => {prevent = false}, 100)
    function show(name) {
      if (prevent) return

      if (!self.visible) {
        self.visible = true
      }

      self.child.child.shown = name

      if (timer !== undefined) {
        clearTimeout(timer)
      }
      timer = setTimeout(() => {
        self.visible = false
        timer = undefined
      }, 1500)
    }

    audio.connect('speaker-changed', audio => {
      show('audio_speaker')
    })
    audio.connect('microphone-changed', audio => {
      show('audio_mic')
    })

  },
  child: Widget.Box({
    class_name: "popups",
    child: Widget.Stack({
      transitionType: "slide_up",
      children: {
        audio_speaker: PopupsAudioSpeaker,
        audio_mic: PopupsAudioMic
      }
    })
  })
})

export default Popups
