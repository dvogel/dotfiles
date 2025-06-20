vim9script

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent

nnoremap <S-F11> :source %<CR>

var vimFunctionsFile = expand("<sfile>:h") .. "/vim-functions.txt"
appendoption#AppendAutoCompleteFilePathIfExists(vimFunctionsFile)

function! VimDiffScreendump(fileBaseName) abort
    let l:failFile = "src/testdir/failed/" . a:fileBaseName . ".dump"
    let l:goodFile = "src/testdir/dumps/" . a:fileBaseName . ".dump"
    call term_dumpdiff(l:goodFile, l:failFile)
endfunction

command! -nargs=1 -buffer VimDiffScreendump call VimDiffScreendump(<q-args>)
