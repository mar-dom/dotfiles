# vim:set ft=zsh

PATH="$PATH:/sbin:/usr/sbin:/usr/local/sbin"

source ~/.dotfiles/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh
HIST_STAMPS="yyyy-mm-dd"

#Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundles <<EOBUNDLES
    git
    chucknorris
    encode64
    jsontools
    catimg
    python
    pep8
    pip
    sudo
    svn
    urltools
    z
EOBUNDLES

# Syntax stuff
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

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
#bindkey -s '^[[1;5A' 'cd ..\n' # Ctrl + ↑
#bindkey -s '^[[1;5B' 'cd -\n'  # Ctrl + ↓

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# Suffix aliases
alias -s tex=vim

# Global aliases
# references: http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html 
globalias() {
  if [[ $LBUFFER =~ '[A-Z0-9]+$' ]]; then #added a-z, removed first whitespace
    zle _expand_alias
    zle expand-word
  fi
  zle self-insert
}
zle -N globalias
bindkey " " globalias                 # space key to expand globalalias
bindkey "^[[Z" magic-space            # shift-tab to bypass completion
bindkey -M isearch " " magic-space    # normal space during searches

alias -g L='| less'
alias -g CFG-make='sudo vim /etc/portage/make.conf'




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
