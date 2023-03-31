import "fontsize.vim" as fontsize

if has("mac")
    set guifont=Menlo\ Regular:h14
else
    set guifont=Fira\ Code\ Normal\ 15
endif

command! IncreaseGuiFontSize :call fontsize.IncreaseGuiFontSize()
command! DecreaseGuiFontSize :call fontsize.DecreaseGuiFontSize()

noremap <C-S-+> <ScriptCmd>:call fontsize.IncreaseGuiFontSize()<CR>
noremap <C-S-_> <ScriptCmd>:call fontsize.DecreaseGuiFontSize()<CR>

