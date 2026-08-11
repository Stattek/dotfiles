# --- MY ALIASES ---

# alias for changing directories with sk
# REQUIRES `sk` TO BE INSTALLED
function cdfzf() {
    TEMP_DIR=$(fzf)
    if [ "$TEMP_DIR" = "" ]; then
        return 1
    fi
    if [ -d "$TEMP_DIR" ]; then
        # we have a directory, so go there
        cd "$TEMP_DIR" || return 1
    else
        # removes the last token from the string to get the parent directory of the file
        cd "$(echo "$TEMP_DIR" | rev | cut -d "/" -f2- | rev)" || return 1
    fi
}
alias cdfzf='cd $(fzf | sed "s|\(.*\)/.*|\1|")'

# alias for cdfzf which is faster to type
# REQUIRE `fzf` TO BE INSTALLED
function cdsk() {
    TEMP_DIR=$(sk)
    if [ "$TEMP_DIR" = "" ]; then
        return 1
    fi
    if [ -d "$TEMP_DIR" ]; then
        # we have a directory, so go there
        cd "$TEMP_DIR" || return 1
    else
        # removes the last token from the string to get the parent directory of the file
        cd "$(echo "$TEMP_DIR" | rev | cut -d "/" -f2- | rev)" || return 1
    fi
}

# nord aliases
alias nordvpn-disconnect='nordvpn set killswitch off && nordvpn disconnect'
alias nordvpn-connect='nordvpn set killswitch on && nordvpn connect chicago'

# trims the ending of a video and saves the output
function trim-video-end() {
    if [ "$#" -ne "3" ]; then
        # improper number of arguments
        echo "Usage: trim-video-end <input_video> <output_video> <num_seconds>"
        echo "Trims last num_seconds off of the end of the input_video and saves it to the output_video location."
    else
        INPUT_VIDEO="$1"
        OUTPUT_VIDEO="$2"

        # the number of seconds that the ending watermark plays
        ENDING_WATERMARK_LENGTH="$3"

        INPUT_VIDEO_LENGTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_VIDEO")
        OUTPUT_DURATION=$(bc <<<"$INPUT_VIDEO_LENGTH"-"$3")
        ffmpeg -i "$INPUT_VIDEO" -map 0 -c copy -t "$OUTPUT_DURATION" "$OUTPUT_VIDEO"
    fi
}

# trims an ig watermark off the end of a video and saves output
function trim-ig-watermark() {
    if [ "$#" -ne "2" ]; then
        # improper number of arguments
        echo "Usage: trim-ig-watermark <input_video> <output_video>"
    else
        INPUT_VIDEO="$1"
        OUTPUT_VIDEO="$2"

        # the number of seconds that the ending watermark plays
        ENDING_WATERMARK_LENGTH="4"
        trim-video-end "$1" "$2" "$ENDING_WATERMARK_LENGTH"
    fi
}

# trims a tk watermark off the end of a video and saves output
function trim-tk-watermark() {
    if [ "$#" -ne "2" ]; then
        # improper number of arguments
        echo "Usage: trim-tk-watermark <input_video> <output_video>"
    else
        INPUT_VIDEO="$1"
        OUTPUT_VIDEO="$2"

        # the number of seconds that the ending watermark plays
        ENDING_WATERMARK_LENGTH="2.1"
        trim-video-end "$1" "$2" "$ENDING_WATERMARK_LENGTH"
    fi
}

# --- END OF MY ALIASES ---

