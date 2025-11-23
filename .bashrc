#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -A'
alias lh='ls -hl'

alias grep='grep --color=auto'
alias pacman='pacman --color=auto'
PS1='\[\e[32m\]\u@\h\[\e[m\]\n\[\e[34m\]\w\[\e[m\] \$ '
. "$HOME/.cargo/env"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

