import { App, Astal, Gdk } from "astal/gtk3"
import { Variable, bind } from "astal"

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
      className="player-img"
      css={bind(player, 'coverArt').as(coverArt => `background-image: url('${coverArt}');`)} >
    </box>
  )

  const title = (
    <label
      className="player-title"
      wrap
      label={bind(player, 'title')}
    />
  )

  const artist = (
    <label
      className="player-artist"
      wrap
      label={bind(player, 'artist')}
    />
  )

  const slider = (
    <slider
      className="player-position"
      draw_value={false}
      onDragged={self => {
        player.position = self.value * player.length
      }}
      value={bind(Variable.derive([
        bind(player, 'position'),
        bind(player, 'length'),
      ], (pos, len) => {
        const value = pos / len
        return value > 0 ? value : 0
      }))}
      visible={bind(player, 'length').as(len => len > 0)}
    />
  )

  const position_label = (
    <label
      className="player-position-label"
      label={bind(Variable.derive([
        bind(player, 'position'),
        bind(player, 'length'),
      ], (pos, len) => {
        return lengthStr(len > 0 ? pos : 0)
      }))}
      wrap
    />
  )

  const length_label = (
    <label
      className="player-length"
      visible={bind(player, 'length').as(len => len > 0)}
      label={bind(player, 'length').as(lengthStr)}
    />
  )

  const icon = (
    <icon
      className="player-icon"
      hexpand
      tooltipText={player.identity || ""}
      icon={bind(player, 'entry').as(entry => {
        const name = `${entry}-symbolic`
        return Astal.Icon.lookup_icon(name) ? name : FALLBACK_ICON
      })}
    />
  )

  const pause = (
    <button
      className="player-play-pause"
      onClick={() => {player.play_pause()}}
      visible={bind(player, 'can_pause')}
    >
      <icon
        icon={bind(player, 'playback_status').as(s => {
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
      className="player-play-prev"
      onClick={() => {player.previous()}}
      visible={bind(player, 'can_go_previous')}
    >
      <icon icon={PREV_ICON} />
    </button>
  )

  const next = (
    <button
      className="player-play-next"
      onClick={() => {player.next()}}
      visible={bind(player, 'can_go_next')}
    >
      <icon icon={NEXT_ICON} />
    </button>
  )

  return (
    <box className="player">
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
      application={App}
      visible={false}
    >
      <box
        className="media"
        vertical
        visible={bind(mpris, 'players').as(players => players.length > 0)}
      >
        {bind(mpris, 'players').as(players => players.map(player => <Player player={player} />))}
      </box>
    </window>
  )
}
