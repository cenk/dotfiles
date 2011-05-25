# update pacman mirror list with 5 fastest mirrors and sort them based on rating
alias reflector='sudo mv /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist && sudo reflector -l 5 --sort rate --save /etc/pacman.d/mirrorlist'

# remove packages from system which are no longer in sync database
alias orphans='pacman -Qqdt | xargs -p sudo pacman -Rsn --noconfirm'

# system upgrade
alias sysupgrade='yaourt -Syu'

alias pacman='pacman-color'
alias more='less'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -c -h'
alias ping='ping -c 1'
alias ..='cd ..'

# ls
alias ls='ls -FG'
alias l='ls'
alias lr='ls -R'                    # recursive ls
alias ll='ls -lh'
alias la='ll -a'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'