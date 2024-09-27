set termguicolors
let g:css_colors_load = 1

let g:ackpreview = 0
let g:ackhighlight = 1
let g:ack_use_dispatch = 0

let java_highlight_functions = 1
let java_highlight_java_lang = 1
" let java_highlight_all = 0

" This loads plugins in pack/plugins/start
packloadall

" Some system-provided packs still need to be added though:
packadd bufexplorer
packadd matchit

filetype plugin indent on
syntax on
set synmaxcol=5000
syntax sync clear
syntax sync fromstart
" colorscheme putty
colorscheme drew

" highlight Comment ctermfg=gray
" highlight Folded ctermbg=4 ctermfg=10
" highlight LineNr ctermbg=0 ctermfg=6

set paste
set tabstop=4
set shiftwidth=4
set expandtab
set linespace=6
set backspace=indent,eol,start
set showmatch
set mouse=n
set smartindent
set autoindent
set number
set ruler
set modeline
set showmatch
set laststatus=2
set hidden
set wildmenu
set wildmode=longest:list
set title
set scrolloff=1
set wildcharm=<Tab>
set wildignore=*.o,*.hi
set guioptions=Pegit
set splitbelow
set splitright
set switchbuf=useopen,uselast
set conceallevel=2
set hlsearch
set switchbuf=useopen

set noerrorbells
set visualbell
set t_vb=

set foldclose=all
set foldcolumn=1
set foldmethod=marker

set wildignore +=*.pyc
set wildignore +=*.jpg,*.jpeg,*.bmp,*.gif,*.png,*.tiff
set wildignore +=*.o,*.out,*.exe,*.dll,*.sw?

set tags=./TAGS;/

if has("mac")
    " MacVim likes to complain about backup files when the file is already
    " open in another buffer.
    set nobackup
end

let g:JavaComplete_ClosingBrace = 0
let g:JavaComplete_StaticImportsAtTop = 1

let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_use_mono = 0
let g:OmniSharp_start_server = 1
let g:OmniSharp_highlighting = 0

let g:tada_todo_styles = 'unicode'
let g:tada_todo_statuses = ['planned', 'doing', 'complete']
let g:tada_todo_symbols = {'planned': ' ' , 'doing': '🛠️', 'complete': '✅' }

let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_disable_rules = []
au FileType gitcommit let b:EditorConfig_disable = 1

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:syntastic_cs_checkers = ['code_checker']
let g:syntastic_html_checkers = ['htmlhint']
let g:syntastic_java_checkers = ['javac']
let g:syntastic_java_javac_config_file_enabled = 1
" let g:loaded_syntastic_java_javac_checker = 1
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_python_checkers=['pyflakes']
let g:syntastic_ruby_checkers=['rubocop']
let g:syntastic_typescript_eslint_exe='$(npm bin)/eslint'
let g:syntastic_typescript_checkers=['eslint']
let g:syntastic_quiet_messages = { 'regex': 'parentheses after method name' }
let g:syntastic_mode_map = { "mode": "active", "passive_filetypes": ["rust", "java"] }

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

let g:formatdef_my_custom_cs = '"astyle --mode=cs --style=1tbs -N --convert-tabs --keep-one-line-blocks --indent-continuation=2 -s".&shiftwidth'
let g:formatters_cs = ['my_custom_cs']
let g:formatdef_google_java_format = '"google-java-format --assume-filename ".expand("%")." ".b:java_style_flag." -"'
let g:formatters_java = ['google_java_format']
let g:formatters_rust = ['rustfmt']
let g:formatters_go = ['donotrunthis']
let g:formatters_javascript = ['prettier']
let g:formatdef_prettier = '"./node_modules/.bin/prettier --stdin-filepath ".expand("%:p").(&textwidth ? " --print-width ".&textwidth : "")." --tab-width=".shiftwidth()'
let g:run_all_formatters_javascript = v:false

let g:cpp_function_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_attributes_highlight = 1

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 0
let g:go_highlight_extra_types = 1
let g:go_highlight_structs = 1

com! W w
com! Q q
" Paste from system clipboard (instead of primary selection)
nmap <Leader>cbp "+p
if has("gui_running")
    nmap <S-Insert> "+p
    imap <S-Insert> <C-r>+
    lmap <S-Insert> <C-r>+
    cmap <S-Insert> <C-r>+
    imap <silent>  <S-Insert>  <Esc>"+pa
