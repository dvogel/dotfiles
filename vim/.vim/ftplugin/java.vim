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

function! GoogleJavaImport()
    let ln = getline(".")
    let fqSymbol = substitute(ln, '^\s*import\s\+\([a-zA-Z0-9.]\+\);\s*$', '\1', '')
    if ln == fqSymbol
        echoerr "No import found on line " . line(".") . "."
        return
    endif

    let cmd = "xdg-open 'https://www.google.com/search?q=javadoc+" . fqSymbol . "'"
    call system(cmd)
endfunction
command! GoogleJavaImport call GoogleJavaImport()
nmap <Leader>goog :GoogleJavaImport<CR>

augroup JavaAutocmds
    autocmd!
    autocmd BufWrite *.java :Autoformat
augroup END

nmap <C-F11> :Autoformat<CR>
nmap <F11> :LspDocumentDiagnostics<CR>

function! FixJavaImport()
    let ln = getline(".")
    " Strip leading and trailing whitespace.
    let ln = substitute(ln, '^\s\+', "", "")
    echo "msg=".ln
    let ln = substitute(ln, '\s\+$', "", "")
    let ln = substitute(ln, '^package ', "", "")
    if matchstr(ln, "^import ") != "import "
        let ln = "import " . ln
    endif

    if matchstr(ln, ";$") != ";"
        let ln = ln . ";"
    endif

    execute "s/^.*$/" . ln . "/"
endfunc
nmap <Leader>import :call FixJavaImport()<CR>


