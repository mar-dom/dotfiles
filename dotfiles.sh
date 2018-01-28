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
    antigen_install;
    vim_install;
    ssh_install;

    # remove old stuff
    rm -rf ~/{.aliases,.bashrc,.dir_colors,.gitconfig,.tmux.conf,.tmux}
    cp $dotdir/home/aliases     ~/.aliases
    cp $dotdir/home/bashrc      ~/.bashrc
    cp $dotdir/home/dir_colors  ~/.dir_colors 
    cp $dotdir/home/gitconfig   ~/.gitconfig
    cp $dotdir/home/tmux.conf   ~/.tmux.conf
}

function antigen_install ( )
{
    echo "Antigen install..."
    rm -rf ~/.antigen ~/.zshrc
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
    cp  FILES['~/.zshrc'] ~/.zshrc
}
    
function vim_install ( )
{
    echo "Vundle install..."
    rm -rf ~/.vim ~/.vimrc
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    cp  $dotdir/home/vimrc ~/.vimrc
    vim -c 'PluginInstall' -c 'qa!'
}

function ssh_install ( )
{
    if [ -f $dotfiles/ssh-config/config ]; then
        echo "SSH install..."
        if [ -d ~/.ssh ]; then 
            mv ~/.ssh ~/.ssh.orig; 
        fi
        cp -rf $dotdir/ssh-config ~/.ssh
        chmod 0600 ~/.ssh/*.id
    else
        mkdir -p ~/.ssh
        cp $dotfiles/home/ssh_config .ssh/config
    fi
}   


function main ()
{
    declare -g hostname=`hostname` DIFF="vimdiff" dotdir="$HOME/.dotfiles"
    declare -Ag FILES

    # server files
    FILES['~/.aliases']="$dotdir/home/aliases"
    FILES['~/.bashrc']="$dotdir/home/bashrc"
    FILES['~/.dir_colors']="$dotdir/home/dir_colors"
    FILES['~/.gitconfig']="$dotdir/home/gitconfig"
    FILES['~/.zshrc']="$dotdir/home/zshrc"
    FILES['~/.vimrc']="$dotdir/home/vimrc"
    FILES['~/.tmux.conf']="$dotdir/home/tmux.conf"
    
    if [ -f $dotdir/ssh-config/config ]; then
        FILES['~/.ssh/config']="$dotdir/ssh-config/config"
    else
        FILES['~/.ssh/config']="$dotdir/home/ssh_config"
    fi

    # desktop files
    FILES['~/.Xresources']="$dotdir/home/.Xresources"
    FILES['~/.Xinitrc']="$dotdir/home/.xinitrc.$hostname"
    FILES['~/.config/i3status/config']="$dotdir/config/i3status/config.$hostname"
    FILES['~/.config/i3/config']="$dotdir/config/i3/config"
    FILES['~/.config/dunst/dunstrc']="$dotdir/config/dunst/dunstrc"
    FILES['~/.config/htop/htoprc']="$dotdir/config/htop/htoprc"
    FILES['~/.config/compton.conf']="$dotdir/config/compton.conf"
    FILES['~/.config/rofi/rofi.conf']="$dotdir/config/rofi/rofi.conf"
    FILES['~/.config/ranger/rc.conf']="$dotdir/config/ranger/rc.conf"
    FILES['~/.config/ranger/commands.py']="$dotdir/config/ranger/commands.py"
    FILES['~/.config/ranger/rifle.conf']="$dotdir/config/ranger/rifle.conf"
    FILES['~/.local/wallpaper']="$dotdir/local/wallpaper"
    FILES['~/.local/share/fonts']="$dotdir/local/fonts"

    # Gentoo files
    FILES['/etc/inittab']="$dotdir/etc/inittab.$hostname"
    FILES['/etc/sudoers']="$dotdir/etc/sudoers"
    FILES['/etc/locale.gen']="$dotdir/etc/locale.gen"
    FILES['/etc/env.d/02locale']="$dotdir/02locale"
    FILES['/etc/dispatch-conf.conf']="$dotdir/etc/dispatch-conf.conf"
    FILES['/etc/portage/postsync.d/eix']="$dotdir/etc/eix.$hostname"
    FILES['/etc/portake/make.conf,']="$dotdir/etc/make.conf.$hostname"
    FILES['/etc/portage/package.use/custom']="$dotdir/etc/custom.$hostname"
    FILES['/etc/portage/package.accept_keywords']="$dotdir/package.accept_keywords.$hostname"
    FILES['/var/lib/portage/world']="$dotdir/var/world.$hostname"

#    echo ${FILES['/etc/inittab']} = gitfile




    case $modi in
        -fi | --fullinstall )   full_install
                                ;;
        -si | --serverinstall ) server_install
                                ;;
        -fc | --fullcheck )     full_check
                                ;;
        -sc | --servercheck )   server_check
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
# Both files exist
# abolute paths to file
function check ( )
{
    $localf=$1
    $repof=$2
    if $3; then $DIFF="sudo $DIFF"; fi
    if ! cmp -s $localf $repof; then $DIFF $localf $repof; fi
}

function server_check ( )
{
    DIFF=`if [ -x "$(command -v meld)"  ]; then echo "meld -n --diff" ; else echo "vimdiff"; fi`

    # server files first,
    # if not exists => copy
    if [ -f ~/.aliases      ];  then check "~/.aliases",     "$dotdir/home/aliases" ; else cp $dotdir/home/aliases ~/.aliases;        fi
    if [ -f ~/.bashrc       ];  then check ( ~/.bashrc,      $dotdir/home/bashrc );      else cp $dotdir/home/bashrc ~/.bashrc;          fi
    if [ -f ~/.dir_colors   ];  then check ( ~/.dir_colors,  $dotdir/home/dir_colors );  else cp $dotdir/home/dir_colors ~/.dir_colors;  fi
    if [ -f ~/.gitconfig    ];  then check ( ~/.gitconfig,   $dotdir/home/gitconfig );   else cp $dotdir/home/gitconfig ~/.gitconfig;    fi
    if [ -f ~/.zshrc        ];  then check ( ~/.zshrc,       $dotdir/home/zshrc );       else antigen_install;                           fi
    if [ -f ~/.vimrc        ];  then check ( ~/.vimrc,       $dotdir/home/vimrc );       else vim_install;                               fi
    if [ -f ~/.tmux.conf    ];  then check ( ~/.tmux.conf,   $dotdir/home/tmux.conf );   else cp $dotdir/home/tmux.conf ~/.tmux.conf;    fi
    if [ -f ~/.ssh/config   ];  then
        if [ -f $dotdir/ssh-config/config ]]; then 
            check( ~/.ssh/config, $dotdir/ssh-config/config); 
        else
            check( ~/.ssh/config, $dotdir/home/ssh_config); 
        fi
    else
        ssh_install;
    fi
}

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

