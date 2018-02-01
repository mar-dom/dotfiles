#!/bin/bash
# set filetype=sh
declare -a TOOLS=( git vim vimdiff fortune tmux zsh htop rsync sudo lsb_release )
declare -g DIFF=`if [ -x "$(command -v meld)"  ]; then echo "meld -n" ; else echo "vimdiff"; fi`
declare -A SFILES DFILES GFILES
declare -a difffiles

function command_exists ( ) 
{
    command -v "$1" >/dev/null 2>&1
}

function usage ( )
{
    echo "Usage: dotfiles.sh [ --fullclean ] | [ --serverclean ] | [ -fc | --fullcheck ] | [ -sc | --servercheck ] "
}

function check_tools ( )
{
    # check if all Tools exists
    for i in ${TOOLS[*]}; do
        if ! command_exists $i; then
            echo "[Error] Please install "$i" !".
            exit -1
        fi
    done

}

function declare_vars ( )
{
    # server files
    SFILES[~/.aliases]="$dotdir/home/aliases"
    SFILES[~/.bashrc]="$dotdir/home/bashrc"
    SFILES[~/.dir_colors]="$dotdir/home/dir_colors"
    SFILES[~/.gitconfig]="$dotdir/home/gitconfig"
    SFILES[~/.zshrc]="$dotdir/home/zshrc"
    SFILES[~/.vimrc]="$dotdir/home/vimrc"
    SFILES[~/.tmux.conf]="$dotdir/home/tmux.conf"
    
    if [ -f $dotdir/ssh-config/config ]; then
        SFILES[~/.ssh/config]="$dotdir/ssh-config/config"
    else
        SFILES[~/.ssh/config]="$dotdir/home/ssh_config"
    fi

    # desktop files
    DFILES[~/.Xresources]="$dotdir/home/Xresources"
    DFILES[~/.xinitrc]="$dotdir/home/xinitrc.$hostname"
    DFILES[~/.config/i3status/config]="$dotdir/home/config/i3status/config.$hostname"
    DFILES[~/.config/i3/config]="$dotdir/home/config/i3/config"
    DFILES[~/.config/dunst/dunstrc]="$dotdir/home/config/dunst/dunstrc"
    DFILES[~/.config/htop/htoprc]="$dotdir/home/config/htop/htoprc"
    DFILES[~/.config/compton.conf]="$dotdir/home/config/compton.conf"
    DFILES[~/.config/rofi/config]="$dotdir/home/config/rofi/config"
    DFILES[~/.config/ranger/rc.conf]="$dotdir/home/config/ranger/rc.conf"
    DFILES[~/.config/ranger/commands.py]="$dotdir/home/config/ranger/commands.py"
    DFILES[~/.config/ranger/rifle.conf]="$dotdir/home/config/ranger/rifle.conf"
    DFILES[~/.local/wallpaper]="$dotdir/home/local/wallpaper"
    DFILES[~/.local/share/fonts]="$dotdir/home/local/fonts"

    # Gentoo files
    GFILES[/etc/inittab]="$dotdir/etc/inittab.$hostname"
    GFILES[/etc/locale.gen]="$dotdir/etc/locale.gen"
    GFILES[/etc/env.d/02locale]="$dotdir/etc/02locale"
    GFILES[/etc/dispatch-conf.conf]="$dotdir/etc/dispatch-conf.conf"
    GFILES[/etc/portage/postsync.d/eix]="$dotdir/etc/eix"
    GFILES[/etc/portage/make.conf]="$dotdir/etc/make.conf.$hostname"
    GFILES[/etc/portage/package.use/custom]="$dotdir/etc/custom.$hostname"
    GFILES[/etc/portage/package.accept_keywords]="$dotdir/etc/package.accept_keywords.$hostname"
    GFILES[/var/lib/portage/world]="$dotdir/var/world.$hostname"
}

# Clean Installation
function full_clean ( )
{
    echo "[+] Removing all Desktop dotfiles..."

    # remove old stuff
    rm -rf ~/{.xinitrc,.Xresources,.xsession,.config/dunst,.config/htop,.config/i3,.config/i3status,.config/ranger,.config/rofi,.config/compton.conf,.local/wallpaper,.local/share/fonts} -rf
    fc-cache -fv

    echo "[*] done!"
}

function server_clean ( )
{    
    echo "[+] Removing all Desktop dotfiles..."

    # remove old stuff
    rm -rf ~/{.aliases,.bashrc,.dir_colors,.gitconfig,.tmux.conf,.tmux,.zshrc,.vimrc,.vim, .antigen}

    echo "[?] Please manually clean your ~/.ssh directory!"
    echo "[*] done!"
}

function antigen_install ( )
{
    echo "  [+] Antigen install..."
    
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
}
    
function vim_install ( )
{
    echo "  [+] Vundle install..."
    
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    cp  $SFILES[~/.vimrc] dotdir/home/vimrc ~/.vimrc
    vim -c 'PluginInstall' -c 'qa!'
}

