# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LANG="en_US.utf8"

source ~/.bash_unicode
source ~/.bash_colors
source ~/.bash_functions
quiet_source ~/.bash_functions.local

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

# This is a work-around for gnome-terminal advertising itself as xterm
if [[ "$TERM" == "xterm" ]]; then
    case "$COLORTERM" in
        gnome-terminal|konsole|xfce4-terminal|mate-terminal)
            export TERM=xterm-color
    esac
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    screen-256color) color_prompt=yes;;
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
    xterm-kitty) color_prompt=yes;;
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

__rails_env () {
    if [ -z "$RAILS_ENV" ]; then
        echo -n ""
    else
        echo -n " (rails:${RAILS_ENV})"
    fi
}

if on_macos; then
__cgroup_slice() {
  return
}
else
__cgroup_slice() {
    read -r shell_cgroup < /proc/self/cgroup
    if [[ -z "$shell_cgroup" ]]; then
        return
    fi
    local nosuffix_cgroup="${shell_cgroup%.slice*}"
    if [[ ${#nosuffix_cgroup} -eq ${#shell_cgroup} ]]; then
      return
    fi
    local slice_name="${nosuffix_cgroup##*/}"
    echo -n " slice:${slice_name}"
}
fi

if [[ "$color_prompt" = yes ]]; then
    PS1="╰──$(ansi_color 32)\u$(ansi_bold_color 31)@$(ansi_color 32)\h$(ansi_bold_color 31):$(ansi_bold_color 34)\w${color_rst}$(ansi_color 35)\$(__cgroup_slice)${color_rst}\$(__git_ps1_ext)$(ansi_bold_color 31)${PS1_EXTRA}>${color_rst} "
else
    PS1="╰──$\u@\h:\w\$(__git_ps1)${PS1_EXTRA}\$ "
fi
unset color_prompt force_color_prompt

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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

on_macos && set_utf8_locale

export LESS="-S -R"
export MAKEFLAGS="-j12 -l5"
export ANDROID_HOME=~/Library/Android/sdk
export JQ_COLORS="2;31:0;32:0;32:0;36:2;31:0;37:0;37"

# Turn off dotnet core telemetry because SSL version conflicts cause a
# segfault on debian. Consider removing after this is fixed (presumable in
# debian 'buster').
export DOTNET_CLI_TELEMETRY_OPTOUT=1

declare -a PATH_DIRS
PATH_DIRS=(
            "${HOME}/opt/bats/bin"
            "${HOME}/opt/dashing/bin"
            "${HOME}/opt/dart/dart-sdk/bin"
            "${HOME}/opt/firefox"
            "${HOME}/opt/gotools/bin"
            "${HOME}/opt/just"
            "${HOME}/.local/bin"
            "${HOME}/.rvm/bin"
            "${HOME}/.rbenv/bin"
            "${HOME}/.tfenv/bin"
            "${HOME}/opt/tfenv/bin"
            "${HOME}/Library/Android/sdk/tools"
            "${HOME}/Library/Android/sdk/platform-tools"
            "${HOME}/opt/crgrep/bin"
            "${HOME}/opt/google-cloud-sdk/bin"
            "${HOME}/opt/vim/bin"
            "${HOME}/opt/git-secrets/bin"
            "${HOME}/opt/glow/bin"
            "${HOME}/opt/maven/bin"
            "${HOME}/opt/kafka/bin"
            "${HOME}/opt/visualvm/bin"
            "${HOME}/opt/LibreSprite/bin"
            "${HOME}/go/bin"
            "/usr/local/git/bin"
            "/usr/local/node/bin"
            "/usr/local/bin"
            "${HOME}/opt/bin"
            "${HOME}/bin")

for d in "${PATH_DIRS[@]}"; do
    prepend_to_path "${d}"
done

if [[ -n "${GOROOT}" && -e "${GOROOT}/bin" ]]; then
    prepend_to_path "${GOROOT}/bin"
fi

quiet_source "${HOME}/.git-completion.bash"
quiet_source "${HOME}/.git-prompt.sh"
quiet_source "${HOME}/.rvm/scripts/rvm" # This loads RVM into a shell session.

(which rbenv >/dev/null 2>&1) && eval "$(rbenv init -)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases.local ]; then
    . ~/.bash_aliases.local
fi

function gut () {
    echo $1
    echo $2
    echo $3
    echo $(($3 - $2))
    echo "cat $1 | tail -c+${2} | head -c$(($3 - $2))"
    cat $1 | tail -c+${2} | head -c$(($3 - $2))
}
export -f gut

[[ -e "$(which vi)" ]] && export EDITOR=vi
[[ -e "$(which vim)" ]] && export EDITOR=vim

export -a term_title_base_dirs
TERM_TITLE_BASE_DIRS=( "$HOME"/p "$HOME"/Projects "$HOME"/devel )
set_term_title_for_pwd
PROMPT_COMMAND="set_term_title_for_pwd"

[[ -e "$HOME/.cargo/bin" ]] && prepend_to_path "$HOME/.cargo/bin"

if [[ -t 1 ]]; then
    PROMPT_COMMAND=set_term_title_for_pwd
fi

quiet_source "${HOME}/.bashrc.local"

for aws_completer_path in "${HOME}/.local/bin/aws_completer"; do
  if [[ -f "$aws_completer_path" ]]; then
    complete -C "$aws_completer_path" aws
    complete -C "$aws_completer_path" awsv2
  fi
done

quiet_source "/usr/share/doc/fzf/examples/key-bindings.bash"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ -e /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
