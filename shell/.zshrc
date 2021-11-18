ZSH_BASE=$HOME/dotfiles
ZPLUGINDIR=$HOME/.zsh/plugins

export LANG=en_US.UTF-8
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

setopt auto_cd
setopt no_beep

if [[ ! -d $ZPLUGINDIR/zsh-autosuggestions ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZPLUGINDIR/zsh-autosuggestions
fi
if [[ ! -d $ZPLUGINDIR/zsh-history-substring-search ]]; then
  git clone https://github.com/zsh-users/zsh-history-substring-search $ZPLUGINDIR/zsh-history-substring-search
fi
if [[ ! -d $ZPLUGINDIR/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZPLUGINDIR/zsh-syntax-highlighting
fi
if [[ ! -d $ZPLUGINDIR/z ]]; then
  git clone https://github.com/rupa/z $ZPLUGINDIR/z
fi

source $ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZPLUGINDIR/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZPLUGINDIR/z/z.sh

# theme
autoload -U colors && colors
if [[ ! -d $ZPLUGINDIR/common ]]; then
  git clone https://github.com/jackharrisonsherlock/common $ZPLUGINDIR/common
fi
source $ZPLUGINDIR/common/common.zsh-theme

# theme colors
export COMMON_COLORS_HOST_ME=blue
export COMMON_COLORS_CURRENT_DIR=green

# default editor
export EDITOR=nvim

source ~/.aliases

# Mac: run gpg-agent
if [[ `uname` == "Darwin" ]]; then
  gpgconf --launch gpg-agent
  export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
  export GPG_TTY=$(tty)
fi
