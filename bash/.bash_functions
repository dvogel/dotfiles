#!/bin/bash

function set_utf8_locale () {
    export LANG=en_US.UTF-8
    export LANGUAGE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
}

function quiet_source () {
    [[ -n "$1" ]] && [[ -s "$1" ]] && source "$1"
}

function prepend_to_path () {
    [[ -n "$1" ]] && [[ -d "$1" ]] && export PATH="${1}:${PATH}"
}

function append_to_path () {
    [[ -n "$1" ]] && [[ -d "$1" ]] && export PATH="${PATH}:${1}"
}

function set_term_tab_title () {
    echo -en "\033]1;$1\a"
}

function set_term_window_title () {
    echo -en "\033]2;$1\a"
}

function __virtualenv_name () {
    [[ -n "$VIRTUAL_ENV" ]] && echo "($(basename "$VIRTUAL_ENV"))"
}

function myip () {
    curl_bin="$(which curl)"
    if [[ -z "${curl_bin}" ]]; then
        echo "Cannot find curl"
    else
        curl -s http://ifconfig.me
    fi
}

function ansi_colors () {
    # This function echoes a bunch of color codes to the
    # terminal to demonstrate what's available.  Each
    # line is the color code of one forground color,
    # out of 17 (default + 16 escapes), followed by a
    # test use of that color on all nine background
    # colors (default + 8 escapes).

    T='gYw'   # The test text

    echo -e "\n                 40m     41m     42m     43m\
         44m     45m     46m     47m";

    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
               '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
               '  36m' '1;36m' '  37m' '1;37m'; do
      FG=${FGs// /}
      echo -en " $FGs \033[$FG  $T  "
      for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
        echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
      done
      echo;
    done
    echo
}

function on_macos () {
    [[ $OSTYPE =~ ^darwin ]]
}

function on_linux () {
    [[ $OSTYPE =~ ^linux ]]
}

function findfiles () {
    [[ "$#" -eq 1 ]] || echo "You must specify a word to search for."
    [[ "$#" -eq 1 ]] && (
        on_linux && find . -xdev -iname "*${1}*"
        on_macos && find . -xdev -iname "*${1}*"
    )
}

function set_term_title_for_pwd () {
    local e
    local elen
    local pwdprefix
    for e in "${term_title_for_pwd_whitelist[@]}"; do
        elen="${#e}"
        pwdprefix="${PWD:0:$elen}"
        if [[ "$e" == "$pwdprefix" && -d "$pwdprefix" ]]; then
            set_term_tab_title $(basename "$pwdprefix" | touppercase)
            return
        fi
    done
    set_term_tab_title $(basename "$SHELL" | touppercase)
}

function woodhouse_jobs () {
    jobsdir="/tmp/woodhouse/$1/jobs"
    for j in $(ls -1tr "$jobsdir" | tail -n5); do
        jname=$(basename "$j")
        echo "JOB: $jname -----------------------------------------------------------"
        cat "$jobsdir/$j"
        echo
    done
}

function cdp () {
    cd "$HOME/Projects/$1"*
}

