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
setlocal completefunc=g:LspOmniFunc
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

def g:BuildRustStatusLine(): string
    var accum = ""
    if has_key(b:, "sign_alarm_level")
        if b:sign_alarm_level == 2
            accum ..= "%#LspSignAlarmError#[ERROR]%#StatusLine#"
        elseif b:sign_alarm_level == 1
            accum ..= "%#LspSignAlarmWarning#[WARNING]%#StatusLine#"
        endif
    endif
    return accum
enddef

def RustConvertIfLetToMatch(text: string): list<string>
    var pattern = '\v(if\s+)?(let\s+)(%(Ok|Err)[(].+[)])\s*[=]\s*(.*) [{]'
    var groups = matchlist(trim(text), pattern)
    if groups == []
        return [text]
    else
        var replacement = [
            "match " .. groups[4] .. " {",
            groups[3] .. " => {"
        ]
        echo string(replacement)
        return replacement
    endif
enddef

def OmniLensTransformParseGivenWhenThen(textObj: dict<any>): list<string>
    if match(textObj["text"], '\cgiven_.*\(_when_\)\?.*_then_') == -1
        echo "Not a given-when-then"
        return null_list
    endif

    var words = split(textObj["text"], "_")
    map(words, (idx, w) => tolower(w))
    var given = words[0]
    if given != "given"
        return null_list
    endif

    var lines = ["Given:"]
    words = words[1 : ]
    var whenIdx = match(words, "when")
    if whenIdx > 0
        extend(lines, [
            "  " .. join(words[0 : whenIdx - 1], " "),
            "When:"
        ])
        words = words[whenIdx + 1 : ]
    endif

    var thenIdx = match(words, "then")
    extend(lines, [
            "  " .. join(words[0 : thenIdx - 1], " "),
            "Then:",
            "  " .. join(words[thenIdx + 1 : ], " ")
        ])
    return lines
enddef
b:omniLensAnalyzers = [funcref(OmniLensTransformParseGivenWhenThen)]

setlocal statusline=%f\ %h%r\ %{%g:BuildRustStatusLine()%}%=%l,%c\ \ 

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
nmap <buffer> <leader>dynerr iBox<dyn Error + Send + Sync><Esc>
imap <buffer> <leader>dynerr Box<dyn Error + Send + Sync>

command! -buffer RustConvertIfLetToMatch setline('.', RustConvertIfLetToMatch(getline('.')))
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
