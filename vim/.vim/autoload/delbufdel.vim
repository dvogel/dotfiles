vim9script

export def ReturnA(): string
    return "A"
enddef

export def DelicatelyDeleteBuffer(): void
    var bufcount = len(getbufinfo({'buflisted': true}))
    if bufcount == 0
        # there is no current buffer
    elseif bufcount == 1
        bdelete
    else
        execute "bnext"
        if bufnr('#') >= 0 && buflisted(bufnr('#')) == 1
            execute "bdelete" "#"
        endif
    endif
enddef

defcompile

