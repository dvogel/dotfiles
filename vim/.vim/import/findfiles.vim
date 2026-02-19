vim9script

export def FindPackageJson(): string
    var cwd = getcwd()
    var searchPrefix = expand("%:p:h")
    var origSearchPrefix = searchPrefix
    var fileSuffix = "/package.json"
    var stepCount = 0
    while !filereadable(searchPrefix .. fileSuffix)
        searchPrefix = fnamemodify(searchPrefix, ":h")
        if searchPrefix == cwd || searchPrefix == ""
            break
        endif
        stepCount += 1
        if stepCount > 100
            echoerr "Walked up too many paths while searching for package.json in " .. origSearchPrefix
        endif
    endwhile

    if filereadable(searchPrefix .. fileSuffix)
        return searchPrefix .. fileSuffix
    else
        return ""
    endif
enddef

