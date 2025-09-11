vim9script

b:manualDocset = "java17"
if get(b:, 'editorconfig_applied', 0) == 0
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal expandtab
endif
setlocal nowrap
setlocal ruler
setlocal textwidth=100
setlocal wildignore+=*.class
compiler maven

def GoogleJavaImport(): void
    var ln = getline(".")
    var fqSymbol = substitute(ln, '^\s*import\s\+\([a-zA-Z0-9.]\+\);\s*$', '\1', '')
    if ln == fqSymbol
        echoerr "No import found on line " .. line(".") .. "."
        return
    endif

    var cmd = "xdg-open 'https://www.google.com/search?q=javadoc+" .. fqSymbol .. "'"
    system(cmd)
enddef

command! GoogleJavaImport call GoogleJavaImport()
nmap <Leader>goog :GoogleJavaImport<CR>

# Remaps C-n from the 'complete' sources to 'completefunc'. This is because
if !has("mac")
    inoremap <buffer> <C-S-N> <C-x><C-u>
endif

augroup JavaAutocmds
    autocmd!
    autocmd BufWrite *.java :Autoformat
augroup END

nmap <C-F11> :Autoformat<CR>
nmap <F11> :LspDocumentDiagnostics<CR>

def FixJavaImport(): void
    var ln = getline(".")
    # Strip leading and trailing whitespace.
    ln = substitute(ln, '^\s\+', "", "")
    echo "msg=" .. ln
    ln = substitute(ln, '\s\+$', "", "")
    ln = substitute(ln, '^package ', "", "")
    if matchstr(ln, "^import ") != "import "
        ln = "import " .. ln
    endif

    if matchstr(ln, ";$") != ";"
        ln = ln .. ";"
    endif

    execute "s/^.*$/" .. ln .. "/"
enddef
nmap <Leader>import :call FixJavaImport()<CR>



# TODO: Replace this with vim-cpid once it is more than a prototype.


import "javacp.vim"
import "pomutil.vim"

def DetermineClasspathMaven(bang: any): void
    var pomPath = ""
    if expand("%:p") =~ '.*/pom.xml$'
        pomPath = expand("%:p")
    elseif expand("%:p") =~ '.*/.*[.]java'
        pomPath = pomutil.FindPomXml(expand("%:p"))
    endif

    if pomPath == ""
        echomsg "No pom.xml file found."
        return
    endif

    pomutil.RegenerateClasspathMaven(pomPath)
enddef

def ReplaceCursorWordInFiles(): void
    var newWord = input("Enter replacement: ", "")
    if newWord == ""
        echo "(cancelled)"
    else
        var cmd = "find . -name '*.java' -print0 | xargs -n1 -0 -- sed -i 's/\\b" .. expand("<cword>") .. "\\b/" .. newWord .. "/g'"
        echo cmd
        system(cmd)
    endif
enddef

command! JavaRenameWord :call ReplaceCursorWordInFiles()

nmap <S-F11> <ScriptCmd>:call javacp.CheckBuffer()<CR>
command! -bang DetermineClasspathMaven :call DetermineClasspathMaven(<bang>0)
command! PrintPomAttrs :call pomutil.PrintPomAttrs(b:pomXmlPath)
command! CpidBufInit :call javacp.InitializeJavaBuffer()

augroup CpidJavaTemp
	autocmd!
	autocmd BufRead *.java :call javacp.InitializeJavaBuffer()
	autocmd BufWrite *.java CheckForMissingImports
    autocmd InsertLeave *.java :call javacp.UpdateBufferShadow()
    autocmd TextChanged *.java :call javacp.UpdateBufferShadow()
    autocmd QuickFixCmdPost *.java :call javacp.UpdateBufferShadow()
augroup END

def g:JavaStatusLineExpr(): string
    return javacp.StatusLineExpr()
enddef

setlocal statusline=%-f%=%{%g:JavaStatusLineExpr()%}%l,%c\ %p%%\ 
highlight CpidStatus guifg=drew_orange  guibg=drew_skyblue
nmap <buffer> <leader>fix <scriptcmd> :call javacp.FixMissingImports()<CR>
nmap <buffer> <leader>imp <scriptcmd> :call javacp.ShowMissingImports()<CR>:lopen<CR>

defcompile

