vim9script

import autoload "javacp.vim"

augroup CpidJavaLoading
    autocmd!
    autocmd BufRead *.java b:pomXmlPath = javacp.FindPomXml(expand("%:p"))
augroup END

