vim9script
syntax sync fromstart
setlocal shiftwidth=4
setlocal tabstop=4
setlocal expandtab
setlocal textwidth=110
setlocal nojoinspaces

b:wrapmode = "soft"

def InsertMarkdownTableHeaderSeparator()
	normal yyp
	execute "s/[^|]/-/g"
enddef
nmap <Leader>mdth :call InsertMarkdownTableHeaderSeparator()<CR>

command! -nargs=1 -complete=customlist,MuServicesComplete Mu :call OpenMuServicesComponent(<q-args>)
command! MDWrapToggle call MDWrapToggle()
command! MDHardWrap call MDSetHardWrap()
command! MDSoftWrap call MDSetSoftWrap()
nmap <Leader>mdw :call MDWrapToggle()<CR>

def MDSetHardWrap()
	# q = allow formatting with gq
	# n = use formatlistpat to auto-indent numbered list items
	# t = auto-wrap using textwidth
	# j = remove comment leader when joining lines, if possible
	setlocal formatoptions=qnjt
	setlocal textwidth=110
	setlocal nowrap
	b:wrapmode = "hard"
	echo "Markdown hard wrap mode"
enddef

def MDSetSoftWrap()
	# q = allow formatting with gq
	# n = use formatlistpat to auto-indent numbered list items
	# l = long lines are not broken in insert mode
	# j = remove comment leader when joining lines, if possible
	setlocal formatoptions=qnjl
	setlocal textwidth=10000
	setlocal wrap
    b:wrapmode = "soft"
	echo "Markdown soft wrap mode"
enddef

def MDWrapToggle()
	if b:wrapmode == "hard"
		MDSetSoftWrap()
	else
		MDSetHardWrap()
	endif
enddef

defcompile

