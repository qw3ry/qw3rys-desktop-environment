#!/bin/sh

sleep 2
keepassxc &
disown

sleep 5
nextcloud &
disown

sleep 5
rambox &
disown

echo "Apps waiting"

wait

echo "Done"
