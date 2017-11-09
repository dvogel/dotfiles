setlocal expandtab
setlocal nowrap
setlocal ruler
setlocal shiftwidth=4
setlocal tabstop=4
compiler mvn

autocmd FileType java let w:m1=matchadd('Search', '\%<120v.\%>115v', -1)
autocmd FileType java let w:m2=matchadd('Todo', '\%>120v.\+', -1)


