setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal smartindent
setlocal nowrap

augroup CSharpAutocmds
	autocmd!
	autocmd BufWrite *.cs :OmniSharpCodeFormat
augroup END
