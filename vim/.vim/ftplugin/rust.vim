vim9script

setlocal expandtab
setlocal nowrap
setlocal ruler
setlocal shiftwidth=4
setlocal tabstop=4

compiler cargo

# The vim-lsc and vim-rust plugins trash completeopt so reset it to my liking:
setlocal completeopt=menuone,popup

# Consider: ?(\zs. <bar>:call histdel('search', -1)<cr>
nmap t ?(\zs.<CR>
nmap T /)<CR>
nmap <S-F9> :make<CR>
nmap <buffer> <F7> :make build<CR>
nmap <buffer> <C-F7> :make clippy<CR>
nnoremap <buffer> <leader>fn /^\(pub \)\?fn <CR>

# Remaps C-S-n from the 'complete' sources to 'completefunc'. This is because
# inoremap <buffer> <C-S-N> <C-x><C-u>
# setlocal completefunc=
# setlocal completefunc=lsc#complete#complete

b:autoformat_remove_trailing_spaces = 1

# TODO: The 'cargo metadata --no-deps' command should give us the edition for
# a package being editing in an object like:
#     { packages: { ... .edition = "...", .manifest_path = "..." } }
# And the .manifest_path member should match the Cargo.toml file findable with
# the EditCargoToml() logic.

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

def BrowseDocsForCrate(crateName: string): void
    var url = $"https://docs.rs/{crateName}/latest/"
    var openCmd = "xdg-open"
    if has("mac")
        openCmd = "open"
    endif
    system($'{openCmd} "{url}"')
enddef


omap <buffer> S :<C-U>call <SID>MarkSome()<CR>
nmap <buffer> <leader>rb viwo<Esc>i&<Esc>
nmap <buffer> <leader>rB ?&<CR>dl
nmap <buffer> <C-;> A;<Esc>
nmap <buffer> <leader>some ciwSome(<C-r>-)<Esc>
nmap <buffer> <leader>Some ciWSome(<C-r>-)<Esc>
nmap <buffer> <leader>err ciwErr(<C-r>-)<Esc>
nmap <buffer> <leader>Err ciWErr(<C-r>-)<Esc>
nmap <buffer> <leader>ok ciwOk(<C-r>-)<Esc>
nmap <buffer> <leader>Ok ciWOk(<C-r>-)<Esc>
nmap <buffer> <leader>u "uyiwciW<C-r>u

command! -buffer -nargs=1 BrowserDocsForCrate call BrowseDocsForCrate(<q-args>)

# For compatibility with cargo-quickfix
setlocal errorfile=.errors.txt

augroup RustBufferCmds
    autocmd!
    autocmd BufReadPost *.rs UseCargoWorkspaceTags
augroup END

def AutofmtCommandHook(bufnr: number): dict<any>
    return {
        "command": "rustfmt",
        "options": {},
    }
enddef
# b:autofmt_command_hook = function('AutofmtCommandHook')
unlet! b:autofmt_command_hook
