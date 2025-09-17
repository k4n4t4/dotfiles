import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import { createBinding, createState } from "ags"

import Mpris from "gi://AstalMpris"

const FALLBACK_ICON = "audio-x-generic-symbolic"
const PLAY_ICON = "media-playback-start-symbolic"
const PAUSE_ICON = "media-playback-pause-symbolic"
const PREV_ICON = "media-skip-backward-symbolic"
const NEXT_ICON = "media-skip-forward-symbolic"


function lengthStr(length: number) {
  const min = Math.floor(length / 60)
  const sec = Math.floor(length % 60)
  const sec0 = sec < 10 ? "0" : ""
  return `${min}:${sec0}${sec}`
}

function Player({player}: {player: Mpris.Player}): JSX.Element {
  const img = (
    <box
      class="player-img"
      css={createBinding(player, 'coverArt').as(coverArt => `background-image: url('${coverArt}');`)} >
    </box>
  )

  const title = (
    <label
      class="player-title"
      wrap
      label={createBinding(player, 'title')}
    />
  )

  const artist = (
    <label
      class="player-artist"
      wrap
      label={createBinding(player, 'artist')}
    />
  )

  const slider = (
    <slider
      class="player-position"
      draw_value={false}
      onDragged={self => {
        player.position = self.value * player.length
      }}
      value={createBinding(createState.derive([
        createBinding(player, 'position'),
        createBinding(player, 'length'),
      ], (pos, len) => {
        const value = pos / len
        return value > 0 ? value : 0
      }))}
      visible={createBinding(player, 'length').as(len => len > 0)}
    />
  )

  const position_label = (
    <label
      class="player-position-label"
      label={createBinding(createState.derive([
        createBinding(player, 'position'),
        createBinding(player, 'length'),
      ], (pos, len) => {
        return lengthStr(len > 0 ? pos : 0)
      }))}
      wrap
    />
  )

  const length_label = (
    <label
      class="player-length"
      visible={createBinding(player, 'length').as(len => len > 0)}
      label={createBinding(player, 'length').as(lengthStr)}
    />
  )

  const icon = (
    <icon
      class="player-icon"
      hexpand
      tooltipText={player.identity || ""}
      icon={createBinding(player, 'entry').as(entry => {
        const name = `${entry}-symbolic`
        return Astal.Icon.lookup_icon(name) ? name : FALLBACK_ICON
      })}
    />
  )

  const pause = (
    <button
      class="player-play-pause"
      onClick={() => {player.play_pause()}}
      visible={createBinding(player, 'can_pause')}
    >
      <icon
        icon={createBinding(player, 'playback_status').as(s => {
          switch (s) {
            case Mpris.PlaybackStatus.PLAYING: return PAUSE_ICON
            case Mpris.PlaybackStatus.PAUSED:
            case Mpris.PlaybackStatus.STOPPED: return PLAY_ICON
          }
        })}
      />
    </button>
  )

  const prev = (
    <button
      class="player-play-prev"
      onClick={() => {player.previous()}}
      visible={createBinding(player, 'can_go_previous')}
    >
      <icon icon={PREV_ICON} />
    </button>
  )

  const next = (
    <button
      class="player-play-next"
      onClick={() => {player.next()}}
      visible={createBinding(player, 'can_go_next')}
    >
      <icon icon={NEXT_ICON} />
    </button>
  )

  return (
    <box class="player">
      {img}
      <box vertical hexpand>
        <box>
          {title}
          {icon}
        </box>
        {artist}
        <box vexpand />
        {slider}
        <centerbox>
          {position_label}
          <box>
            {prev}
            {pause}
            {next}
          </box>
          {length_label}
        </centerbox>
      </box>
    </box>
  )
}

export default function Media(gdkmonitor: Gdk.Monitor) {
  const mpris = Mpris.get_default()
  return (
    <window
      name="Media"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.RIGHT
      }
      application={app}
      visible={false}
    >
      <box
        class="media"
        vertical
        visible={createBinding(mpris, 'players').as(players => players.length > 0)}
      >
        {createBinding(mpris, 'players').as(players => players.map(player => <Player player={player} />))}
      </box>
    </window>
  )
}
