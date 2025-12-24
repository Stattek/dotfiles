#
# My Arch bashrc.
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -A'
alias lh='ls -hl'

alias grep='grep --color=auto'
alias pacman='pacman --color=auto'
PS1='\[\e[01;35m\]\u@\h\[\e[m\]\n\[\e[01;34m\]\w\[\e[m\] \$ '
. "$HOME/.cargo/env"

# runs before each prompt
function prompt_command() {
    # NOTE: don't run any commands before this
    local exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        # normal username
        PS1='\[\e[01;35m\]\u@\h\[\e[m\]\n\[\e[01;34m\]\w\[\e[m\] \$ '
    else
        # last command gave an error, show red username
        PS1='\[\e[01;31m\]\u@\h\[\e[m\]\n\[\e[01;34m\]\w\[\e[m\] \$ '
    fi
}
PROMPT_COMMAND=prompt_command

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

