vim9script

augroup DetectFixative
    autocmd!
    autocmd BufNewFile,BufReadPost [Fixative Buffer] setlocal filetype=fixative
augroup END

