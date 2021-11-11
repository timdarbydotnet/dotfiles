ZSH_BASE=$HOME/dotfiles

# antigen
source $ZSH_BASE/antigen/antigen.zsh

# oh-my-zsh
antigen use oh-my-zsh

# Terminal stuff
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle z

# Set the theme
antigen theme minimal 

# And lastly, apply the Antigen stuff
antigen apply

# Default editor
export EDITOR=nvim

# Needs to go after antigen
#source ~/.aliases 