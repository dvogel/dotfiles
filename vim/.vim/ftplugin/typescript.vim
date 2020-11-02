setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=110
setlocal expandtab
setlocal smarttab
setlocal nosmartindent
setlocal nowrap

augroup TypescriptAutocmds
	autocmd!
	autocmd BufWrite *.ts :Autoformat
augroup END
