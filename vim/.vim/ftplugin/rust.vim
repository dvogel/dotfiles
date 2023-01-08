vim9script

setlocal expandtab
setlocal nowrap
setlocal ruler
setlocal shiftwidth=4
setlocal tabstop=4


# Consider: ?(\zs. <bar>:call histdel('search', -1)<cr>
nmap t ?(\zs.<CR>
nmap T /)<CR>
nmap <S-F9> :make<CR>
nnoremap <buffer> <leader>fn /^\(pub \)\?fn <CR>

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

defcompile

command! CargoEdit EditCargoToml()

nmap <leader>rb viwo<Esc>i&<Esc>
nmap <leader>rB ?&<CR>dl
