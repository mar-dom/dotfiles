# ~/.bashrc: executed by bash(1) for non-login shells.

#PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then
  return
fi

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Turn off ctrl+s
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

# Color definitions (Comments refer to Solarized color)
C_DEFAULT="\[\033[0;0m\]"
C_BLACK="\[\033[0;30m\]"          # base02
C_RED="\[\033[0;31m\]"            # red
C_GREEN="\[\033[0;32m\]"          # greeni
C_YELLOW="\[\033[0;33m\]"         # yellow
C_BLUE="\[\033[0;34m\]"           # blue
C_MAGENTA="\[\033[0;35m\]"        # magenta
C_CYAN="\[\033[0;36m\]"           # cyan
C_WHITE="\[\033[0;37m\]"          # base2
C_BRBLACK="\[\033[1;30m\]"      # base03
C_BRRED="\[\033[1;31m\]"        # orange
C_BRGREEN="\[\033[1;32m\]"      # base01
C_BRYELLOW="\[\033[1;33m\]"     # base00
C_BRBLUE="\[\033[1;34m\]"       # base0
C_BRMAGENTA="\[\033[1;35m\]"    # violet
C_BRCYAN="\[\033[1;36m\]"       # base1
C_BRWHITE="\[\033[1;37m\]"      # base3

# Background colors (No bright versions, not supported :()
C_BG_BLACK="\[\033[40m\]"       # base02
C_BG_RED="\[\033[41m\]"         # red
C_BG_GREEN="\[\033[42m\]"       # green
C_BG_YELLOW="\[\033[43m\]"      # yellow
C_BG_BLUE="\[\033[44m\]"        # blue
C_BG_MAGENTA="\[\033[45m\]"     # magenta
C_BG_CYAN="\[\033[46m\]"        # cyan
C_BG_WHITE="\[\033[47m\]"   # base2

C_USERCOLOR=$C_CYAN

if [ `whoami` == "root" ]; then
    C_USERCOLOR=$C_RED
fi

PS1="$C_MAGENTA[$C_USERCOLOR\u$C_WHITE@$C_GREEN\h$C_MAGENTA]$C_WHITE:$C_BLUE\w $C_DEFAULT$ "

# show only 4 directories in the prompt
PROMPT_DIRTRIM=4 

# Setup ls colors
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

if [ -x /usr/bin/dircolors ]; then
    eval `dircolors --bourne-shell ~/.dir_colors`
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
     . /usr/share/bash-completion/bash_completion
elif [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Setup aliases
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# Run local config
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

