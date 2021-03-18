<#
    .SYNOPSIS
    Applies a specified wallpaper to the current user's desktop

    .PARAMETER Market
    Determines which Bing market you would like to obtain your images from.
    Available options are:
    "auto" (selected automatically by Bing),
    "ar-XA" (Arabic - Arabia),
    "bg-BG" (Bulgarian - Bulgaria),
    "cs-CZ" (Czech - Czech Republic),
    "da-DK" (Danish - Denmark),
    "de-AT" (German - Austria),
    "de-CH" (German - Switzerland),
    "de-DE" (German - Germany),
    "el-GR" (Greek - Greece),
    "en-AU" (English - Australia),
    "en-CA" (English - Canada),
    "en-GB" (English - United Kingdom),
    "en-ID" (English - Indonesia),
    "en-IE" (English - Ireland),
    "en-IN" (English - India),
    "en-MY" (English - Malaysia),
    "en-NZ" (English - New Zealand),
    "en-PH" (English - Philippines),
    "en-SG" (English - Singapore),
    "en-US" (English - United States),
    "en-WW" (English - International),
    "en-XA" (English - Arabia),
    "en-ZA" (English - South Africa),
    "es-AR" (Spanish - Argentina),
    "es-CL" (Spanish - Chile),
    "es-ES" (Spanish - Spain),
    "es-MX" (Spanish - Mexico),
    "es-US" (Spanish - United States),
    "es-XL" (Spanish - Latin America),
    "et-EE" (Estonian - Estonia),
    "fi-FI" (Finnish - Finland),
    "fr-BE" (French - Belgium),
    "fr-CA" (French - Canada),
    "fr-CH" (French - Switzerland),
    "fr-FR" (French - France),
    "he-IL" (Hebrew - Israel),
    "hr-HR" (Croatian - Croatia),
    "hu-HU" (Hungarian - Hungary),
    "it-IT" (Italian - Italy),
    "ja-JP" (Japanese - Japan),
    "ko-KR" (Korean - Korea),
    "lt-LT" (Lithuanian - Lithuania),
    "lv-LV" (Latvian - Latvia),
    "nb-NO" (Norwegian - Norway),
    "nl-BE" (Dutch - Belgium),
    "nl-NL" (Dutch - Netherlands),
    "pl-PL" (Polish - Poland),
    "pt-BR" (Portuguese - Brazil),
    "pt-PT" (Portuguese - Portugal),
    "ro-RO" (Romanian - Romania),
    "ru-RU" (Russian - Russia),
    "sk-SK" (Slovak - Slovak Republic),
    "sl-SL" (Slovenian - Slovenia),
    "sv-SE" (Swedish - Sweden),
    "th-TH" (Thai - Thailand),
    "tr-TR" (Turkish - Turkey),
    "uk-UA" (Ukrainian - Ukraine),
    "zh-CN" (Chinese - China),
    "zh-HK" (Chinese - Hong Kong SAR),
    "zh-TW" (Chinese - Taiwan).
    Will use "auto" if not specified

    .PARAMETER DaysAgo
    Determines the day to fetch the wallpaper of (N days ago, 0 is today, 1 - yesterday, 2 - the day before yesterday and so on).
    6 is the highest possible value.
    Will use 0 if not specified.

    .PARAMETER PicRes
    Determines the resolution of the downloaded image
    Valid values are:
    "UHD",
    "1920x1200",
    "1920x1080",
    "1366x768",
    "1280x720",
    "1024x768".
    Will use "UHD" if not specified.

    .PARAMETER SaveTo
    Determines the location to save the picture to.
    Will use %USERPROFILE%\Pictures if not specified.

    .PARAMETER Style
    Determines fit options for the wallpaper.
    Valid options are:
    "Center",
    "Fill",
    "Fit",
    "Span",
    "Stretch",
    "Tile".
    Will use "Fill" if not specified.

    .EXAMPLE
    Set-Bing-WallPaper
    Set-Bing-WallPaper -Market "en-WW" -DaysAgo 2 -PicRes "1920x1080" -SaveTo "C:\Wallpapers" -Style "Stretch"
#>

