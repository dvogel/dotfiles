filetype off
call pathogen#runtime_append_all_bundles()

filetype plugin indent on
syntax on
set synmaxcol=5000
syntax sync fromstart
colorscheme putty
colorscheme drew

" highlight Comment ctermfg=gray
" highlight Folded ctermbg=4 ctermfg=10
" highlight LineNr ctermbg=0 ctermfg=6

set paste
set tabstop=4
set shiftwidth=4
set expandtab
set linespace=5
set backspace=2
set showmatch
set mouse=n
set smartindent
set autoindent
set number
set ruler
set showmatch
set laststatus=2
set hidden
set wildmenu
set wildmode=longest:list
set title
set scrolloff=1
set wildignore=*.o,*.hi
set guioptions=PegimrLtT
set splitbelow
set splitright
set conceallevel=2

set foldclose=all
set foldcolumn=1
set foldmethod=marker

set wildignore +=*.pyc
set wildignore +=*.jpg,*.jpeg,*.bmp,*.gif,*.png,*.tiff
set wildignore +=*.o,*.out,*.exe,*.dll,*.sw?

com W w
com Q q

let g:pep8_map = '<C-F5>'

au FileType python source ~/.vim/scripts/python.vim
au FileType php call Buffer_Init_PHP()
au FileType cpp call Buffer_Init_CPP()
au FileType clojure call Buffer_Init_Clojure()
au FileType javascript setlocal expandtab
au FileType ruby setlocal shiftwidth=2 tabstop=2 expandtab nowrap
au FileType eruby setlocal shiftwidth=2 tabstop=2 expandtab nowrap
au! FileType taglist call SetTagListOptions()
au BufNewFile,BufRead templates/*.html setlocal filetype=htmldjango
au BufRead quickfix :AnsiEsc


nmap <C-h> :wincmd h<CR>
nmap <C-j> :wincmd j<CR>
nmap <C-k> :wincmd k<CR>
nmap <C-l> :wincmd l<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
map <F4> :bnext<CR>:bdelete#<CR>
map <F5> :w<CR>

map <F6> :TlistToggle<CR>
function! SetTagListOptions()
    highlight MyTagListFileName guibg=background guifg=#eeeeee gui=bold
    highlight MyTagListTitle guibg=background guifg=#5555ee gui=bold
    highlight MyTagListTagName gui=reverse
    let g:Tlist_Display_Tag_Scope=1
    let g:Tlist_Enable_Fold_Column=0
    let g:Tlist_File_Fold_Auto_Close=1
    autocmd! CursorHold * :TlistHighlightTag
endfunction


function! Buffer_Init_Clojure()
	syn sync fromstart
	set expandtab
	nmap <F9> :w<CR>:!~/devel/clj/runscript %<CR>
	imap <F9> <ESC>:w<CR>:!~/devel/clj/runscript %<CR>
	nmap <F10> :w<CR>:!~/devel/clj/runrepl<CR>
	imap <F10> <ESC>:w<CR>:!~/devel/clj/runrepl<CR>
	nmap <F11> :w<CR>:!ant<CR>
	imap <F11> <ESC>:w<CR>:!ant<CR>
endfunction

function! Buffer_Init_PHP()
	map <F9> :call Show_PHP_Help_For_Word()<CR>
	map <F10> :call Show_PHP_Declaration()<CR>
endfunction

function! Buffer_Init_CPP()
"	let f = expand("%:r") . ".o"
"	map <F9> :!make '' . f <CR>
"	map <F10> :!make<CR>
	nmap [ :cprev<CR>
	nmap ] :cnext<CR>
endfunction

function! Mosh_Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
endfunction
" :inoremap <Tab> <C-R>=Mosh_Tab_Or_Complete()<CR>

" set guifont=Bitstream\ Vera\ Sans\ Mono\ 11
set guifont=Consolas\ 13

" set viminfo='10,\"100,:20,%,n~/.viminfo
" au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" These are mapped for the plugin feraltogglecommentify.vim
nmap <C-c> <Plug>FtcTc
vmap <C-c> <Plug>FtcTc
imap <C-c> <Esc><Plug>FtcTc<CR>i


" These are related to the indent file php.vim
let PHP_autoformatcomment = 0 
let PHP_removeCRwhenUnix = 1
let PHP_BracesAtCodeLevel = 0


" These are related to cvim.vim
let g:C_AuthorName      = 'Drew Vogel'
let g:C_AuthorRef       = 'dpv'
let g:C_Email           = 'dvogel@intercarve.net'
let g:C_Company         = ''

highlight PMenu ctermbg=DarkBlue ctermfg=Gray
highlight PMenuSel ctermbg=Magenta ctermfg=Gray

let g:indent_guides_auto_colors = 1
let g:indent_guides_space_guides = 1
let g:indent_guides_enable_on_vim_startup = 1

augroup filetype
  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

autocmd BufNewFile,BufRead *.cup setf cup

" Together, these two commands hide the vertical splits but the 
" number line has a trough that still appears
set fillchars=
highlight VertSplit guibg=background guifg=background gui=none term=none cterm=none

highlight Pmenu ctermfg=7 ctermbg=0 guibg=#444444 guifg=#dddddd
highlight PmenuSbar ctermfg=7 ctermbg=7 guibg=#666666 guifg=#ffffff
highlight PmenuSel ctermfg=1 ctermbg=7 guibg=#888888 guifg=#dd0000
highlight PmenuThumb ctermbg=14 ctermbg=14 guibg=#ffff00 guifg=#00ffff

highlight Search guifg=#bbbb00 guibg=#000000 gui=bold

let python_highlight_all = 1
