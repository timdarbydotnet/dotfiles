ZSH_BASE=$HOME/dotfiles
ZPLUGINDIR=$HOME/.zsh/plugins

export LANG=en_US.UTF-8

# Not Linux: LSCOLORS
if [[ `uname` != "Linux" ]]; then
  export LSCOLORS='exfxcxdxbxegedabagacad'
  export CLICOLOR=1
fi
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

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
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# Linux: dircolors
if [[ `uname` == "Linux" ]]; then
  eval "$(dircolors -b)"
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

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