param (
    [Parameter(Mandatory = $False)]
    [ValidateSet(
        "auto",
        "ar-XA",
        "bg-BG",
        "cs-CZ",
        "da-DK",
        "de-AT",
        "de-CH",
        "de-DE",
        "el-GR",
        "en-AU",
        "en-CA",
        "en-GB",
        "en-ID",
        "en-IE",
        "en-IN",
        "en-MY",
        "en-NZ",
        "en-PH",
        "en-SG",
        "en-US",
        "en-WW",
        "en-XA",
        "en-ZA",
        "es-AR",
        "es-CL",
        "es-ES",
        "es-MX",
        "es-US",
        "es-XL",
        "et-EE",
        "fi-FI",
        "fr-BE",
        "fr-CA",
        "fr-CH",
        "fr-FR",
        "he-IL",
        "hr-HR",
        "hu-HU",
        "it-IT",
        "ja-JP",
        "ko-KR",
        "lt-LT",
        "lv-LV",
        "nb-NO",
        "nl-BE",
        "nl-NL",
        "pl-PL",
        "pt-BR",
        "pt-PT",
        "ro-RO",
        "ru-RU",
        "sk-SK",
        "sl-SL",
        "sv-SE",
        "th-TH",
        "tr-TR",
        "uk-UA",
        "zh-CN",
        "zh-HK",
        "zh-TW"
    )]
    [String]$Market = "auto",

    [Parameter(Mandatory = $False)]
    [ValidateRange(0, 7)]
    [Uint32]$DaysAgo = 0,

    [Parameter(Mandatory = $False)]
    [ValidateSet(
        "UHD",
        "1920x1080",
        "1920x1200",
        "1366x768",
        "1280x720",
        "1024x768"
    )]
    [String]$PicRes = "UHD",

    [Parameter(Mandatory = $False)]
    [String]$SaveTo = [Environment]::GetFolderPath("MyPictures"),

    [Parameter(Mandatory = $False)]
    [ValidateSet(
        "Center",
        "Fill",
        "Fit",
        "Span",
        "Stretch",
        "Tile"
    )]
    [String]$Style = "Fill"
)

Function Set-Wallpaper {
    <#
        .SYNOPSIS
        Applies a specified wallpaper to the current user's desktop

        .PARAMETER Image
        Provide the exact path to the image

        .PARAMETER Style
        Provide wallpaper style (Example: Fill, Fit, Stretch, Tile, Center, or Span)

        .EXAMPLE
        Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
        Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
    #>

    param (
        [Parameter(Mandatory = $True)]
        # Provide path to image
        [String]$Image,
        # Provide wallpaper style that you would like applied
        [Parameter(Mandatory = $False)]
        [ValidateSet(
            "Center",
            "Fill",
            "Fit",
            "Span",
            "Stretch",
            "Tile"
        )]
        [String]$Style = "Fill"
    )

    $WallpaperStyle = Switch ($Style) {
        "Center" { "0" }
        "Fill" { "10" }
        "Fit" { "6" }
        "Span" { "22" }
        "Stretch" { "2" }
        "Tile" { "0" }
    }

    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -PropertyType String -Value $WallpaperStyle -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -PropertyType String -Value $(If ($Style -eq "Tile") { 1 } Else { 0 }) -Force | Out-Null

    Add-Type -TypeDefinition "
        using System;
        using System.Runtime.InteropServices;

        public class Params {
            [DllImport(`"User32.dll`", CharSet = CharSet.Unicode)]
            public static extern int SystemParametersInfo(
                Int32 uAction,
                Int32 uParam,
                String lpvParam,
                Int32 fuWinIni
            );
        }
    "

    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02

    $fWinIni = $UpdateIniFile -bor $SendChangeEvent

    [Void] [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

$Bing = "www.bing.com"
# just FYI the equivalent JSON format can be retrieved by setting `format` in the URL below to `js`
$XmlUrl = "${Bing}/HPImageArchive.aspx?format=xml&idx=${DaysAgo}&n=1&mkt=${Market}"

[Xml]$Xml = (Invoke-WebRequest -Uri $XmlUrl -UseBasicParsing).Content
$UrlBase = $Xml.images.image.urlBase
$PicName = "$($Xml.images.image.copyright).jpg".Split([IO.Path]::GetInvalidFileNameChars()) -join ''
$PicUrl = "${Bing}/${UrlBase}_${PicRes}.jpg"
$FullPath = "${SaveTo}/${PicName}"

Try {
    Invoke-WebRequest -Uri $PicUrl -UseBasicParsing -ErrorAction Stop -OutFile $FullPath
    Write-Output "Downloaded '${PicName}' to '${SaveTo}'."
    Set-Wallpaper $FullPath $Style
    Write-Output "Set as desktop wallpaper."
}
Catch {
    Write-Error "Could not download ${PicUrl}. Status: $($_.Exception.Message)."
}
