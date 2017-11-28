# vim:set ft=zsh

source ~/.dotfiles/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh
HIST_STAMPS="yyyy-mm-dd"

#Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle git
antigen bundle chucknorris
antigen bundle encode64
antigen bundle catimg
antigen bundle docker
antigen bundle github
antigen bundle jsontools
antigen bundle python
antigen bundle pep8
antigen bundle pip
antigen bundle sudo
antigen bundle svn
antigen bundle systemd
antigen bundle urltools
antigen bundle z

# Syntax stuff
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# Load the theme.
antigen theme agnoster

# Apply settings
antigen apply

# Turn off ctrl+s
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

# Keybindings
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line       # End
bindkey -s '^[[1;5A' 'cd ..\n' # Ctrl + ↑
bindkey -s '^[[1;5B' 'cd -\n'  # Ctrl + ↓

# Setup ls colors
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

if [ -x /usr/bin/dircolors ]; then
    eval `dircolors --bourne-shell ~/.dir_colors`
fi

# Load aliases
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# Run local config
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

