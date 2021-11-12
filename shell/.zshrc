ZSH_BASE=$HOME/dotfiles

export LANG=en_US.UTF-8
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

# antigen
source $ZSH_BASE/antigen/antigen.zsh

# oh-my-zsh
antigen use oh-my-zsh

# terminal
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle z
antigen bundle sudo
antigen bundle web-search

# theme
antigen theme jackharrisonsherlock/common 

# apply antigen
antigen apply

# theme colors
export COMMON_COLORS_HOST_ME=blue
export COMMON_COLORS_CURRENT_DIR=green

# default editor
export EDITOR=nvim

# needs to go after antigen
source ~/.aliases

# Mac: run gpg-agent
if [[ `uname` == "Darwin" ]]; then
  gpgconf --launch gpg-agent
  export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
  export GPG_TTY=$(tty)
fi
