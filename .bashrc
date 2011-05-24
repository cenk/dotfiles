# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

umask 022

export EDITOR="emacs"
export LESS="-R"

STARTCOLOR='\e[0;32m';
ENDCOLOR="\e[0m"
export PS1="$STARTCOLOR\w \$$ENDCOLOR "
