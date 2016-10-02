#!/bin/bash
# License: GNU General Public License v3.0
# Description: Downloads Bing picture of the day and sets it as your desktop background.

# $bing is used to form the fully qualified URL for the Bing pic of the day
bing="www.bing.com"

# The mkt parameter determines which Bing market you would like to  obtain your images from.
# Valid values are: auto, en_US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
mkt="auto"

# The idx parameter determines where to start from. 0 is the current day, 1 the previous day, etc.
idx="0"

# $xmlURL is needed to get the xml data from which the relative URL for the Bing pic of the day is extracted
xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=${idx}&n=1&mkt=${mkt}"

picID="$(echo "$(curl -s "$xmlURL")" | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)"

# $saveDir is used to set the location where Bing pics of the day are stored. $HOME holds the path of the current user's home directory
saveDir="${HOME}/Dropbox/Pictures/Wallpapers/Bing/"

# Set picture options
# Valid options are: none,wallpaper,centered,scaled,stretched,zoom,spanned
picOpts="zoom"

# The file extension for the Bing pic
picExt=".jpg"

# Create saveDir if it does not already exist
mkdir -p "$saveDir"

# Download the highest resolution
for picRes in "_1920x1080" "_1920x1200" "_1366x768" "_1280x720" "_1024x768"; do

	# Extract the relative URL of the Bing pic of the day from the XML data retrieved from xmlURL, form the fully qualified URL for the pic of the day, and store it in $picURL
	picURL="$bing$picID$picRes$picExt"

	# $picName contains the filename of the Bing pic of the day
	picName="$(basename "$picURL")"

	# Download the Bing pic of the day
	if curl -f -s -o "$saveDir$picName" "$picURL"; then
		# This is needed for systemd. Replace "semkiv" with username. Probably $(whoami) can be used but I'm not sure if it will work when run by systemd
		export DBUS_SESSION_BUS_ADDRESS="$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u semkiv -n gnome-session)/environ | cut -d= -f2-)"

		# Set the GNOME3 wallpaper
		dconf write "/org/gnome/desktop/background/picture-uri" "\"file://${saveDir}${picName}\""

		# Set the GNOME 3 wallpaper picture options
		dconf write "/org/gnome/desktop/background/picture-options" "\"${picOpts}\""

		# Send a notification
		notify-send "Bing wallpaper" "Bing picture of the day \"${picName}\" has been downloaded and set as your desktop wallpaper" -c "transfer.complete"

		# Create a log entry
		logger -t bing_wallpaper "Bing picture of the day \"${picName}\" was downloaded and set as wallpaper"

		# Exit the script
		exit 0
	fi
done

# Send a notification
notify-send "Bing wallpaper" "Setting the wallpaper failed. Cannot download the picture" -c "transfer.error"

# Create a log entry
logger -t bing_wallpaper "Setting the wallpaper failed. Cannot download the picture"

# Exit the script
exit 1
