vim9script

import autoload "javacp.vim"

augroup CpidJavaLoading
    autocmd!
    autocmd BufRead *.java javacp.InitializeJavaBuffer()
augroup END

