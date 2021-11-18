ZSH_BASE=$HOME/dotfiles
ZPLUGINDIR=$HOME/.zsh/plugins

export LANG=en_US.UTF-8
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

setopt auto_cd
setopt no_beep

# clone the plugin repo, source the plugin and add it to the fpath
function plugin-load () {
  local giturl="$1"
  local plugin_name="$2"
  local plugin_init="$3"
  local plugindir="${ZPLUGINDIR:-$HOME/.zsh/plugins}/$plugin_name"

  # clone if the plugin isn't there already
  if [[ ! -d $plugindir ]]; then
    command git clone --depth 1 --recursive --shallow-submodules $giturl $plugindir
    if [[ $? -ne 0 ]]; then
      echo "plugin-load: git clone failed for: $giturl" >&2 && return 1
    fi
  fi

  # source the plugin
  source $plugindir/$plugin_init

  # modify fpath
  fpath+=$plugindir
  [[ -d $plugindir/functions ]] && fpath+=$plugindir/functions
}

# plugins
plugin-load https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions zsh-autosuggestions.zsh
plugin-load https://github.com/zsh-users/zsh-history-substring-search zsh-history-substring-search zsh-history-substring-search.zsh
plugin-load https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting zsh-syntax-highlighting.zsh
plugin-load https://github.com/rupa/z z z.sh

# theme
autoload -U colors && colors
plugin-load https://github.com/jackharrisonsherlock/common common common.zsh-theme

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
