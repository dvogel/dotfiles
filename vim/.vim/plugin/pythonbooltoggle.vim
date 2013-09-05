"if exists("g:loaded_pythonbooltoggle") || &cp
"    finish
"endif

let s:keepcpo = &cpo
set cpo&vim

function! s:TogglePythonBoolean()
    normal! eb"pyw
    echo @p
    if @p == "True"
        let @p = "False"
    elseif @p == "False"
        let @p = "True"
    else
        return
    endif
    normal! dw"pPb
endfunction
nmap <unique> <Leader>tb :call TogglePythonBoolean()<CR>

let &cpo= s:keepcpo
unlet s:keepcpo
let g:loaded_pythonbooltoggle = '1.0.0'
