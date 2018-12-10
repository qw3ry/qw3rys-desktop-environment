#!/bin/sh
# PulseAudio Volume Control Script
#   2010-05-20 - Gary Hetzel <garyhetzel@gmail.com>
#
#   BUG:    Currently doesn't get information for the specified sink,
#           but rather just uses the first sink it finds in list-sinks
#           Need to fix this for systems with multiple sinks
#

STEP=3


get_active_sink() {
	pactl list short sinks | grep $(pactl info | grep "Default Sink:" | awk '{ print $3 }') | awk '{ print $1 }'
}

get_status_of_sink() {
	[ "$#" -ne 1 ] && exit 1;
	pactl list sinks | grep -A 100 "Sink \#$1" | tail -n +2 | sed "/Sink/q" | head -n -1
}

is_muted() {
	[ "$#" -ne 1 ] && exit 1;
	[[ $(get_status_of_sink $1 | grep -i "mute:" | awk '{ print $2 }') = "yes" ]] && echo true || echo false
}

get_vol() {
	[ "$#" -ne 1 ] && exit 1;
	get_status_of_sink $1 | grep -i "volume: front" | awk '{ print $5 }' | tr -d '\%'
}

repeat_n_times(){
  val=$(seq -s "$1" $(($2+1)) | sed 's/[0-9]//g')
  echo "${val}"
}

getbar(){
  width=25
  bar_size=$(expr $(get_vol $(get_active_sink)) \* $width / 100)
  bar=$(repeat_n_times "─" $bar_size)
  space=$(repeat_n_times ' ' $(expr $width - $bar_size))
  echo "$bar$space"
}

geticon(){
  vol=$(get_vol $(get_active_sink))
  if [ "$(is_muted $(get_active_sink))" = "true" ]; then
    echo "/usr/share/icons/Adwaita/64x64/status/audio-volume-muted-symbolic.symbolic.png"
  elif [ "$vol" -lt 33 ]; then
    echo "/usr/share/icons/Adwaita/64x64/status/audio-volume-low-symbolic.symbolic.png"
  elif [ "$vol" -lt 66 ]; then
    echo "/usr/share/icons/Adwaita/64x64/status/audio-volume-medium-symbolic.symbolic.png"
  else
    echo "/usr/share/icons/Adwaita/64x64/status/audio-volume-high-symbolic.symbolic.png"
  fi
}

getpadding(){
  if [[ "$1" -lt 10 ]]; then
    echo "   "
  elif [[ "$1" -lt 100 ]]; then
    echo "  "
  else
    echo " "
  fi
}

notify(){
  bar=$(getbar $1)
  icon=$(geticon $2 $1)
  pad=$(getpadding $1)
  dunstify -i "$icon" -t 2000 -r 2593 -u normal " $bar$pad$(get_vol $(get_active_sink))%"
}


case $1 in
up)
	pactl set-sink-volume @DEFAULT_SINK@ +${STEP}%;;
down)
	pactl set-sink-volume @DEFAULT_SINK@ -${STEP}%;;
max)
	pactl set-sink-volume @DEFAULT_SINK@ 100%;;
min)
	pactl set-sink-volume @DEFAULT_SINK@ 0%;;
toggle)
	pactl set-sink-mute @DEFAULT_SINK@ toggle;;
mute)
	pactl set-sink-mute @DEFAULT_SINK@ 1;;
unmute)
	pactl set-sink-mute @DEFAULT_SINK@ 0;;
esac

if [[ "$(get_vol $(get_active_sink))" -gt 100 ]]; then
	pactl set-sink-volume @DEFAULT_SINK@ 100%
fi

notify
