# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LANG="en_US.utf8"

source ~/.bash_unicode
source ~/.bash_colors
source ~/.bash_functions

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s histverify
shopt -s histreedit

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=5000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# This is a work-around for gnome-terminal advertising itself as xterm
if [ "$TERM" == "xterm" -a "$COLORTERM" == "gnome-terminal" ]; then
    export TERM=xterm-color
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    screen-256color) color_prompt=yes;;
    xterm-color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

function __rails_env () {
    if [ -z "$RAILS_ENV" ]; then
        echo ""
    else
        echo " (rails:${RAILS_ENV})"
    fi
}

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}$(ansi_color 32)\u$(ansi_bold_color 31)$(unichr 0x03b1)$(ansi_color 32)\h$(ansi_bold_color 31):$(ansi_bold_color 34)\w$(ansi_bold_color 31)$(unichr 0x2771)${color_rst} "
else
    PS1='${debian_chroot:+($debian_chroot)}$(__rails_env)\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --ignore=*.pyc'
    alias lla='/bin/ls --color=auto -lha'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

source ~/.bash_unicode
source ~/.bash_colors
source ~/.bash_functions

export LESS="-S -R"
export MAKEFLAGS="-j -l2"
export FLEX_SDK_HOME=/home/dvogel/flex_sdk_4.6.0.23201B

PATH_DIRS=$(echo "/home/dvogel/flex_sdk_4.6.0.23201B"
            echo "/home/dvogel/firefox_trunk_x86_64"
            echo "/usr/local/node/bin"
            echo "$FLEX_SDK_HOME/bin"
            echo "$HOME/bin")

for d in $PATH_DIRS
do
    if [ -n "${d}" -a -d "${d}" ]; then
        export PATH="${d}:${PATH}"
    fi
done

[[ -s "$HOME/.nvm/nvm.sh" ]] && . "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
[[ -s "$HOME/z/z.sh" ]] && . "$HOME/z/z.sh"

function gut () {
    echo $1
    echo $2
    echo $3
    echo $(($3 - $2))
    echo "cat $1 | tail -c+${2} | head -c$(($3 - $2))"
    cat $1 | tail -c+${2} | head -c$(($3 - $2))
}
export -f gut

