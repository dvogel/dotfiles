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

function set_konsole_tab_title () {
    qdbus org.kde.konsole $KONSOLE_DBUS_SESSION setTitle 1 "$1"
}

function set_term_tab_title () {
    in_konsole || echo -en "\033]1;$1\a"
    in_konsole && set_konsole_tab_title "$1"
}

function set_term_window_title () {
    in_konsole || echo -en "\033]2;$1\a"
    in_konsole && set_konsole_tab_title "$1"
}

function __virtualenv_name () {
    [[ -n "$VIRTUAL_ENV" ]] && echo "($(basename "$VIRTUAL_ENV"))"
}

function within_line_boundary {
  if [[ -z "$1" ]]; then
    echo "USAGE: within_line_boundary <line boundary text>" >&2
    echo "Expects lines to process on stdin." >&2
  else
    awk -v output=-1 "/$1/ { output = output * -1 } { if (output > 0) { print \$0 } }"
  fi
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

function in_konsole () {
    [[ -n $KONSOLE_DBUS_SESSION ]]
}

function first_existing () {
    while [[ "$#" -gt 0 ]]; do
        p=$1
        shift
        if [[ -e "$p" ]]; then
            echo "$p"
            return 0
        fi
    done
    return 1
}

function findfiles () {
    [[ "$#" -eq 1 ]] || echo "You must specify a word to search for."
    [[ "$#" -eq 1 ]] && (
        on_linux && find . -xdev -iname "*${1}*"
        on_macos && find . -xdev -iname "*${1}*"
    )
}

function set_term_title_for_pwd () {
  local newtitle="BASH"
  for e in "${TERM_TITLE_BASE_DIRS[@]}"; do
    elen="${#e}"
    pwdprefix="${PWD:0:$elen}"
	if [[ "$e" == "$PWD" ]]; then
		# Retain default value.
		continue
    elif [[ "$e" == "$pwdprefix" && -d "$pwdprefix" ]]; then
      cutpoint=$((elen + 1))
      pwdsuffix="${PWD:$cutpoint}"
      part0="${pwdsuffix%%/*}"
      partN="${pwdsuffix##*/}"
      if [[ "${part0}" == "${pwdsuffix}" ]]; then
        newtitle="${pwdsuffix}"
      elif [[ -n "${part0}" && -n "${partN}" ]]; then
        if [[ "${part0}/${partN}" == "${pwdsuffix}" ]]; then
          newtitle="${pwdsuffix}"
        else
          newtitle="${part0}//${partN}"
        fi
      else
        newtitle="${pwdsuffix}"
      fi
    fi
  done

  on_linux && set_term_window_title "$newtitle"
  on_macos && set_term_tab_title "$newtitle"
}

function cdp () {
    for entry in ${HOME}/{p,devel}/${1}*; do
      if [[ -d "$entry" ]]; then
        cd "$entry" && return
      fi
    done
}

function _view_as_html () {
    (file "$1" | grep -i html >/dev/null) || return 1
    lynx -stdin -dump < "$1" | less -S -R
    return 0
}

function _view_as_json () {
    which jq >/dev/null 2>&1 || return 1
    cat "$1" | jq '.' >/dev/null 2>&1 || return 1
    cat "$1" | jq -C '.' | less -S -R
    return 0
}

function appropriate_viewer () {
    tmp_path=`mktemp -t appropriate_viewer_`;
    cat >"$tmp_path"
    _view_as_html "$tmp_path" && return
    _view_as_json "$tmp_path" && return
    cat "$tmp_path" | less -S -R
}

function view_output_as_appropriate () {
    stdout_path=`mktemp -t appropriate_viewer_`;
    stderr_path=`mktemp -t appropriate_viewer_`;
    "$@" >"${stdout_path}" 2>"${stderr_path}"

    if [ -s "${stderr_path}" ]; then
        cat "${stdout_path}"
        ansi_color 31
        cat "${stderr_path}"
        echo "${color_rst}"
    else
        _view_as_html "${stdout_path}" && return
        _view_as_json "${stdout_path}" && return
        cat "${stdout_path}" | less -S -R
    fi
}

function venv_find_and_activate () {
    activate_script=$(ls -1 env-*/bin/activate *-env/bin/activate 2>/dev/null | head -n1)
    if [[ -n "$activate_script" && -f "$activate_script" ]]; then
        rcfile_path=$(mktemp "virtualenv_bashrc_XXXXXX")
        cat $HOME/.bashrc "$activate_script" >> "$rcfile_path"
        echo 'echo "Welcome to your virtualenv"' >> "$rcfile_path"
        echo "rm $rcfile_path" >> "$rcfile_path"
        bash --rcfile "$rcfile_path"
    else
        2>&1 echo "Could not find a virtualenv"
    fi
}

function port_listener () {
    local port="${1:?USAGE: port_listener <port>}"
    sudo netstat -l -Ainet,inet6 -n -p | grep "$port"
}

function slurp_urls () {
    echo 'for x in $(cat urls.txt); do if [[ -n "$x" ]]; then xbase="$(basename $x)"; if [[ ! -r "$xbase" ]]; then easywget "$x"; fi; fi; done'
}

function mkcd {
  mkdir -p "$1" && cd "$1" || return
}

function __git_ps1_ext () {
	# __git_ps1 should be a function provided by ~/.git-prompt.sh
	if [[ $(type -t __git_ps1) == "function" ]]; then
		local ps1_tmp
		ps1_tmp=$(__git_ps1)
		if [[ -n "${ps1_tmp}" ]]; then
			echo -n "${ps1_tmp}($(git rev-parse --short=8 HEAD 2>/dev/null))"
		fi
	fi
}

js_scripts() {
  cat package.json | jq .scripts
}

npm_scripts() {
  js_scripts
}

JAVA_DEBUG_PORT=5005
function jdebug () {
	rlwrap jdb -attach transport=dt_socket,port=$JAVA_DEBUG_PORT -sourcepath ./src/main/java:./src/test/java "$@"
}
function java-dbg () {
    java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=$JAVA_DEBUG_PORT "$@"
}

env_file_exec() {
	(
		set -o allexport
		source <(grep -v '^#' "$1")
		set +o allexport
		shift
		eval "$@"
	)
}

function jsonhead {
	local cnt=1
	while [[ -n "$1" ]]; do
		if [[ "$1" =~ -n([0-9]+) ]]; then
			cnt="${BASH_REMATCH[1]}"
		elif [[ "$1" == "-n" ]] && [[ "$2" =~ [0-9]+ ]]; then
			cnt="$2"
			shift
		elif [[ "$1" =~ [0-9]+ ]]; then
			cnt="$1"
		else
			echo 1>&2 "Unknown argument: $1"
			return 1
		fi
		shift
	done

	jq -nc "limit(${cnt}; inputs)"
}

compare_git_branches() {
    diff --side-by-side <(git log $1 | head -n 100) <(git log "$2" | head -n 100) | less -SR
}

cargo-ex() {
	echo -n -e "$(bare_ansi_color 36)"
	for _ in $(seq 3 "${COLUMNS}"); do
		echo -n "#"
	done
	echo -e "${bare_color_rst}"
    mold -run cargo --color=always "$@" |& less -RFX
}

retag_here() {
  if [[ -x ./bin/retag ]]; then
    ./bin/retag
  elif [[ -e Cargo.toml ]]; then
    rusty-tags -O TAGS vi
  else
    ctags -R -f TAGS .
  fi
}

loud-banner() {
	echo -n -e "$(bare_ansi_color 36)"
  local ln="█"
  cols="${COLUMNS:-40}"
  cols=$((cols - 1))
  for idx in $(seq 1 "$cols"); do
    ln="${ln}█"
  done
  echo
  echo "$ln"
  echo
	echo -e "${bare_color_rst}"
}

vim-dumps() {
  for dirname in dumps failed; do
    filename="${1}.dump"
    echo
    echo "### $dirname/$filename ###";
    cat "${dirname}/${filename}"
    echo
  done
}

shell_in_docker() {
  docker run --rm -it -e ROWS -e COLS --network host --entrypoint /bin/bash "$@"
}

minikube_docker() {
  (
    eval $(minikube docker-env);
    docker "$@"
  )
}

base64_convert_from_url() {
  tr '-' '+' | tr '_' '/'
}

base64_convert_to_url() {
  tr '+' '-' | tr '/' '_'
}

base64_pad() {
  local input
  read -r input

  local input_length="${#input}"

  local input_len_rem=$(($input_length % 4))
  local padding
  case "${input_len_rem}" in
    2)
      padding="=="
      ;;
    3)
      padding="="
      ;;
    *)
      padding=""
      ;;
  esac
  echo -n "${input}${padding}"
}

jwt_decode() {
  local token="$(cat)"
  echo "$token" | awk -F. '{ print $1 }' | base64_pad | base64 -d | jq .
  echo "$token" | awk -F. '{ print $2 }' | base64_pad | base64 -d | jq .
}

