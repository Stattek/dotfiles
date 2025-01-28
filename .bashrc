# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color | xterm-kitty) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# --- MY ALIASES ---

# alias for changing directories with sk
# REQUIRES `sk` TO BE INSTALLED
alias cdfzf='cd && cd $(sk | sed "s|\(.*\)/.*|\1|")'

# alias for cdfzf which is faster to type
alias cdsk='cdfzf'

# nord aliases
alias nordvpn-disconnect='nordvpn set killswitch off; nordvpn disconnect'
alias nordvpn-connect='nordvpn set killswitch on; nordvpn connect chicago'

# trims the ending of a video and saves the output
function trim-video-end() {
    if [ "$#" -ne "3" ]; then
        # improper number of arguments
        echo "Usage: trim-watermark <input_video> <output_video> <num_seconds>"
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
        trim-watermark "$1" "$2" "$ENDING_WATERMARK_LENGTH"
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
        trim-watermark "$1" "$2" "$ENDING_WATERMARK_LENGTH"
    fi
}

# --- END OF MY ALIASES ---

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
. "$HOME/.cargo/env"
