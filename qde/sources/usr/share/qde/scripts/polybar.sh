#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

main_started=false
for screen in $(xrandr -q | grep " connected" | cut -d' ' -f1); do
	if [ "$main_started" = true ]; then
		mode=secondary
	else
		mode=main
	fi
	MONITOR=$screen polybar --config=$QDE_CONFIG/polybar.conf $mode &
done

echo "Bars launched..."
