#!/bin/fish

set options (systemctl reboot --boot-loader-entry=help) BIOS
set chosen (zenity --list --title "Reboot to" --column "OS" $options)

switch $chosen
	case BIOS
		systemctl reboot --firmware-setup
  case '*'
		systemctl reboot --boot-loader-entry="$chosen"
end
