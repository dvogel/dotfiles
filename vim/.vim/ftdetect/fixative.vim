vim9script

augroup DetectFixative
    autocmd!
    autocmd BufNewFile,BufReadPost fixative* setlocal filetype=fixative
augroup END

