import "fontsize.vim" as fontsize

if has("mac")
    " set guifont=Menlo\ Regular:h14
    set guifont=Fira\ Code:h14
else
    set guifont=Fira\ Code\ Normal\ 13
endif

command! IncreaseGuiFontSize :call fontsize.IncreaseGuiFontSize()
command! DecreaseGuiFontSize :call fontsize.DecreaseGuiFontSize()

noremap <C-S-+> <ScriptCmd>:call fontsize.IncreaseGuiFontSize()<CR>
noremap <C-S-_> <ScriptCmd>:call fontsize.DecreaseGuiFontSize()<CR>

if has("mac")
    imap <silent> <S-Help> <C-r>+
    cmap <S-Help> <C-r>+

    nmap <leader>yp "+yiw

    " For some reason on MacVim (only in the GUI) <C-n> by default
    " triggers <C-x><C-u> (for 'completefunc' based completions).
    " imap <C-n> <C-x><C-n>
endif
