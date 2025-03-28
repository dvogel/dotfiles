vim9script

setlocal expandtab
setlocal nowrap
setlocal ruler
setlocal shiftwidth=4
setlocal tabstop=4

# setlocal omnifunc=lsc#complete#complete
# setlocal completefunc='lsc#complete#complete'

# Consider: ?(\zs. <bar>:call histdel('search', -1)<cr>
nmap t ?(\zs.<CR>
compiler cargo


# The vim-lsc and vim-rust plugins trash completeopt so reset it to my liking:
setlocal completeopt=menuone,popup

nmap T /)<CR>
nmap <S-F9> :make<CR>
nmap <buffer> <F7> :make build<CR>
nmap <buffer> <C-F7> :make clippy<CR>
nnoremap <buffer> <leader>fn /^\(pub \)\?fn <CR>

# Remaps C-S-n from the 'complete' sources to 'completefunc'. This is because
# inoremap <buffer> <C-S-N> <C-x><C-u>
setlocal completefunc=lsc#complete#complete

b:autoformat_remove_trailing_spaces = 1

def EditCargoToml(): void
    var stopRoot = expand("%:p:h")
    if exists("*ProjectRootGet")
        var projectRoot = g:ProjectRootGet()
        if projectRoot != ""
            stopRoot = projectRoot
        endif
    endif

    var searchPrefix = expand("%:p:h")
    var fileSuffix = "/Cargo.toml"
    while !filereadable(searchPrefix .. fileSuffix)
        searchPrefix = fnamemodify(searchPrefix, ":h")
        if searchPrefix == stopRoot || searchPrefix == ""
            break
        endif
    endwhile

    if filereadable(searchPrefix .. fileSuffix)
        execute ":e " .. searchPrefix .. fileSuffix
    else
        echo "No cargo file found."
    endif
enddef

def IsCargoWorkspace(path: string): bool
    var lines = readfile(path .. "/Cargo.toml", "", 1000)
    var workspaceLineNum = indexof(lines, (idx, ln) => ln == "[workspace]")
    return workspaceLineNum >= 0
enddef

def UseCargoWorkspaceTags(): void
    var projectRoot = g:ProjectRootGet()
    if projectRoot == getcwd()
        if IsCargoWorkspace(getcwd()) == v:false
            echomsg "Skipping cargo workspace tags because current directory is not a workspace"
            return
        endif
    endif

    var projectTagsPattern = projectRoot .. "/**/TAGS"
    execute "setlocal tags+=" .. projectTagsPattern
enddef

defcompile

command! CargoEdit EditCargoToml()
command! UseCargoWorkspaceTags UseCargoWorkspaceTags()

nmap <leader>rb viwo<Esc>i&<Esc>
nmap <leader>rB ?&<CR>dl
nmap <C-;> A;<Esc>
nmap <leader>some ciwSome(<C-r>-)<Esc>
nmap <leader>Some ciWSome(<C-r>-)<Esc>
nmap <leader>err ciwErr(<C-r>-)<Esc>
nmap <leader>Err ciWErr(<C-r>-)<Esc>
nmap <leader>ok ciwOk(<C-r>-)<Esc>
nmap <leader>Ok ciWOk(<C-r>-)<Esc>
nmap <leader>u "uyiwciW<C-r>u

# For compatibility with cargo-quickfix
setlocal errorfile=.errors.txt

