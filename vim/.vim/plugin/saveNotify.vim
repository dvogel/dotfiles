vim9script

# Requires vim9+ and netcat. Meant to be used with a script the one below.
# The script must be open before a file is opened or re-opened. For best
# results, use with vim-projectroot, which will prevent the socket search from
# unwinding the path past the project root dir.
#   https://github.com/dbakker/vim-projectroot
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#!/usr/bin/env bash
#
# sockname="${1:-buildsock}"
#
# trap 'rm -f $sockname' EXIT
# mkfifo "$sockname"
#
# netcat -k -l -U -u "$sockname" \
#   | \
#   while true; do
#     read -r ln
#     if [[ $(readlink -f "$ln") = $(readlink -f "$0") ]]; then
#       echo "Restarting $0"
#       rm "$sockname"
#       exec "$0"
#     elif [[ $ln =~ [.](html|css|scss|js|jsx)$ ]]; then
#       make
#     fi
#   done

var sockName = "buildsock"
if exists("g:saveNotifySockName")
    sockName = g:saveNotifySockName
endif

def TestNotifySockPath(path: string): bool
    if filewritable(path)
        b:saveNotifySockPath = path
        return v:true
    else
        return v:false
    endif
enddef

def FindNotifySock(): void
    if exists("b:saveNotifySockPath")
        if filewritable(b:saveNotifySockPath)
            return
        else
            b:saveNotifySockPath = ""
        endif
    endif

    var stopRoot = "/"
    if exists("*ProjectRootGet")
        var projectRoot = g:ProjectRootGet()
        if projectRoot != ""
            stopRoot = projectRoot
        endif
    endif

    var searchPrefix = expand("%:p:h")
    while TestNotifySockPath(searchPrefix .. "/" .. sockName) == v:false
        searchPrefix = fnamemodify(searchPrefix, ":h")
        if searchPrefix == stopRoot || searchPrefix == ""
            break
        endif
    endwhile
enddef

def NotifyOfSave(): void
    if exists("b:saveNotifySockPath") && filewritable(b:saveNotifySockPath)
        system("echo \"" .. expand("%") .. "\" | nc -U -u -N -w0 \"" .. b:saveNotifySockPath .. "\"")
    endif
enddef

augroup saveNotify
    autocmd!
    autocmd! BufNewFile,BufRead * FindNotifySock()
    autocmd! BufWritePost * NotifyOfSave()
augroup END

defcompile
