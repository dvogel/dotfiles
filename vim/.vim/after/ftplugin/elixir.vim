setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal nowrap

setlocal makeprg=mix
nnoremap <buffer> <F8> :make<CR>
nnoremap <buffer> { :cprev<CR>
nnoremap <buffer> } :cnext<CR>

