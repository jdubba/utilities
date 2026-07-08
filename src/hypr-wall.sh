#!/bin/bash
#
# hypr-wall - set the hyprpaper wallpaper on one or all monitors.
#
# Why this exists:
#   hyprpaper 0.8.x moved its control IPC to hyprwire and, in the process,
#   dropped the old `preload` / `unload` / `listloaded` verbs AND broke the
#   empty-monitor broadcast form:
#
#       hyprctl hyprpaper wallpaper ",/path"   # returns exit 0, but no-ops
#
#   An empty monitor name now matches zero outputs, so it silently does
#   nothing. The only reliable way to set a wallpaper is one explicit
#   `wallpaper "<monitor>,<path>"` per output -- no preload required (the
#   wallpaper request loads and applies in a single step). This script
#   enumerates the connected outputs and does exactly that.
#
# This supersedes the old `hpa` script (preload/",path"/unload), which no
# longer works against hyprpaper 0.8.x.
#
# Note: wallpapers set over IPC are runtime state only; they are not written
# to hyprpaper.conf and revert on daemon restart.

set -euo pipefail

usage() {
    cat <<EOF
Usage: $(basename "$0") [options] <image>
       $(basename "$0") -l

Set the hyprpaper wallpaper on all connected monitors (default) or one.

Options:
  -m MONITOR   only set MONITOR (e.g. eDP-1); default is every connected output
  -f MODE      fit mode passed to hyprpaper (e.g. contain, tile, cover)
  -l           list the current active wallpapers and exit
  -h           show this help

Examples:
  $(basename "$0") ~/.config/background
  $(basename "$0") -m eDP-1 ~/pictures/pic.jpg
  $(basename "$0") -f contain ~/pictures/pic.jpg
EOF
}

main() {
    local monitor="" fit="" list_only=0

    while getopts ":m:f:lh" opt; do
        case "$opt" in
            m) monitor="$OPTARG" ;;
            f) fit="$OPTARG" ;;
            l) list_only=1 ;;
            h) usage; exit 0 ;;
            :) echo "Error: option -$OPTARG requires an argument" >&2; usage >&2; exit 2 ;;
            \?) echo "Error: unknown option -$OPTARG" >&2; usage >&2; exit 2 ;;
        esac
    done
    shift $((OPTIND - 1))

    if ! command -v hyprctl &> /dev/null; then
        echo "Error: hyprctl not found in PATH" >&2
        exit 1
    fi

    # -l just reports current state (no image argument needed).
    if [[ "$list_only" -eq 1 ]]; then
        hyprctl hyprpaper listactive
        exit 0
    fi

    if [[ $# -lt 1 ]]; then
        usage >&2
        exit 2
    fi

    # Resolve the image to an absolute, existing, readable path.
    local image="$1"
    image="${image/#\~/$HOME}"
    if ! image="$(realpath -e -- "$image" 2>/dev/null)"; then
        echo "Error: image not found: $1" >&2
        exit 1
    fi
    if [[ ! -r "$image" ]]; then
        echo "Error: image not readable: $image" >&2
        exit 1
    fi

    # Confirm the daemon is reachable in this session before we do anything.
    if ! hyprctl hyprpaper listactive &> /dev/null; then
        echo "Error: cannot reach hyprpaper (is the daemon running in this session?)" >&2
        exit 1
    fi

    # Build the list of target monitors.
    local -a monitors=()
    if [[ -n "$monitor" ]]; then
        monitors=("$monitor")
    else
        if ! command -v jq &> /dev/null; then
            echo "Error: jq is required to enumerate monitors (or pass -m MONITOR)" >&2
            exit 1
        fi
        mapfile -t monitors < <(hyprctl monitors -j | jq -r '.[].name')
    fi

    if [[ "${#monitors[@]}" -eq 0 ]]; then
        echo "Error: no monitors found" >&2
        exit 1
    fi

    # hyprpaper takes the fit mode as a "<mode>:<path>" prefix.
    local arg_path="$image"
    [[ -n "$fit" ]] && arg_path="${fit}:${image}"

    local failed=0 m out
    for m in "${monitors[@]}"; do
        if out="$(hyprctl hyprpaper wallpaper "${m},${arg_path}" 2>&1)"; then
            echo "  set ${m} -> ${image}${fit:+ (${fit})}"
        else
            echo "  FAILED ${m}: ${out:-unknown error}" >&2
            failed=1
        fi
    done

    if [[ "$failed" -ne 0 ]]; then
        echo "One or more monitors failed to update." >&2
        exit 1
    fi

    echo "Wallpaper applied to ${#monitors[@]} monitor(s)."
}

main "$@"
