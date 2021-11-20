ZSH_BASE=$HOME/dotfiles
ZPLUGINDIR=$HOME/.zsh/plugins

export LANG=en_US.UTF-8

# Linux: LS_COLORS
if [[ `uname` == "Linux" ]]; then
  export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
else
  export LSCOLORS='ExfxcxdxBxegedabagacad'
  export CLICOLOR=1
fi

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
export COMMON_COLORS_CURRENT_DIR=blue
common_current_dir() {
  echo -n "%{$fg_bold[$COMMON_COLORS_CURRENT_DIR]%}%c%{$reset_color%} "
}

PROMPT='$(common_host)$(common_current_dir)$(common_bg_jobs)$(common_git_status)$(common_return_status)'
unset RPROMPT

# default editor
export EDITOR=nvim

source ~/.aliases

# Mac: run gpg-agent
if [[ `uname` == "Darwin" ]]; then
  gpgconf --launch gpg-agent
  export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
  export GPG_TTY=$(tty)
fi
