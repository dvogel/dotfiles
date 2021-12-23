if get(b:, 'editorconfig_applied', 0) == 0
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal expandtab
endif
setlocal nowrap
setlocal ruler
setlocal textwidth=100
setlocal wildignore+=*.class
compiler mvn

" augroup javaTweaks
"     autocmd FileType java let b:m1=matchadd('Search', '\%<120v.\%>115v', -1)
"     autocmd FileType java let b:m2=matchadd('Todo', '\%>120v.\+', -1)
"     autocmd FileType java ProjectRootCD
" augroup END

