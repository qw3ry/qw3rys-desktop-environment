#!/bin/sh

logfile="$(mktemp -t qde-XXXXX.log)"

for script in ${QDE_AUTOSTART}/*; do
	echo "Running $script"
	exec $script & > $logfile 2>&1
done

wait

#run-parts --new-session -- "${QDE_AUTOSTART}" > $logfile
