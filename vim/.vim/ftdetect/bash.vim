vim9script

def DetectBashScript(): void
    if match(getline(1), '#!.*bash.*') == 0
        setlocal filetype=bash
    endif
enddef

augroup DetectBash
    autocmd!
    autocmd BufNewFile,BufReadPost * call DetectBashScript()
    autocmd BufNewFile,BufReadPost *.bash setlocal filetype=bash
augroup END

