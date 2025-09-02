vim9script

var prevMaxAlarm = -1

def SignColumnVarsSet(): bool
    return (exists("g:sign_column_warning_signs")
        && exists("g:sign_column_error_signs"))
enddef

def MaybeHighlightSignColumn()
    if !SignColumnVarsSet()
        return
    endif

    var placed = sign_getplaced(bufname(), {'group': '*'})
    if len(placed) == 0
        echoerr "No signs in buffer."
    endif
    var maxAlarm = 0
    for sign in placed[0]['signs']
        if index(g:sign_column_error_signs, sign['name']) >= 0
            maxAlarm = max([maxAlarm, 2])
        elseif index(g:sign_column_warning_signs, sign['name']) >= 0
            maxAlarm = max([maxAlarm, 1])
        endif
    endfor

    if maxAlarm == prevMaxAlarm
        return
    endif

    b:sign_alarm_level = maxAlarm
    if maxAlarm >= 2
        # highlight SignColumn guibg=drew_red guifg=drew_ltgray
        b:has_error_signs = v:true
    else
        # highlight SignColumn guibg=drew_darkgray guifg=drew_red
        b:has_error_signs = v:false
    endif
enddef

command! HighlightSignColumn :call MaybeHighlightSignColumn()

augroup SignColumnHighlight
    autocmd!
    if SignColumnVarsSet()
        autocmd CursorMoved * call MaybeHighlightSignColumn()
    endif
augroup END
