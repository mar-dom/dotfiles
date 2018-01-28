#!/bin/bash
# set filetype=sh

declare -ag TOOLS=( git vim vimdiff fortune tmux zsh htop rsync sudo )

function command_exists ( ) 
{
    command -v "$1" >/dev/null 2>&1
}

function usage ( )
{
    echo "Usage: dotfiles.sh [-fi | --fullinstall] | [-si | --serverinstall] | [-fc | --fullcheck] | [-sc | --servercheck] "
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

# Clean Installation
# Delete all local files and copy all repo files
function full_install ( )
{
    server_install

    # remove old stuff
    rm -rf ~/{.xinitrc,.Xresources,.xsession,.config/dunst,.config/htop,.config/i3,.config/i3status,.config/ranger,.config/rofi,.config/compton.conf,.local/wallpaper,.local/share/fonts} -rf

    cp $dotdir/home/Xresources          ~/.Xresources
    cp $dotdir/home/xinitrc.$hostname   ~/.xinitrc
    ln -s ~/.xinitrc                    ~/.xsession
    
    mkdir -p ~/.config
    cp $dotdir/home/config/dunst        ~/.config/dunst -rf
    cp $dotdir/home/config/htop         ~/.config/htop -rf
    cp $dotdir/home/config/i3           ~/.config/i3 -rf
    mkdir -p ~/.config/i3status
    cp $dotdir/home/config/i3status/config.$hostname \
                                        ~/.config/i3status/config
    cp $dotdir/home/config/ranger       ~/.config/ranger -rf
    cp $dotdir/home/config/rofi         ~/.config/rofi -rf
    cp $dotdir/home/config/compton.conf ~/.config/compton.conf
    
    mkdir -p ~/.local/share
    cp $dotdir/home/local/wallpaper     ~/.local/wallpaper -rf
    cp $dotdir/home/local/fonts         ~/.local/share/fonts -rf
    fc-cache -fv
}

# similiar to full_install
# but only server dot files will be copied
function server_install ( )
{    
    # remove old stuff
    rm -rf ~/{.aliases,.bashrc,.dir_colors,.gitconfig,.tmux.conf,.tmux, .zshrc, .vimrc, .vim}

    antigen_install;
    vim_install;
    ssh_install;

    for item in "${!SFILES[@]}"; do
        cp ${SFILES[$item]} $item
    done
}

function antigen_install ( )
{
    echo "Antigen install..."
    
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
}
    
function vim_install ( )
{
    echo "  [+] Vundle install..."
    
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    cp  $dotdir/home/vimrc ~/.vimrc
    vim -c 'PluginInstall' -c 'qa!'
}

function ssh_install ( )
{
    if [ -f SFILES[~/.ssh/config] ]; then
        # syncronise dotdir directory
        echo "  [+] SSH install..."
        rm -rf ~/.ssh
        cp -rf $dotdir/ssh-config ~/.ssh
        chmod 0600 ~/.ssh/*.id
    else
        # create default ssh-config 
        mkdir -p ~/.ssh
        cp SFILES[~/.ssh/config] .ssh/config
    fi
}

function server_check ( )
{ 
    echo "[*] Starting Server dotfiles check..."
    declare -g DIFF=`if [ -x "$(command -v meld)"  ]; then echo "meld -n" ; else echo "vimdiff"; fi`
    
    #.zshrc .tmux/ .dir_colors .bashrc .vimrc .aliases .gitconfig .ssh/config .tmux.conf
    for item in "${!SFILES[@]}"; do
        # local files = $item
        # repo files  = ${SFILES[$item]
        #echo "[Debug] $item     ${SFILES[$item]}"
        if [ -f $item ]; then
            if ! cmp -s $item ${SFILES[$item]}; then 
                echo "  [+] File '$item' is not identical with '${SFILES[$item]}'"
                difffiles="$difffiles --diff $item ${SFILES[$item]}"
             fi
        elif [ $item == "~/.zshrc" ]; then
            # zshrc      does not exist
            antigen_install
        elif [ $item == "~/.vimrc" ]; then
            # vimrc      does not exist
            vim_install
        elif [ $item == "~/.ssh/config" ]; then
            # ssh/config does not exist
            ssh_install
        elif [ -d $item ]; then
            # this only affects tmux
            #echo "[Debug] Direcotry '$item' is being syncronised with '${SFILES[$item]}'"
            rsync -aR ${SFILES[$item]} $item > /dev/null 2>&1
        else
            echo "  [-] '$item' does not exist"
            cp -rf ${SFILES[$item]} $item
         fi
    done
    echo "[*] done!"
}


function main ()
{
    declare -g hostname=`hostname` DIFF="vimdiff" dotdir="$HOME/.dotfiles"
    declare -Ag SFILES DFILES GFILES
    declare -a difffiles=""

    # server files
    SFILES[~/.aliases]="$dotdir/home/aliases"
    SFILES[~/.bashrc]="$dotdir/home/bashrc"
    SFILES[~/.dir_colors]="$dotdir/home/dir_colors"
    SFILES[~/.gitconfig]="$dotdir/home/gitconfig"
    SFILES[~/.zshrc]="$dotdir/home/zshrc"
    SFILES[~/.vimrc]="$dotdir/home/vimrc"
    SFILES[~/.tmux.conf]="$dotdir/home/tmux.conf"
    SFILES[~/.tmux/]="$dotdir/home/tmux/"
    
    if [ -f $dotdir/ssh-config/config ]; then
        SFILES[~/.ssh/config]="$dotdir/ssh-config/config"
    else
        SFILES[~/.ssh/config]="$dotdir/home/ssh_config"
    fi

    # desktop files
    DFILES['~/.Xresources']="$dotdir/home/.Xresources"
    DFILES['~/.Xinitrc']="$dotdir/home/.xinitrc.$hostname"
    DFILES['~/.config/i3status/config']="$dotdir/config/i3status/config.$hostname"
    DFILES['~/.config/i3/config']="$dotdir/config/i3/config"
    DFILES['~/.config/dunst/dunstrc']="$dotdir/config/dunst/dunstrc"
    DFILES['~/.config/htop/htoprc']="$dotdir/config/htop/htoprc"
    DFILES['~/.config/compton.conf']="$dotdir/config/compton.conf"
    DFILES['~/.config/rofi/rofi.conf']="$dotdir/config/rofi/rofi.conf"
    DFILES['~/.config/ranger/rc.conf']="$dotdir/config/ranger/rc.conf"
    DFILES['~/.config/ranger/commands.py']="$dotdir/config/ranger/commands.py"
    DFILES['~/.config/ranger/rifle.conf']="$dotdir/config/ranger/rifle.conf"
    DFILES['~/.local/wallpaper']="$dotdir/local/wallpaper"
    DFILES['~/.local/share/fonts']="$dotdir/local/fonts"

    # Gentoo files
    GFILES['/etc/inittab']="$dotdir/etc/inittab.$hostname"
    GFILES['/etc/sudoers']="$dotdir/etc/sudoers"
    GFILES['/etc/locale.gen']="$dotdir/etc/locale.gen"
    GFILES['/etc/env.d/02locale']="$dotdir/02locale"
    GFILES['/etc/dispatch-conf.conf']="$dotdir/etc/dispatch-conf.conf"
    GFILES['/etc/portage/postsync.d/eix']="$dotdir/etc/eix.$hostname"
    GFILES['/etc/portake/make.conf,']="$dotdir/etc/make.conf.$hostname"
    GFILES['/etc/portage/package.use/custom']="$dotdir/etc/custom.$hostname"
    GFILES['/etc/portage/package.accept_keywords']="$dotdir/package.accept_keywords.$hostname"
    GFILES['/var/lib/portage/world']="$dotdir/var/world.$hostname"


    case $modi in
        -fi | --fullinstall )   #full_install
                                ;;
                                
        -si | --serverinstall ) #server_install
                                ;;
                                
        -fc | --fullcheck )     #full_check
                                ;;
                                
        -sc | --servercheck )   server_check
                                if [ "$difffiles" != "" ]; then 
                                    nohub $DIFF $difffiles >/dev/null 2>&1 &
                                fi
                                
                                ;;
        * )                     echo "Unknown operator"
                                exit 1
    esac

    exit 0
}

check_tools;

# check argv's
if [ $# -eq 1 ]; then
	modi=$1
	main
else
    usage;
    exit 1
fi

##############################################################################

function full_check ()
{
    server_check;
    
    mkdir -p ~/.config    
    mkdir -p ~/.config/i3status
    mkdir -p ~/.local/share
    if [ -f ~/.Xresources                ];  then check( ~/.Xresources,               $dotdir/home/Xresources );                    else cp $dotdir/home/Xresources        ~/.Xresources;                   fi
    if [ -f ~/.xinitrc                   ];  then check( ~/.xinitrc,                  $dotdir/home/xinitrc.$hostname );             else cp $dotdir/home/xinitrc.$hostname ~/.xinitrc;                      fi
    if [ -f ~/.config/i3status/config    ];  then check( ~/.config/i3status/config,   $dotdir/config/i3status/config.$hostname );   else cp $dotdir/config/i3status/config.$hostname  ~/.config/i3status/;  fi
    if [ -f ~/.config/i3/config          ];  then check( ~/.config/i3/config,         $dotdir/config/i3/configc );                  else cp -rf $dotdir/config/i3          ~/.config;                       fi
    if [ -f ~/.config/dunst/dunstrc      ];  then check( ~/.config/dunst/dunstrc,     $dotdir/config/dunst/dunstrc );               else cp -rf $dotdir/config/dunst       ~/.config;                       fi
    if [ -f ~/.config/htop/htoprc        ];  then check( ~/.config/htop/htoprc,       $dotdir/config/htop/htoprc );                 else cp -rf $dotdir/config/htop        ~/.config;                       fi
    if [ -f ~/.config/ranger/rc.conf     ];  then check( ~/.config/ranger/rc.confg,   $dotdir/config/ranger/rc.conf );              else cp -rf $dotdir/config/ranger      ~/.config;                       fi
    if [ -f ~/.config/ranger/commands.py ];  then check( ~/.config/ranger/commands.py,$dotdir/config/ranger/commands.py );                                                                                  fi
    if [ -f ~/.config/ranger/rifle.conf  ];  then check( ~/.config/ranger/rifle.conf, $dotdir/config/ranger/rifle.conf );                                                                                   fi
    if [ -f ~/.config/rofi/rofi.conf     ];  then check( ~/.config/rofi/rofi.conf,    $dotdir/config/rofi/rofi.conf );              else cp -rf $dotdir/config/rofi        ~/.config;                       fi
    if [ -f ~/.config/compton.conf       ];  then check( ~/.config/compton.conf,      $dotdir/config/compton.conf );                else cp $dotdir/config/compton.conf    ~/.config;                       fi
    if [ -d ~/.local/wallpaper           ];  then rsync -av $dotdir/local/wallpaper/   ~/.local/wallpaper/;                                                                                                 fi
    if [ -f ~/.local/share/fonts         ];  then rsync -av $dotdir/local/share/fonts/ ~/.local/share/fonts/;                                                                                               fi

    distro=`lsb_release -i | awk '{print $3}'`
    if   [ $distro == "Gentoo" ]; then

            check( /var/lib/portage/world,          $dotdir/var/world.$hostname,       true ); 
            check( /etc/locale.gen,                 $dotdir/etc/locale.gen,            true ); 
            check( /etc/portake/make.conf,          $dotdir/etc/make.conf.$hostname,   true ); 
            check( /etc/inittab,                    $dotdir/etc/inittab.$hostname,     true ); 
            check( /etc//etc/dispatch-conf.conf,    $dotdir/etc/dispatch-conf.conf.$hostname, true ); 
            check( /etc/sudoers,                    $dotdir/etc/sudoers.$hostname,     true ); 
            

            if [ -f /etc/env.d/02locale ]; then 
                check( /etc/env.d/02locale, $dotdir/etc/02locale, true );
            else 
                sudo cp $dotdir/etc/02locale /etc/env.d/02locale; sudo env-update;                      
            fi

            if [ -f /etc/portage/postsync.d/eix ]; then 
                check( /etc/portage/postsync.d/eix, $dotdir/etc/eix.$hostname, true );
            else 
                sudo cp $dotdir/etc/eix.$hostname /etc/portage/postsync.d/eix;                      
            fi

            if [ -f /etc/portage/package.use/custom ]; then 
                check( /etc/portage/package.use/custom, $dotdir/etc/custom.$hostname, true );
            else 
                sudo cp $dotdir/etc/custom.$hostname /etc/portage/package.use/custom;                      
            fi

            if [ -f /etc/portage/package.accept_keywords ]; then 
                check( /etc/portage/package.accept_keywords, $dotdir/etc/package.accept_keywords.$hostname, true );
            else 
                sudo cp $dotdir/etc/package.accept_keywords.$hostname /etc/portage/package.accept_keywords;                      
            fi

    elif [ $distro == "Debian" ]; then
            $distro=""
    fi
}

