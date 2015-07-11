setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=0
setlocal smarttab
setlocal expandtab
setlocal nosmartindent

com! FormatJSON %!python -m json.tool
map <leader>jf <Esc>:FormatJSON<CR>
