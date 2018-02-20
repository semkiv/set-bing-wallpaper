#!/bin/bash
# License: GNU General Public License v3.0
# Description: Downloads Bing picture of the day and sets it as your desktop background.

# $bing is used to form the fully qualified URL for the Bing pic of the day
bing="www.bing.com"

# The mkt parameter determines which Bing market you would like to  obtain your images from.
# Valid values are:
# auto
# ar-XA (Arabic - Arabia)
# bg-BG (Bulgarian - Bulgaria)
# cs-CZ (Czech - Czech Republic)
# da-DK (Danish - Denmark)
# de-AT (German - Austria)
# de-CH (German - Switzerland)
# de-DE (German - Germany)
# el-GR (Greek - Greece)
# en-AU (English - Australia)
# en-CA (English - Canada)
# en-GB (English - United Kingdom)
# en-ID (English - Indonesia)
# en-IE (English - Ireland)
# en-IN (English - India)
# en-MY (English - Malaysia)
# en-NZ (English - New Zealand)
# en-PH (English - Philippines)
# en-SG (English - Singapore)
# en-US (English - United States)
# en-WW (English - International)
# en-XA (English - Arabia)
# en-ZA (English - South Africa)
# es-AR (Spanish - Argentina)
# es-CL (Spanish - Chile)
# es-ES (Spanish - Spain)
# es-MX (Spanish - Mexico)
# es-US (Spanish - United States)
# es-XL (Spanish - Latin America)
# et-EE (Estonian - Estonia)
# fi-FI (Finnish - Finland)
# fr-BE (French - Belgium)
# fr-CA (French - Canada)
# fr-CH (French - Switzerland)
# fr-FR (French - France)
# he-IL (Hebrew - Israel)
# hr-HR (Croatian - Croatia)
# hu-HU (Hungarian - Hungary)
# it-IT (Italian - Italy)
# ja-JP (Japanese - Japan)
# ko-KR (Korean - Korea)
# lt-LT (Lithuanian - Lithuania)
# lv-LV (Latvian - Latvia)
# nb-NO (Norwegian - Norway)
# nl-BE (Dutch - Belgium)
# nl-NL (Dutch - Netherlands)
# pl-PL (Polish - Poland)
# pt-BR (Portuguese - Brazil)
# pt-PT (Portuguese - Portugal)
# ro-RO (Romanian - Romania)
# ru-RU (Russian - Russia)
# sk-SK (Slovak - Slovak Republic)
# sl-SL (Slovenian - Slovenia)
# sv-SE (Swedish - Sweden)
# th-TH (Thai - Thailand)
# tr-TR (Turkish - Turkey)
# uk-UA (Ukrainian - Ukraine)
# zh-CN (Chinese - China)
# zh-HK (Chinese - Hong Kong SAR)
# zh-TW (Chinese - Taiwan)
mkt="en-WW"

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
		# This is needed for systemd
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
