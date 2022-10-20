setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=0
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
" map <F9> <ESC>:w<CR>:!python %<CR>
map <F10> <ESC>:w<CR>:!ddd --pydb %<CR>
vmap <C-e><C-c> :s/^/#/<CR>
vmap <C-e><C-u> :s/^#\+//<CR>
nnoremap <F8> oimport ipdb; ipdb.set_trace()<Esc>==

