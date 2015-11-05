function! GoFmtBuffer()
    execute "1,$d"
    execute "0r !gofmt %"
endfunction

nmap <Leader>gf :call GoFmtBuffer()<CR>

