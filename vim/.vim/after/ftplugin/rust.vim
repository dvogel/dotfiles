compiler cargo
setlocal makeprg=cargo\ build\ --message-format=short\ $*

" The vim-lsc and vim-rust plugins trash completeopt so reset it to my liking:
setlocal completeopt=menuone,longest,preview

