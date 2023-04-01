function! GoFmtBuffer()
    execute "1,$d"
    execute "0r !gofmt %"
endfunction

" If the current line contains either = or := it will be replaced with the
" other
function! GoToggleAssignment() abort
    let l:curline = line('.')
    let l:savedpos = getcursorcharpos()
    call setcursorcharpos(l:curline, 0)
    let l:foundline = search('[:]\?=', 's', l:curline)
    if l:curline == l:foundline
        let l:curr = expand('<cWORD>')
        if l:curr == ':='
            normal cw=
        else
            normal i:
        endif
    else
        echo "No assignment on line."
    endif
    call setcursorcharpos(l:savedpos[1], l:savedpos[2])
endfunction

nnoremap <buffer> <C-,> A,<Esc>
inoremap <buffer> <C-,> <Esc>A,<Esc>
nnoremap <buffer> <silent> <C-S-e> :call GoToggleAssignment()<CR>
inoremap <buffer> <silent> <C-S-e> <Esc>:call GoToggleAssignment()<CR>i
command! GoNoParens :s/[()]//g
nmap <Leader>np :GoNoParens<CR>
nmap <Leader>gf :call GoFmtBuffer()<CR>

let g:go_fmt_command = "gofmt"

nmap <Leader>gr <Plug>(go-run)
nmap <Leader>gb <Plug>(go-build)
nmap <Leader>gt <Plug>(go-test)
nmap <Leader>gc <Plug>(go-coverage)
