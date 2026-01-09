#
# My Arch bashrc.
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# use vi bindings for terminals
set -o vi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# my aliases
alias ls='ls --color=auto'
alias la='ls -A'
alias lh='ls -hl'

alias grep='grep --color=auto'
alias pacman='pacman --color=auto'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# my default PS1
PS1='\[\e[01;35m\]\u@\h\[\e[m\]\n\[\e[01;34m\]\w\[\e[m\] \$ '

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=normal -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# runs before each prompt
function prompt_command() {
    # NOTE: don't run any commands before this
    local exit_code=$?

    # get the git branch
    local the_branch;
    # NOTE: for some reason, declaring and setting a local variable in the same statement doesn't save the exit code in `$?`,
    # so I just declare the variable and then set it later to get around this.
    the_branch=`git branch --no-color --show-current 2>&1`
    local git_return_code=$?
    if [[ $git_return_code -eq 0 ]]; then
        PS1_GIT_BRANCH="${the_branch}"
    else
        PS1_GIT_BRANCH=""
    fi

    if [[ $exit_code -eq 0 ]]; then
        # normal username
        PS1="\[\e[01;35m\]\u@\h\[\e[m\] \e[01;33m\][${PS1_GIT_BRANCH}]\[\e[m\]\n\[\e[01;34m\]\w\[\e[m\] \$ "
    else
        # last command gave an error, show red username
        PS1="\[\e[01;31m\]\u@\h\[\e[m\] \e[01;33m\][${PS1_GIT_BRANCH}]\[\e[m\]\n\[\e[01;34m\]\w\[\e[m\] \$ "
    fi
    # immediately write to history file
    history -a
}
PROMPT_COMMAND=prompt_command

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
