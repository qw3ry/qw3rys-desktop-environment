#!/bin/sh

compton -f --config "${QDE_CONFIG}/compton.conf" &
disown

dunst &
disown

udiskie --tray &
disown

echo "Core waiting"

wait

echo "done"
