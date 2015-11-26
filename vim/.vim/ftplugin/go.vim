function! GoFmtBuffer()
    execute "1,$d"
    execute "0r !gofmt %"
endfunction

command! GoNoParens :s/[()]//g
nmap <Leader>np :GoNoParens<CR>
nmap <Leader>gf :call GoFmtBuffer()<CR>

nmap <Leader>gr <Plug>(go-run)
nmap <Leader>gb <Plug>(go-build)
nmap <Leader>gt <Plug>(go-test)
nmap <Leader>gc <Plug>(go-coverage)