endif

vmap <Leader>eve "ey:call EvalVimCode(@e)<CR>
let g:pep8_map = '<C-F5>'

au FileType python source ~/.vim/scripts/python.vim
au BufNewFile,BufRead templates/*.html setlocal filetype=htmldjango
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au BufNewFile,BufRead,BufFilePre *.scpl setlocal filetype=scpl

" Always open the quickfix window on the bottom (no vertical split)
map <C-S-?> :copen<CR>
function! OpenQuickfixIfNeeded() abort
    if len(getqflist()) > 0
        copen
    endif
endfunction
augroup qfTweaks
    autocmd FileType qf wincmd J
    autocmd QuickFixCmdPost make call OpenQuickfixIfNeeded()
augroup END

import "delbufdel.vim" as delbufdel
command! -nargs=1 BufDelMatching :call delbufdel.DeleteBuffersMatching("<args>")

nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>
nmap Ej :cnext<CR>
nmap Ek :cprev<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
map <F4> <ScriptCmd>:call delbufdel.DelicatelyDeleteBuffer()<CR>
map <F5> :w<CR>
nmap <F9> :GBufExplorer<CR>
nmap <C-S-F9> :GBufExplorerHorizontalSplit<CR>
nmap <S-F9> :GToggleBufExplorer<CR>
nmap <F10> :BufExplorer<CR>
nmap <F12> :qall!<CR>
nmap <F6> :NERDTreeToggle<CR>
nmap <C-F6> :TagbarToggle<CR>
" Depends on vim-surround from Tim Pope:
" ^S' will quote the word under the cursor with a single quote
nmap <C-S> ysiw
" Remaps C-n from the 'complete' sources to 'completefunc'
" inoremap <C-n> <C-x><C-u>
inoremap <C-S-n> <C-x><C-u>
nmap <leader>H :nohlsearch<CR>
nnoremap <C-S-E> :e %:h<Tab>

let g:rootmarkers = ['.projectroot', '.git', '.hg', '.svn', '.bzr', '_darcs', 'build.xml', 'pom.xml']

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['.projectroot', '.git', 'tags', 'TAGS', 'pom.xml']
let g:ctrlp_custom_ignore = '\v.*(build|node_modules|target).*'

" These mappings are for the dragvisuals plugin
vmap <expr> <LEFT> DVB_Drag('left')
vmap <expr> <RIGHT> DVB_Drag('right')
vmap <expr> <UP> DVB_Drag('up')
vmap <expr> <DOWN> DVB_Drag('down')
vmap <expr> D DVB_Duplicate()
" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++                                                                            

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
let g:indent_guides_enable_on_vim_startup = 0

" Global settings for vim-terraform
let g:terraform_align = 1
let g:terraform_fold_sections = 0
let g:terraform_fmt_on_save = 1

augroup filetype
  au!
  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
  au BufRead,BufNewFile *.q               set filetype=Q
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

autocmd BufNewFile,BufRead *.cup setf cup

" Together, these two commands hide the vertical splits but the 
" number line has a trough that still appears
set fillchars=
highlight VertSplit guibg=background guifg=background gui=none term=none cterm=none
highlight SignColumn guifg=background guifg=foreground gui=none term=none

let python_highlight_all = 1
let g:vim_json_syntax_conceal = 0

nnoremap <leader>sy :echo SyntaxTrailUnderCursor()<CR>

function! AckWordInProjectRoot (word)
    let l:word = empty(a:word) ? expand('<cword>') : a:word
    let l:root = ProjectRootGuess()
    echomsg "Executing ack-grep for '" . l:word . "' in '" . l:root . "'"
    call ack#Ack('grep', join([l:word, l:root], ' '))
endfunction

command! -bang -nargs=* AckRel call AckWordInProjectRoot(<q-args>)
nmap <Leader>ag :AckRel<CR>
nmap <Leader>vws :'<,'>s/[ \t]\+$//<CR>
nmap <Leader>ws :%s/[ \t]\+$//<CR>
nmap <Leader>gws :%s/[ \t]/  /<CR>
nmap <Leader>rq' :s/"/'/g<CR>
nmap <Leader>rq" :s/'/"/g<CR>

function! ReduceHTMLBufferToUrls()
  let l:txt = system('cat ' . expand('%') . '| urlextract.py')
  normal ggdG
  call append(0, split(l:txt, '\r'))
endfunction
command! -bang ReduceHTMLBufferToUrls call ReduceHTMLBufferToUrls()
nmap <Leader>urls :ReduceHTMLBufferToUrls<CR>

" Thanks Herbert Sitz!
" https://stackoverflow.com/a/4965113
function! PrePad(s,amt,...)
    if a:0 > 0
        let char = a:1
    else
        let char = ' '
    endif
    return repeat(char,a:amt - len(a:s)) . a:s
endfunction

function! CreateNewCardYamlFile(basename)
	let l:n = 0
	let l:path = ""
    while l:n < 1000
		let l:filename = a:basename . PrePad(l:n, 3, "0") . ".yaml"
		let l:path = "src/cards/" . l:filename
		if filereadable(l:path)
			echom "file already exists: " . l:path
		else
			let l:msg = "would load: " . l:path
			echom l:msg
			execute "e" l:path
			execute "0r" "template_card.yaml"
			execute "w"
			return
		endif	
		let l:n += 1
	endwhile
	echom "All " . a:basename . " filenames are already used."
endfunction
command! -nargs=1 NewCardYamlFile :call CreateNewCardYamlFile(<q-args>)
command! LoadCardYamlTemplate 0r template_card.yaml

function! YamlReplaceCurrentArrayEntry()
	normal ^
	s/-.*/- /g
	startinsert!
