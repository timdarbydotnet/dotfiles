ZSH_BASE=$HOME/dotfiles
ZPLUGINDIR=$HOME/.zsh/plugins

export LANG=en_US.UTF-8

# history
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
setopt hist_verify
setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# terminal
setopt auto_cd
setopt no_beep
setopt interactive_comments
setopt prompt_subst
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
setopt pushd_silent
setopt long_list_jobs

# completion
autoload -U compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ''
# case-insensitive, partial-word, and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# clone the plugin repo, source the plugin and add it to the fpath
function plugin-load () {
  local plugin_path="$1"
  local plugin_init="$2"
  local giturl="https://github.com/$plugin_path"
  local plugin_name=${plugin_path##*/}
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
plugin-load zsh-users/zsh-autosuggestions zsh-autosuggestions.zsh
plugin-load zsh-users/zsh-history-substring-search zsh-history-substring-search.zsh
plugin-load zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting.zsh
plugin-load rupa/z z.sh

# theme
autoload -U colors && colors
plugin-load jackharrisonsherlock/common common.zsh-theme

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
