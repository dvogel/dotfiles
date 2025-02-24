setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent

nnoremap <S-F11> :source %<CR>

let s:completeOpts = ".,w,b,u,t,i"
let s:vimFunctionsFile = expand("<sfile>:h") .. "/vim-functions.txt"
if filereadable(s:vimFunctionsFile)
    let s:completeOpts ..= ",k" .. s:vimFunctionsFile
endif
execute "setlocal complete=" .. s:completeOpts
