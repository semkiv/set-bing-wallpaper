# set-bing-wallpaper

These are simple scripts that download Bing picture of the day and set it the desktop wallpaper. Download and storing options are set through command line arguments.

## Linux

The Linux script was originally inspired by [this post](https://ubuntuforums.org/showthread.php?t=2074098&p=12308115#post12308115), `set-bing-wallpaper.sh`, was written for GNOME desktop environment and was tested exclusively in that environment. It *might* work with other DEs, but I can by no means guarantee that and, honestly, most likely it won't. However you're welcome to explore the source of the script and modify it accordingly.

The script relies on [cURL](http://curl.haxx.se) in working with Bing servers. It is often shipped with most Linux distributions so chances that you already have it are pretty high.

The downloading and storing options can be controlled via command line arguments. Below are the available options:

* `-m` determines which Bing market you would like to obtain images from. Available options are: `auto` (selected automatically by Bing), `ar-XA` (Arabic - Arabia), `bg-BG` (Bulgarian - Bulgaria), `cs-CZ` (Czech - Czech Republic), `da-DK` (Danish - Denmark), `de-AT` (German - Austria), `de-CH` (German - Switzerland), `de-DE` (German - Germany), `el-GR` (Greek - Greece), `en-AU` (English - Australia), `en-CA` (English - Canada), `en-GB` (English - United Kingdom), `en-ID` (English - Indonesia), `en-IE` (English - Ireland), `en-IN` (English - India), `en-MY` (English - Malaysia), `en-NZ` (English - New Zealand), `en-PH` (English - Philippines), `en-SG` (English - Singapore), `en-US` (English - United States), `en-WW` (English - International), `en-XA` (English - Arabia), `en-ZA` (English - South Africa), `es-AR` (Spanish - Argentina), `es-CL` (Spanish - Chile), `es-ES` (Spanish - Spain), `es-MX` (Spanish - Mexico), `es-US` (Spanish - United States), `es-XL` (Spanish - Latin America), `et-EE` (Estonian - Estonia), `fi-FI` (Finnish - Finland), `fr-BE` (French - Belgium), `fr-CA` (French - Canada), `fr-CH` (French - Switzerland), `fr-FR` (French - France), `he-IL` (Hebrew - Israel), `hr-HR` (Croatian - Croatia), `hu-HU` (Hungarian - Hungary), `it-IT` (Italian - Italy), `ja-JP` (Japanese - Japan), `ko-KR` (Korean - Korea), `lt-LT` (Lithuanian - Lithuania), `lv-LV` (Latvian - Latvia), `nb-NO` (Norwegian - Norway), `nl-BE` (Dutch - Belgium), `nl-NL` (Dutch - Netherlands), `pl-PL` (Polish - Poland), `pt-BR` (Portuguese - Brazil), `pt-PT` (Portuguese - Portugal), `ro-RO` (Romanian - Romania), `ru-RU` (Russian - Russia), `sk-SK` (Slovak - Slovak Republic), `sl-SL` (Slovenian - Slovenia), `sv-SE` (Swedish - Sweden), `th-TH` (Thai - Thailand), `tr-TR` (Turkish - Turkey), `uk-UA` (Ukrainian - Ukraine), `zh-CN` (Chinese - China), `zh-HK` (Chinese - Hong Kong SAR), `zh-TW` (Chinese - Taiwan). `auto` by default.

* `-n` determines the day to fetch the wallpaper of. `N` days ago, `0` is today, `1` - yesterday, `2` - the day before yesterday and so on; `6` is the highest possible value. `0` by default.

* `-r` determines the resolution of the downloaded image. Available options are: `UHD`, `1920x1200`, `1920x1080`, `1366x768`, `1280x720`, `1024x768`. `UHD` by default.

* `-d` determines the location to save the picture to. `XDG_PICTURES_DIR` by default.

* `-f` determines fit options for the wallpaper. Available options are: `centered`, `none`, `scaled`, `spanned`, `stretched`, `wallpaper`, `zoom`. `zoom` by default.

* `-h` shows help message.

You might want to run this script regularly. One way to do so is setting up a systemd service and timer. Create files `set-bing-wallpaper.service` and `set-bing-wallpaper.timer` (you can name them differently if you wish so) with the content shown below (feel free to set the options that suit your needs; see [more about systemd timers](https://wiki.archlinux.org/index.php/Systemd/Timers)) under `~/.config/systemd/user/`.

* **`set-bing-wallpaper.service`**

    ```text
    [Unit]
    Description = "Download Bing daily background image and set it as desktop background"
    # the script uses DBUS session address to set the walpaper in the correct GNOME session
    Wants = dbus.service
    Wants = network-online.target
    After = dbus.service
    After = network-online.target

    [Service]
    Type = oneshot
    # do not forget to set the correct path to the script; specify command line options if you need
    ExecStart = "/home/linuxuser/.set-bing-wallpaper.sh"

    [Install]
    WantedBy = default.target
    ```

* **`set-bing-wallpaper.timer`**

    ```text
    [Unit]
    Description = "Download Bing daily background image and set it as desktop background daily at 13:00"

    [Timer]
    OnCalendar = 13:00
    Persistent = true
    Unit = set-bing-wallpaper.service

    [Install]
    WantedBy = timers.target
    ```

Then enable the service and the timer:

```bash
systemctl --user enable set-bing-wallpaper.service
systemctl --user enable set-bing-wallpaper.timer
```

Finally run the timer

```bash
systemctl --user start set-bing-wallpaper.timer
```

### Known issues

* Because `systemd -user` is run earlier than gnome-shell (and earlier than `DBUS_SESSION_BUS_ADDRESS` environment variable is set) the run just after login (caused by persistent timer in case of missed run) will fail. For possible solution see [this thread](https://bbs.archlinux.org/viewtopic.php?id=197223).

## Windows

The Windows version, `Set-BingWallpaper.ps1` is basically `set-bing-wallpaper.sh` ported to PowerShell. Now the big problem with PowerShell is that Windows does not allow PowerShell scripts are not allowed to run unless they're signed. This one is not signed. Luckily Microsoft has prepared a [great article](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_signing) about how to deal with this.

Just as with the Linux version of the script the downloading and storing options can be controlled via command line arguments, though the option names are different. Below are the available options:

* `-Market` determines which Bing market you would like to obtain images from. It's the equivalent of `-m` option of the [Linux version](#Linux). Available options are the same.

* `-DaysAgo` determines the day to fetch the wallpaper of. It's the equivalent of `-n` option of the [Linux version](#Linux). Available options are the same.

* `-Resolution` determines the resolution of the downloaded image. It's the equivalent of `-r` option of the [Linux version](#Linux). Available options are the same.

* `-SaveTo` determines the location to save the picture to. It's the equivalent of `-d` option of the [Linux version](#Linux). `%USERPROFILE%\Pictures` by default.

* `-Style` determines fit options for the wallpaper. It's the equivalent of `-f` option of the [Linux version](#Linux). Available options are: `Center`, `Fill`, `Fit`, `Span`, `Stretch`, `Tile`. `Fill` by default.

To get help use PowerShell `Get-Help` cmdlet:

```powershell
Get-Help -Name .\Set-BingWallpaper.ps1
```

You can use Task Scheduler to make the script run regularly.
Create a task with a "Start a Program" Action. Set "Program/script" field to `powershell.exe` and "Add arguments (optional)" field to `-WindowStyle hidden -NoLogo -NonInteractive -File "C:\Path\To\Your\Set-BingWallpaper.ps1"`. See [here](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_powershell_exe) about `powershell.exe` command line options.
If you need to pass some arguments to the script you can append them in this field, for example `-WindowStyle hidden -NoLogo -NonInteractive -File "C:\Path\To\Your\Set-BingWallpaper.ps1" -Market en-WW -DaysAgo 2 -Resolution 1920x1080`.
Learn more about creating tasks in Task Scheduler [here](https://www.windowscentral.com/how-create-automated-task-using-task-scheduler-windows-10).
