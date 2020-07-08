syntax sync fromstart
setlocal shiftwidth=4
setlocal tabstop=4
setlocal expandtab
setlocal textwidth=110

function! InsertMarkdownTableHeaderSeparator()
	normal yyp
	execute "s/[^|]/-/g"
endfunction
nmap <Leader>mdth :call InsertMarkdownTableHeaderSeparator()<CR>

function! MDSetWidth()
	setlocal textwidth=110
	setlocal nowrap
endfunction

function! MDUnsetWidth()
	setlocal textwidth=10000
	setlocal wrap
endfunction

