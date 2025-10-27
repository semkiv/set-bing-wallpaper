#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

usage_help="
Usage: $(basename "$0") [OPTIONS]

Options:
  -m    Determines which Bing market you would like to obtain images from;
          available options are:
          \"auto\" (selected automatically by Bing),
          \"ar-XA\" (Arabic - Arabia),
          \"bg-BG\" (Bulgarian - Bulgaria),
          \"cs-CZ\" (Czech - Czech Republic),
          \"da-DK\" (Danish - Denmark),
          \"de-AT\" (German - Austria),
          \"de-CH\" (German - Switzerland),
          \"de-DE\" (German - Germany),
          \"el-GR\" (Greek - Greece),
          \"en-AU\" (English - Australia),
          \"en-CA\" (English - Canada),
          \"en-GB\" (English - United Kingdom),
          \"en-ID\" (English - Indonesia),
          \"en-IE\" (English - Ireland),
          \"en-IN\" (English - India),
          \"en-MY\" (English - Malaysia),
          \"en-NZ\" (English - New Zealand),
          \"en-PH\" (English - Philippines),
          \"en-SG\" (English - Singapore),
          \"en-US\" (English - United States),
          \"en-WW\" (English - International),
          \"en-XA\" (English - Arabia),
          \"en-ZA\" (English - South Africa),
          \"es-AR\" (Spanish - Argentina),
          \"es-CL\" (Spanish - Chile),
          \"es-ES\" (Spanish - Spain),
          \"es-MX\" (Spanish - Mexico),
          \"es-US\" (Spanish - United States),
          \"es-XL\" (Spanish - Latin America),
          \"et-EE\" (Estonian - Estonia),
          \"fi-FI\" (Finnish - Finland),
          \"fr-BE\" (French - Belgium),
          \"fr-CA\" (French - Canada),
          \"fr-CH\" (French - Switzerland),
          \"fr-FR\" (French - France),
          \"he-IL\" (Hebrew - Israel),
          \"hr-HR\" (Croatian - Croatia),
          \"hu-HU\" (Hungarian - Hungary),
          \"it-IT\" (Italian - Italy),
          \"ja-JP\" (Japanese - Japan),
          \"ko-KR\" (Korean - Korea),
          \"lt-LT\" (Lithuanian - Lithuania),
          \"lv-LV\" (Latvian - Latvia),
          \"nb-NO\" (Norwegian - Norway),
          \"nl-BE\" (Dutch - Belgium),
          \"nl-NL\" (Dutch - Netherlands),
          \"pl-PL\" (Polish - Poland),
          \"pt-BR\" (Portuguese - Brazil),
          \"pt-PT\" (Portuguese - Portugal),
          \"ro-RO\" (Romanian - Romania),
          \"ru-RU\" (Russian - Russia),
          \"sk-SK\" (Slovak - Slovak Republic),
          \"sl-SL\" (Slovenian - Slovenia),
          \"sv-SE\" (Swedish - Sweden),
          \"th-TH\" (Thai - Thailand),
          \"tr-TR\" (Turkish - Turkey),
          \"uk-UA\" (Ukrainian - Ukraine),
          \"zh-CN\" (Chinese - China),
          \"zh-HK\" (Chinese - Hong Kong SAR),
          \"zh-TW\" (Chinese - Taiwan);
          will use \"auto\" if not specified
  -n    determines the day to fetch the wallpaper of; N days ago, 0 is today, 1 - yesterday, 2 - the day before yesterday and so on;
            6 is the highest possible value;
            will use 0 if not specified
  -d    determines the location to save the picture to;
            will use XDG_PICTURES_DIR if not specified
  -f    determines fit options for the wallpaper;
            available options are:
            \"centered\",
            \"none\",
            \"scaled\",
            \"spanned\",
            \"stretched\",
            \"wallpaper\",
            \"zoom\";
            will use \"zoom\" if not specified
  -h    show this help
"

usage() {
    echo "${usage_help}" 1>&2
    exit 1
}

log() {
    local -r priority="${1}"
    local -r message="${2}"
    echo "${message}" | systemd-cat --identifier "set-bing-wallpaper" --priority "${priority}"
}

log_info() {
    local -r message="${1}"
    log "info" "${message}"
}

log_error() {
    local -r message="${1}"
    log "error" "${message}"
}

notify() {
    local -r icon="${1}"
    local -r summary="${2}"
    local -r body="${3}"
    notify-send --app-name "Daily Bing Wallpaper" --icon "${icon}" "${summary}" "${body}"
}

notify_info() {
    local -r summary="${1}"
    local -r body="${2}"
    notify "image-x-generic" "${summary}" "${body}"
}

notify_error() {
    local -r summary="${1}"
    local -r body="${2}"
    notify "image-missing" "${summary}" "${body}"
}

report_info() {
    local -r summary="${1}"
    local -r body="${2}"
    log_info "${summary}. ${body}"
    notify_info "${summary}" "${body}"
}

report_error() {
    local -r summary="${1}"
    local -r body="${2}"
    log_error "${summary}. ${body}"
    notify_error "${summary}" "${body}"
}

