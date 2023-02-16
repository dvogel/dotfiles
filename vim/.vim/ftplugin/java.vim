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

" Remaps C-n from the 'complete' sources to 'completefunc'. This is because
inoremap <buffer> <C-S-N> <C-x><C-u>
setlocal completefunc=lsc#complete#complete

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



" TODO: Replace this with vim-cpid once it is more than a prototype.


import "javacp.vim"

function! DetermineClasspathMaven(bang)
    let l:pomPath = ""
    if expand("%:p") =~ '.*/pom.xml$'
        let l:pomPath = expand("%:p")
    elseif expand("%:p") =~ '.*/.*[.]java'
        let l:pomPath = s:javacp.FindPomXml(expand("%:p"))
    endif

    if l:pomPath == ""
        echomsg "No pom.xml file found."
        return
    endif

    if a:bang
        call s:javacp.RegenerateClasspathMaven(l:pomPath)
    else
        call s:javacp.GenerateClasspathMaven(l:pomPath)
    endif
endfunction

command! CheckForMissingImports :call javacp.CheckBuffer()
nmap <S-F11> <ScriptCmd>:call s:javacp.CheckBuffer()<CR>
command! DetermineClasspathMaven :call DetermineClasspathMaven(<bang>0)
command! ReindexClasspath :call javacp.ReindexClasspath()
command! ReindexProject :call javacp.ReindexProject()
command! FixMissingImports :call javacp.FixMissingImports()
command! PrintPomAttrs :call pomutil#PrintPomAttrs(b:pomXmlPath)
command! CpidReconnect :call javacp.ConnectToCpid()

augroup CpidJavaTemp
	autocmd!
	autocmd BufWrite *.java CheckForMissingImports
    " autocmd CursorMoved,CursorMovedI,TextChangedI *.java :call s:javacp.RecordCursorMovement()
    autocmd InsertLeave *.java :call s:javacp.UpdateBufferShadow()
    autocmd TextChanged *.java :call s:javacp.UpdateBufferShadow()
    autocmd QuickFixCmdPost *.java :call s:javacp.UpdateBufferShadow()
augroup END

function! JavaStatusLineExpr()
    return s:javacp.StatusLineExpr()
endfunction

setlocal statusline=%-f%=%{%JavaStatusLineExpr()%}%l,%c\ %p%%\ 
highlight CpidStatus guifg=drew_orange  guibg=drew_skyblue
nmap <buffer> <leader>fix <scriptcmd> :call javacp.FixMissingImports()<CR>
nmap <buffer> <leader>imp <scriptcmd> :call javacp.ShowMissingImports()<CR>:lopen<CR>

