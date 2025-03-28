vim9script

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent

nnoremap <S-F11> :source %<CR>

var vimFunctionsFile = expand("<sfile>:h") .. "/vim-functions.txt"
appendoption#AppendAutoCompleteFilePathIfExists(vimFunctionsFile)
