syntax sync fromstart
setlocal shiftwidth=4
setlocal tabstop=4
setlocal expandtab
setlocal textwidth=110
setlocal nojoinspaces

let b:wrapmode = "soft"

function! InsertMarkdownTableHeaderSeparator()
	normal yyp
	execute "s/[^|]/-/g"
endfunction
nmap <Leader>mdth :call InsertMarkdownTableHeaderSeparator()<CR>

command! -nargs=1 -complete=customlist,MuServicesComplete Mu :call OpenMuServicesComponent(<q-args>)
command! MDWrapToggle call MDWrapToggle()<CR>
command! MDHardWrap call MDSetHardWrap()<CR>
command! MDSoftWrap call MDSetSoftWrap()<CR>
nmap <Leader>mdw :call MDWrapToggle()<CR>

function! MDSetHardWrap()
	" q = allow formatting with gq
	" n = use formatlistpat to auto-indent numbered list items
	" t = auto-wrap using textwidth
	" j = remove comment leader when joining lines, if possible
	setlocal formatoptions="qnjt"
	setlocal textwidth=110
	setlocal nowrap
	let b:wrapmode = "hard"
	echo "Markdown hard wrap mode"
endfunction

function! MDSetSoftWrap()
	" q = allow formatting with gq
	" n = use formatlistpat to auto-indent numbered list items
	" l = long lines are not broken in insert mode
	" j = remove comment leader when joining lines, if possible
	setlocal formatoptions="qnjl"
	setlocal textwidth=10000
	setlocal wrap
	let b:wrapmode = "soft"
	echo "Markdown soft wrap mode"
endfunction

function! MDWrapToggle()
	if b:wrapmode == "hard"
		call MDSetSoftWrap()
	else
		call MDSetHardWrap()
	endif
endfunction

