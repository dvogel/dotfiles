setlocal nolist
setlocal nonumber
setlocal wrap
setlocal textwidth=0
setlocal wrapmargin=0
setlocal nospell
setlocal breakindent
setlocal expandtab
setlocal tabstop=12
setlocal shiftwidth=4
setlocal formatoptions="lM1j"
setlocal nojoinspaces

map j gj
map k gk

inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u

function! ScplIndentDialog()
	execute ':s/^\s*//'
	silent! execute ':s/^"\([^"]\+\)"\s*$/\1/'
	execute ':s/^/            /'
	" execute ":s/^\\s*[\"]\\?\\(.*\\)[\"]\\?/            \\1/"
endfunction

function! ScplToggleNote()
	let ln = getline('.')
	if ln =~# "^\\[.*\\]$"
		execute ':s/^\[\(.*\)\]$/\1/'
	else
		execute ':s/^\(.*\)$/[\1]/'
	endif
endfunction

com! IndentDialog call ScplIndentDialog()
com! ToggleNote call ScplToggleNote()

noremap Id :IndentDialog<CR>
noremap tn :ToggleNote<CR>


if has("gui")
	" setlocal guifont=Luxi\ Mono\ 14
	" setlocal guifont=Droid\ Serif\ 14
endif

let b:characters = []

let s:char_pat = '^\[\([a-zA-Z. ]\+\)\]'
let s:char_open_pat = '^\['
function! s:scanCharacters()
    let found_characters = []
	let lines = getline(1, '$')
    for ln in lines
        let match = matchstr(ln, s:char_pat)
        if match != ""
            call extend(found_characters, [trim(match, "[]")])
        endif
    endfor
    call sort(found_characters)
    let b:characters = uniq(found_characters)
endfunction

function! s:findCharacterUnderCursor()
    let ln = getline(line('.'))
    let match = matchstr(ln, s:char_pat)
    let matched_char = ""
    if match != ""
        let matched_char = trim(ln, "[] \t")
    endif
    return matched_char
endfunction

function! s:findCharacterAfter(search_char)
    let ret_next = 0
    for ch in b:characters
        if ret_next == 1
            return ch
        elseif ch == a:search_char
            let ret_next = 1
        endif
    endfor
    if ret_next == 1
        return b:characters[0]
    else
        return ""
    endif
endfunction

function! ScplCycleCharacter()
    let ln = getline(line('.'))
    let match = matchstr(ln, s:char_open_pat)
    if match == ""
        return
    endif

    if len(b:characters) == 0
        echomsg "No characters found."
        return
    endif

    let new_char = s:findCharacterAfter(s:findCharacterUnderCursor())
    if new_char == ""
        let new_char = b:characters[0]
    endif
    call setline(line('.'), "[". new_char . "]")
    call setcursorcharpos(line('.'), len(new_char) + 2)
    return ""
endfunction

augroup scpl
    autocmd!
    autocmd BufEnter *.scpl call s:scanCharacters()
augroup END

nmap <TAB> :call ScplCycleCharacter()<CR>

" The expression register is used here only to avoid leaving insert mode. The
" ScplCycleCharacter function returns an empty string after updating the line
" under the cursor. The function cannot be script-local because mappings
" execute in the buffer context.
inoremap <TAB> <C-R>=ScplCycleCharacter()<CR>


