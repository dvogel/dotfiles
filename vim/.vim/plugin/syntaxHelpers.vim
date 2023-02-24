vim9script

export def g:SyntaxTrailAt(lnum: number, col: number): string
    var stack = synstack(lnum, col)

    var trail = []
    for syn_id in stack
        var name = synIDattr(syn_id, "name")
        if name != ""
            add(trail, name)
        endif
    endfor
    return join(trail, ' -> ')
enddef

export def g:SyntaxTrailUnderCursor(): string
    return g:SyntaxTrailAt(line("."), col("."))
enddef

defcompile

