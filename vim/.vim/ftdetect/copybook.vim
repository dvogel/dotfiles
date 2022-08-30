vim9script

def DetectCopybook(): void
    var savedCursor = getpos('.')

    var firstSegmentPos = searchpos('^\s\+01\s', 'c')
    if firstSegmentPos != [0, 0] 
        var firstElementryField = searchpos('^\s\+05\s', 'c')
        if firstElementryField != [0, 0]
            if firstElementryField[0] > firstSegmentPos[0]
                setlocal filetype=copybook
            endif
        endif
    endif

    setpos('.', savedCursor)
enddef

augroup CopybookDetection
    autocmd!
    autocmd BufNewFile,BufReadPost *.cpy,*.CPY,*.txt call DetectCopybook()
augroup END