function ssh_install ( )
{
    echo "  [+] SSH install..."

    if [ -f $dotdir/ssh-config/config ]; then
        # syncronise dotdir directory
        rm -rf ~/.ssh
        cp -rf $dotdir/ssh-config ~/.ssh
        chmod 0600 ~/.ssh/*.id
    else
        # create default ssh-config 
        mkdir -p ~/.ssh
        cp $SFILES[~/.ssh/config] ~/.ssh/config
    fi
}

function tmux_install ( )
{
    echo "  [+] tmux install..."

    mkdir -p .tmux
    git clone https://github.com/tmux-plugins/tmux-yank ~/.tmux
}

function server_check ( )
{ 
    echo "[+] Starting Server dotfiles check..."
    
    #.zshrc .tmux/ .dir_colors .bashrc .vimrc .aliases .gitconfig .ssh/config .tmux.conf
    for item in "${!SFILES[@]}"; do
        # local files = $item
        # repo files  = ${SFILES[$item]
        #echo "[Debug] $item     ${SFILES[$item]}"
        if [ -f $item ]; then
            if ! cmp -s $item ${SFILES[$item]}; then 
                echo "  [+] File '$item' is not identical with '${SFILES[$item]}'... Staging for diff!"
                if [ "$DIFF" == "meld -n" ]; then 
                    difffiles="$difffiles --diff $item ${SFILES[$item]}"
                else
                    difffiles+=("$item ${SFILES[$item]}")
                 fi
             fi
        elif [ $item == "$HOME/.zshrc" ]; then
            # zshrc      does not exist
            antigen_install
            cp ${SFILES[$item]} $item
        elif [ $item == "$HOME/.vimrc" ]; then
            # vimrc      does not exist
            vim_install
            cp  ${SFILES[$item]} $item
            vim -c 'PluginInstall' -c 'qa!'
        elif [ $item == "$HOME/.ssh/config" ]; then
            # ssh/config does not exist
            ssh_install
        elif [ -d $item == "$HOME/.tmux.conf" ]; then
            # this only affects tmux
            #rsync -aR ${SFILES[$item]} $item > /dev/null 2>&1
            tmux_install
            cp  ${SFILES[$item]} $item
        else
            echo "  [-] '$item' does not exist"
            cp -rf ${SFILES[$item]} $item
         fi
    done
    echo "[*] done!"
}

function full_check ()
{
    server_check;

    echo "[+] Starting Desktop dotfiles check..."
    
    mkdir -p ~/.config/{i3status,i3,rofi,dunst,ranger,htop}
    mkdir -p ~/.local/share

    for item in "${!DFILES[@]}"; do
        # local files = $item
        # repo files  = ${SFILES[$item]
        #echo "[Debug] $item     ${DFILES[$item]}"
        if [ -f $item ]; then
            if ! cmp -s $item ${DFILES[$item]}; then 
                echo "  [+] File '$item' is not identical with '${DFILES[$item]}'... Staging for diff!"
                if [ "$DIFF" == "meld -n" ]; then 
                    difffiles="$difffiles --diff $item ${DFILES[$item]}"
                else
                    difffiles+=("$item ${DFILES[$item]}")
                 fi
             fi
        elif [[ $item == "$HOME/.local/share/fonts" || $item == "$HOME/.local/wallpaper" ]]; then
            rsync -a --delete "${DFILES[$item]}/" "$item/" #>/dev/null 2>&1 
        else
            echo "  [-] '$item' does not exist"
            cp -rf ${DFILES[$item]} $item
         fi
    done

    echo "[*] done!"


    echo "[+] Starting Distro dotfiles check..."

    distro=`lsb_release -i | awk '{print $3}'`
    if   [ $distro == "Gentoo" ]; then
        
        for item in "${!GFILES[@]}"; do
            if [ -f $item ]; then
                if ! cmp -s $item ${GFILES[$item]}; then 
                    echo "  [+] File '$item' is not identical with '${GFILES[$item]}'... Staging for diff!"
                    if [ "$DIFF" == "meld -n" ]; then 
                        difffiles="$difffiles --diff $item ${GFILES[$item]}"
                    else
                        difffiles+=("$item ${GFILES[$item]}")
                     fi
                 fi
            #elif [[ $item == "$HOME/.local/share/fonts" || $item == "$HOME/.local/wallpaper" ]]; then
                #rsync -a --delete "${DFILES[$item]}/" "$item/" #>/dev/null 2>&1 
            else
                echo "  [-] '$item' does not exist"
             #   cp -rf ${DFILES[$item]} $item
             fi
        done
    elif [ $distro == "Debian" ]; then
            $distro=""
    fi

    echo "[*] done!"
}

function main ()
{
    declare -g hostname=`hostname` dotdir="$HOME/.dotfiles"
    
    declare_vars;

    case $modi in
        --fullclean   )         #full_install
                                ;;
                                
        --serverclean )         #server_install
                                ;;
                                
        -fc | --fullcheck )     full_check
                                ;;
                                
        -sc | --servercheck )   server_check
                                ;;

        * )                     echo "Unknown operator"
                                exit 1
    esac

    if [ "$difffiles" != "" ]; then 
        if [ "$DIFF" == "meld -n" ]; then
            nohup $DIFF $difffiles >/dev/null 2>&1 &
        else
            for i in "${difffiles[@]}"; do
                vimdiff $i
            done
        fi
     else
        echo "[!] All files are syncronised!"
     fi

    exit 0
}
###############################################################

check_tools;

# check argv's
if [ $# -eq 1 ]; then
	modi=$1
	main
else
    usage;
    exit 1
fi
