vim9script

export def FindPackageJson(): string
    var cwd = getcwd()
    var searchPrefix = expand("%:p:h")
    var fileSuffix = "/package.json"
    while !filereadable(searchPrefix .. fileSuffix)
        searchPrefix = fnamemodify(searchPrefix, ":h")
        if searchPrefix == cwd || searchPrefix == ""
            break
        endif
    endwhile

    if filereadable(searchPrefix .. fileSuffix)
        return searchPrefix .. fileSuffix
    else
        return ""
    endif
enddef

