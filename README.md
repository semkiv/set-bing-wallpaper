# set-bing-wallpaper

This is a simple BASH script that downloads Bing picture of the day and sets as the GNOME desktop wallpaper. Download and storing options are set through command line arguments.
This script requires [cURL](http://curl.haxx.se) (it is shipped with most Linux distribution) to run.
You might as well run this script regularly. You can do so by copying `set-bing-wallpaper.service` and `set-bing-wallpaper.timer` to `~/.config/systemd/user/` and modifying them according to your needs. Then enable service and timer:

```bash
systemctl --user enable set-bing-wallpaper.service
systemctl --user enable set-bing-wallpaper.timer
```

Finally run the timer

```bash
systemctl --user start set-bing-wallpaper.timer
```

## Known issues

+ Because `systemd -user` is run earlier than gnome-shell (and earlier than `DBUS_SESSION_BUS_ADDRESS` environment variable is set) the run just after login (caused by persistent timer in case of missed run) will fail. For possible solution see https://bbs.archlinux.org/viewtopic.php?id=197223
