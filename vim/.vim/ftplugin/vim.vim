vim9script

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent

nnoremap <S-F11> :source %<CR>

var vimFunctionsFile = expand("<sfile>:h") .. "/vim-functions.txt"
appendoption#AppendAutoCompleteFilePathIfExists(vimFunctionsFile)

def VimDiffScreendump(fileBaseName: string)
    let failFile = "src/testdir/failed/" .. fileBaseName .. "..dump"
    let goodFile = "src/testdir/dumps/" .. fileBaseName .. "..dump"
    call term_dumpdiff(goodFile, failFile)
enddef

command! -nargs=1 -buffer VimDiffScreendump call VimDiffScreendump(<q-args>)
