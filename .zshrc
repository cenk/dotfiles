# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent id_rsa id_dev
plugins=(ssh-agent git virtualenvwrapper)

export PATH=/usr/local/bin:/usr/local/sbin:${PATH}
export PATH=/usr/local/share/python:${PATH}
export PATH=$HOME/bin:${PATH}
export EDITOR=emacs

# Must be run after PATHs are set
source $ZSH/oh-my-zsh.sh


# Customize to your needs...
if [[ -f $HOME/.zshrc-local ]]
then
    source $HOME/.zshrc-local
fi

# my ssh & tmux helper
function ssht()
{
ssh -t $1 'tmux attach -t cenk || tmux new -s cenk'
}
