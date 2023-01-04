vim9script

export def CurrentGuiFontSize(defaultSize: number): number
    var words = split(&guifont)
    if len(words) == 0
        return defaultSize
    endif

    var size = str2nr(words[-1])
    if size == 0
        return defaultSize
    endif

    return size
enddef

def GreaterGuiFontSize(): number
    # TODO: Use a smarter default
    return CurrentGuiFontSize(12) + 1
enddef

def LesserGuiFontSize(): number
    # TODO: Use a smarter default
    return CurrentGuiFontSize(12) - 1
enddef

def UpdateGuiFontSize(newSize: number): void
    var words = slice(split(&guifont), 0, -1)
    add(words, string(newSize))
    execute "set guifont=" .. join(words, '\ ')
    echon &guifont
enddef

export def IncreaseGuiFontSize(): void
    UpdateGuiFontSize(GreaterGuiFontSize())
enddef

export def DecreaseGuiFontSize(): void
    UpdateGuiFontSize(LesserGuiFontSize())
enddef

defcompile

