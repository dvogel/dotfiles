setlocal nolist
setlocal nonumber
setlocal wrap
setlocal textwidth=10000
setlocal nospell
setlocal breakindent
setlocal expandtab
setlocal tabstop=12
setlocal shiftwidth=4

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
	setlocal guifont=Luxi\ Mono\ 16
endif
