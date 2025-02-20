if get(b:, 'editorconfig_applied', 0) == 0
    setlocal shiftwidth=2
    setlocal tabstop=2
    setlocal expandtab
endif

setlocal autoindent

nmap <buffer> <leader>x :!chmod u+x %<CR>


function! s:ShellcheckToggle() abort
    let l:capturePattern = '.*\[\(SC[0-9]\+\)\].*'
    for msg in flatten(values(b:syntastic_private_messages))
        if get(msg, "lnum", -1) == line('.')
            let l:m = matchlist(get(msg, "text", ""), l:capturePattern)
            if l:m == []
                return
            endif

            let l:comment = "# shellcheck disable=" . l:m[1]
            execute "normal! O" . l:comment
        endif
    endfor
endfunction

command! ShellcheckToggle :call <SID>ShellcheckToggle()

" shellcheck disable=SC2086