verify_market() {
    [[
        "${1}" == "auto"  \
        || "${1}" == "ar-XA" \
        || "${1}" == "bg-BG" \
        || "${1}" == "cs-CZ" \
        || "${1}" == "da-DK" \
        || "${1}" == "de-AT" \
        || "${1}" == "de-CH" \
        || "${1}" == "de-DE" \
        || "${1}" == "el-GR" \
        || "${1}" == "en-AU" \
        || "${1}" == "en-CA" \
        || "${1}" == "en-GB" \
        || "${1}" == "en-ID" \
        || "${1}" == "en-IE" \
        || "${1}" == "en-IN" \
        || "${1}" == "en-MY" \
        || "${1}" == "en-NZ" \
        || "${1}" == "en-PH" \
        || "${1}" == "en-SG" \
        || "${1}" == "en-US" \
        || "${1}" == "en-WW" \
        || "${1}" == "en-XA" \
        || "${1}" == "en-ZA" \
        || "${1}" == "es-AR" \
        || "${1}" == "es-CL" \
        || "${1}" == "es-ES" \
        || "${1}" == "es-MX" \
        || "${1}" == "es-US" \
        || "${1}" == "es-XL" \
        || "${1}" == "et-EE" \
        || "${1}" == "fi-FI" \
        || "${1}" == "fr-BE" \
        || "${1}" == "fr-CA" \
        || "${1}" == "fr-CH" \
        || "${1}" == "fr-FR" \
        || "${1}" == "he-IL" \
        || "${1}" == "hr-HR" \
        || "${1}" == "hu-HU" \
        || "${1}" == "it-IT" \
        || "${1}" == "ja-JP" \
        || "${1}" == "ko-KR" \
        || "${1}" == "lt-LT" \
        || "${1}" == "lv-LV" \
        || "${1}" == "nb-NO" \
        || "${1}" == "nl-BE" \
        || "${1}" == "nl-NL" \
        || "${1}" == "pl-PL" \
        || "${1}" == "pt-BR" \
        || "${1}" == "pt-PT" \
        || "${1}" == "ro-RO" \
        || "${1}" == "ru-RU" \
        || "${1}" == "sk-SK" \
        || "${1}" == "sl-SL" \
        || "${1}" == "sv-SE" \
        || "${1}" == "th-TH" \
        || "${1}" == "tr-TR" \
        || "${1}" == "uk-UA" \
        || "${1}" == "zh-CN" \
        || "${1}" == "zh-HK" \
        || "${1}" == "zh-TW" \
    ]] || usage
}

verify_days_ago() {
    [[
        "${1}" == "0"    \
        || "${1}" == "1" \
        || "${1}" == "2" \
        || "${1}" == "3" \
        || "${1}" == "4" \
        || "${1}" == "5" \
        || "${1}" == "6" \
    ]] || usage
}

verify_fit() {
    [[
        "${1}" == "centered"     \
        || "${1}" == "none"      \
        || "${1}" == "scaled"    \
        || "${1}" == "spanned"   \
        || "${1}" == "stretched" \
        || "${1}" == "wallpaper" \
        || "${1}" == "zoom"      \
    ]] || usage
}

set_gnome_wallpaper() {
    # set the GNOME3 wallpaper, both light and dark variants
    for option in "picture-uri" "picture-uri-dark"; do
        if ! (gsettings set "org.gnome.desktop.background" "${option}" "\"${1}\"" && gsettings set "org.gnome.desktop.background" "picture-options" "\"${2}\""); then
            local -r error=${?}
            report_error "Setting the wallpaper failed" "Error ${error}"
            return "${error}"
        fi
    done
}

# default values; can be overridden by the command line parameters below
market="auto"
days_ago="0"
save_dir="$(xdg-user-dir PICTURES)"
fit="zoom"

while getopts ":m:n:r:d:f:h" option; do
    case "${option}" in
        "m")
            market="${OPTARG}"
            verify_market "${market}"
            ;;
        "n")
            days_ago="${OPTARG}"
            verify_days_ago "${days_ago}"
            ;;
        "d")
            save_dir="${OPTARG}"
            ;;
        "f")
            fit="${OPTARG}"
            verify_fit "${fit}"
            ;;
        "h")
            usage
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND - 1))

# $bing is used to form the fully qualified URL for the Bing pic of the day
bing="www.bing.com"

# $xml_url is needed to get the XML data from which the relative URL for the Bing pic of the day is extracted
# just FYI the equivalent JSON format can be retrieved by setting `format` in the URL below to `js`
xml_url="${bing}/HPImageArchive.aspx?format=xml&idx=${days_ago}&n=1&mkt=${market}"
# get picture ID
xml="$(curl --fail --silent --retry 10 --retry-max-time 60 "${xml_url}")"
url_base="$(echo "${xml}" | grep -oP "<urlBase>\K(.*)(?=</urlBase>)")"
name="$(echo "${xml}" | grep -oP "<copyright>\K(.*)(?=</copyright>)" | sed "s/\//, /g")"

# fully qualified URL for the pic of the day
url="${bing}/${url_base}_UHD.jpg&w=3840&h=2160&rs=1"

# create $save_dir if it does not already exist
mkdir -p "${save_dir}"

# download the pic
curl --fail --silent --retry 10 --retry-max-time 60 --output "${save_dir}/${name}.jpg" "${url}"
exit_code=${?}
if [[ exit_code -ne 0 ]]; then
    report_error "Cannot download the picture" "Error ${exit_code}"
    exit "${exit_code}"
fi

set_gnome_wallpaper "file://${save_dir}/${name}.jpg" "${fit}"
exit_code=${?}
if [[ exit_code -ne 0 ]]; then
    report_error "Failed to set the wallpaper" "Error ${exit_code}"
    exit "${exit_code}"
fi

report_info "Wallpaper updated" "\"${name}\" has been downloaded and set as your desktop wallpaper"