endfunction
nmap <Leader>-- :call YamlReplaceCurrentArrayEntry()<CR>

let g:rustfmt_autosave = 1

function! ClearColornames()
	for k in keys(v:colornames)
		unlet v:colornames[k]
	endfor
endfunction

" au ColorSchemePre * call ClearColornames()

function! GroupFilesByProjectRoot(bufObj)
    let root = projectroot#guess(a:bufObj.name)
    if slice(a:bufObj.name, 0, strcharlen(root)) == root
        let a:bufObj.listname = slice(a:bufObj.name, strcharlen(root) + 1)
        let a:bufObj.groupkey = root
    else
        let a:bufObj.listname = a:bufObj.name
        " leave the bufObj.groupkey alone to accept default
    endif
endfunction
let g:GroupedBufExplorerGroupingHook = function('GroupFilesByProjectRoot')

command! -nargs=1 ColorGrep :echo filter(copy(v:colornames), "v:key =~ '.*<args>.*'")

function! TadaComplete(arg_lead, cmd_line, cursor_pos) abort
    let l:prefix = resolve($HOME . "/Documents/Tada/")
    let l:prefixLen = len(l:prefix)
    let l:entries = split(globpath(l:prefix, "" . a:arg_lead . "*"), "\n")
    let l:names = map(l:entries, "v:val[" . (l:prefixLen + 1) . ":]")
    return l:names
endfunction

function! OpenTada(filename) abort
    let l:entries = split(globpath("$HOME/Documents/Tada", a:filename), "\n")
    if len(l:entries) == 0
        return
    endif

    execute "edit " . l:entries[0]
endfunction

command! -nargs=1 -complete=customlist,TadaComplete Tada :call OpenTada(<q-args>)

function! AutoformatBufferDisable() abort
    if exists('b:autoformat_autoindent')
        let b:bak_autoformat_autoindent = b:autoformat_autoindent
    endif
    if exists('b:autoformat_retab')
        let b:bak_autoformat_retab = b:autoformat_retab
    endif
    if exists('b:autoformat_remove_trailing_spaces')
        let b:bak_autoformat_remove_trailing_spaces = b:autoformat_remove_trailing_spaces
    endif
    let b:autoformat_autoindent = v:false
    let b:autoformat_retab = v:false
    let b:autoformat_remove_trailing_spaces = v:false
endfunction

function! AutoformatBufferReenable() abort
    if exists('b:bak_autoformat_autoindent')
        let b:autoformat_autoindent = b:bak_autoformat_autoindent
    endif
    if exists('b:bak_autoformat_retab')
        let b:autoformat_retab = b:bak_autoformat_retab
    endif
    if exists('b:bak_autoformat_remove_trailing_spaces')
        let b:autoformat_remove_trailing_spaces = b:bak_autoformat_remove_trailing_spaces
    endif
endfunction

command! AutoformatBufferDisable :call AutoformatBufferDisable()
command! AutoformatBufferReenable :call AutoformatBufferReenable()

