import app from "ags/gtk4/app"
import { Gtk } from "ags/gtk4"
import { createBinding, createComputed, With } from "ags"

import Mpris from "gi://AstalMpris"

const PLAY_ICON = "media-playback-start-symbolic"
const PAUSE_ICON = "media-playback-pause-symbolic"

export default function() {
  const mpris = Mpris.get_default()

  const class_names = createComputed([
    createBinding(mpris, 'players'),
  ], (players) => {
    const class_names = []
    if (players.length > 0) {
      class_names.push("exist-player")
    } else {
      class_names.push("not-exist-player")
    }
    return class_names
  })

  const tooltip_text = createComputed([
    createBinding(mpris, 'players'),
  ], (players) => {
      let str = ""
      for (let player of players) {
        str += `${player.title}${player.artist ? " - " + player.artist : ""}\n`
      }
      return str.trim()
  })

  const icon = createBinding(mpris, 'players').as(players => {
    if (players.length > 0) {
      const firstPlayer = players[0]
      const coverArt = firstPlayer.coverArt
      
      return (
        <button cssClasses={class_names} onClicked={() => {app.toggle_window("Media")}}>
          <box spacing={6}>
            {coverArt && (
              <box
                class="mpris-cover"
                css={`background-image: url('${coverArt}');`}
              />
            )}
            <image
              class="mpris-icon"
              iconName={createBinding(firstPlayer, 'playbackStatus').as(status => 
                status === Mpris.PlaybackStatus.PLAYING ? PAUSE_ICON : PLAY_ICON
              )}
              tooltipText={tooltip_text}
            />
            {players.length > 1 && (
              <label
                class="mpris-count"
                label={`+${players.length - 1}`}
                tooltipText={`${players.length} players`}
              />
            )}
          </box>
        </button>
      )
    } else {
      return <box />
    }
  })

  return (
    <box class="mpris">
      <With value={icon}>
        {icon => icon}
      </With>
    </box>
  )
}
