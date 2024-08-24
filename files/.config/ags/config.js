const audio = await Service.import('audio')

const volumeSlider = (type = 'speaker') => Widget.Slider({
  hexpand: true,
  drawValue: false,
  onChange: ({value}) => {
    return audio[type].volume = value
  },
  value: audio[type].bind('volume')
})

const speakerSlider = volumeSlider('speaker')
const micSlider = volumeSlider('microphone')


const Bar = (monitor) => Widget.Window({
  class_name: "bar",
  monitor,
  name: `bar-${monitor}`,
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  layer: "bottom",
  margins: [0, 5, 0, 5],
  keymode: "none",
  child: Widget.Box({
    children: [
      BarStart,
      BarCenter,
      BarEnd,
    ]
  })
})

const BarStart = Widget.Box({
  hpack: "start",
  hexpand: true,
  children: [
    Widget.Label({
      class_name: "label",
      label: "Hello AGS! <start>",
    })
  ]
})

const BarCenter = Widget.Box({
  hpack: "center",
  hexpand: true,
  children: [
    Widget.Label({
      class_name: "label",
      label: "Hello AGS! <center>",
    })
  ]
})

const BarEnd = Widget.Box({
  hpack: "end",
  hexpand: true,
  children: [
    Widget.Label({
      class_name: "label",
      label: "Hello AGS! <end>",
    }),
    micSlider,
    speakerSlider,
  ]
})

App.config({
  style: "./style.css",
  windows: [
    Bar(0)
  ]
})
