# set_bing_wallpaper
This is a simple BASH script that downloads Bing picture of the day and sets as the GNOME desktop wallpaper. Download and storing options are set directly in the script file (have a look at source code). Feel free to change them.
This script requires cURL (http://curl.haxx.se/; it is shiped with most Linux distribution) to run.
You might as well run this script regularly. You can do so by copying `set-bing-wallpaper.service` and `set-bing-wallpaper.timer` to `~/.config/systemd/user/` and modyfying them according to your needs. Then enable service and timer:
```bash
systemctl --user enable set-bing-wallpaper.service
systemctl --user enable set-bing-wallpaper.timer
```
Finally run the timer
```bash
systemctl --user start set-bing-wallpaper.timer
```
