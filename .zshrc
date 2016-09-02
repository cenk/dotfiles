# zsh will read commands in order from:
#
# $ZDOTDIR/.zshenv
# $ZDOTDIR/.zprofile
# $ZDOTDIR/.zshrc
# $ZDOTDIR/.zlogin
# $ZDOTDIR/.zlogout
#
# See http://zsh.sourceforge.net/Intro/intro_3.html

autoload -U select-word-style
select-word-style bash

source ~/.zplug/init.zsh
zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "zsh-users/zsh-history-substring-search"
zplug "olivierverdier/zsh-git-prompt", use:"zshrc.sh"
zplug load

export EDITOR=vim
export PAGER=less
export LESS="-i"  # ignore case

# use emacs key bindings
bindkey -e

# Better prompt
PROMPT='%B%1~%b$(git_super_status)%# '
export ZSH_THEME_GIT_PROMPT_CACHE=1

# History settings
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY

# Fix backspace and delete keys
bindkey '^?' backward-delete-char  # [Backspace] - delete backward
bindkey "\e[3~" delete-char  # [Delete] - delete forward

setopt interactivecomments  # recognize comments

# ls colors
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'

# Do not change directory without "cd" command
unsetopt AUTO_CD

# my ssh & tmux helper
function ssht() { ssh -t $1 'tmux attach -t cenk || tmux new -s cenk' }

function searchandreplace() {
    LC_ALL=C find . -path ./.git -prune -o -type f -name "*.$1" -exec sed -i '' "s/$2/$3/" {} +
}

# completion settings
autoload -U compinit bashcompinit
compinit
bashcompinit

# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

# git aliases
alias g="git st"
alias gp="git push"
alias gti=git
# ...others are in .gitconfig file

# shows listening ports
alias listening="sudo lsof -Pn -iTCP -sTCP:LISTEN"

# '[r]emove [o]rphans' - recursively remove ALL orphaned packages
alias pacman-remove-orphan="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rns \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;\$!ba;s/\n/ /g')"

# docker aliases
alias docker-remove-containers="docker ps -a | tail -n +2 | awk '{print \$1}' | xargs docker rm --force"
alias docker-remove-untagged-images="docker images | grep '<none>' | awk '{print \$3}' | xargs docker rmi"

# go aliases
alias gi="go install"
alias gr="go run *.go"
# show imported packages in go
alias go-list-imports="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"

# taskwarrior
alias t="task"
alias in='task add +in'
alias put='task add +putio'
function tc() { task $1 modify -in +$2 priority:$3 }

# nosecomplete
function _nosetests() {
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=(`nosecomplete ${cur} 2>/dev/null`)
}
complete -o nospace -F _nosetests nosetests

# press ctrl-x then e to edit current command in editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# colorize man pages
function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

zmodload zsh/terminfo
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

source ~/.zshrc_private

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function title {
  emulate -L zsh
  setopt prompt_subst

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]2;$2:q\a" # set window name
      print -Pn "\e]1;$1:q\a" # set tab name
      ;;
    screen*)
      print -Pn "\ek$1:q\e\\" # set screen hardstatus
      ;;
  esac
}

# Runs before showing the prompt
function precmd {
  emulate -L zsh
  title "%1~" "%n@%m: %~"
}

# Runs before executing the command
function preexec {
  emulate -L zsh
  setopt extended_glob

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|-*)]:gs/%/%%}
  local LINE="${2:gs/%/%%}"

  # show current dir on tab when vim is open
  if [[ $CMD == vi* ]]; then
    CMD="$CMD (%1~)"
  fi

  title '$CMD' '$LINE'
}

precmd_functions+=(precmd)
preexec_functions+=(preexec)
