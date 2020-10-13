filetype off

let g:ackpreview = 0
let g:ackhighlight = 1
let g:ack_use_dispatch = 0

# This loads plugins in pack/plugins/start
packloadall

# Some system-provided packs still need to be added though:
packadd bufexplorer
packadd matchit
packadd surround

filetype plugin indent on
syntax on
set synmaxcol=5000
syntax sync clear
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
set modeline
set showmatch
set laststatus=2
set hidden
set wildmenu
set wildmode=longest:list
set title
set scrolloff=1
set wildignore=*.o,*.hi
set guioptions=Pegit
set splitbelow
set splitright
set conceallevel=2

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

let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_auto_popup = 0
set completeopt=menuone,preview
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': [],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_use_mono = 0
let g:OmniSharp_start_server = 1
let g:OmniSharp_highlighting = 0

let g:syntastic_cs_checkers = ['code_checker']
let g:syntastic_html_checkers = ['htmlhint']
let g:syntastic_ruby_checkers=['rubocop']
let g:syntastic_python_checkers=['pyflakes']
let g:syntastic_quiet_messages = { 'regex': 'parentheses after method name' }
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_typescript_eslint_exe='$(npm bin)/eslint'
let g:syntastic_typescript_checkers=['eslint']
let g:syntastic_mode_map = { "mode": "active", "passive_filetypes": ["rust"] }

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

let g:formatdef_my_custom_cs = '"astyle --mode=cs --style=1tbs -N --convert-tabs --keep-one-line-blocks --indent-continuation=2 -s".&shiftwidth'
let g:formatters_cs = ['my_custom_cs']

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 0
let g:go_highlight_extra_types = 1
let g:go_highlight_structs = 1

let g:lsc_auto_map = v:true
let g:lsc_enable_autocomplete = v:false
let g:lsc_server_commands = {'javascript': 'javascript-typescript-stdio'}
let g:LanguageClient_rootMarkers = {
    \ 'javascript': ['jsconfig.json'],
    \ 'typescript': ['tsconfig.json'],
    \ }

com! W w
com! Q q
" Paste from system clipboard (instead of primary selection)
nmap <Leader>cbp "+p

let g:pep8_map = '<C-F5>'

au FileType python source ~/.vim/scripts/python.vim
au FileType php call Buffer_Init_PHP()
au FileType cpp call Buffer_Init_CPP()
au FileType clojure call Buffer_Init_Clojure()
au BufNewFile,BufRead templates/*.html setlocal filetype=htmldjango
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au BufNewFile,BufRead,BufFilePre *.scpl setlocal filetype=scpl

" Always open the quickfix window on the bottom (no vertical split)
au FileType qf wincmd J

nmap <C-h> :wincmd h<CR>
nmap <C-j> :wincmd j<CR>
nmap <C-k> :wincmd k<CR>
nmap <C-l> :wincmd l<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
map <F4> :call DelicatelyDeleteBuffer()<CR>
map <F5> :w<CR>
nmap <F9> :BufExplorer<CR>
nmap <F6> :NERDTreeToggle<CR>
nmap <C-F6> :TagbarToggle<CR>
" Depends on vim-surround from Tim Pope:
" ^S' will quote the word under the cursor with a single quote
nmap <C-S> ysiw

let g:rootmarkers = ['.projectroot', '.git', '.hg', '.svn', '.bzr', '_darcs', 'build.xml', 'pom.xml']

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['.projectroot', '.git', 'tags', 'TAGS', 'pom.xml']
let g:ctrlp_custom_ignore = '\v.*(build|node_modules|target/clover).*'

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

function! Buffer_Init_Clojure()
	syn sync fromstart
	set expandtab
    " nmap <F9> :w<CR>:!~/devel/clj/runscript %<CR>
    " imap <F9> <ESC>:w<CR>:!~/devel/clj/runscript %<CR>
	nmap <F10> :w<CR>:!~/devel/clj/runrepl<CR>
	imap <F10> <ESC>:w<CR>:!~/devel/clj/runrepl<CR>
	nmap <F11> :w<CR>:!ant<CR>
	imap <F11> <ESC>:w<CR>:!ant<CR>
endfunction

function! Buffer_Init_PHP()
	" map <F9> :call Show_PHP_Help_For_Word()<CR>
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


function! ListedBuffers()
  return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction

function! DelicatelyDeleteBuffer()
  let l:bufcount = len(ListedBuffers())
  if l:bufcount == 0
    " there is no current buffer
  elseif l:bufcount == 1
    bdelete
  else
    execute "bnext"
    if bufnr('#') >= 0 && buflisted(bufnr('#')) == 1
      execute "bdelete" "#"
    end
  end
endfunction

" set guifont=Consolas\ 13
" set guifont=Bitstream\ Vera\ Sans\ Mono\ 11
if has("gui")
  if has("mac")
    set guifont=Menlo\ Regular:h14
  else
    set guifont=Cascadia\ Code\ 12
  endif
endif

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
  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
  au BufRead,BufNewFile *.q               set filetype=Q
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

autocmd BufNewFile,BufRead *.cup setf cup

" Together, these two commands hide the vertical splits but the 
" number line has a trough that still appears
set fillchars=
highlight VertSplit guibg=background guifg=background gui=none term=none cterm=none

let python_highlight_all = 1
let g:vim_json_syntax_conceal = 0

let g:evalSelectionRubyDir = $HOME."/.vim/bundle/EvalSelection.vim/ruby/"

function! SyntaxTrailAt(lnum, col)
    let l:stack = synstack(a:lnum, a:col)

    let l:trail = []
    for syn_id in l:stack
        let l:name = synIDattr(syn_id, "name")
        if l:name != ""
            call add(l:trail, l:name)
        end
    endfor
    return join(l:trail, ' -> ')
endfunction

function! SyntaxTrailUnderCursor()
    return SyntaxTrailAt(line("."), col("."))
endfunction

nnoremap <leader>sy :echo SyntaxTrailUnderCursor()<CR>

function! RegenerateMyColorScheme()
    if ! filewritable(g:color_scheme_file)
        echomsg "Cannot over-write color scheme file: " . g:color_scheme_file
        return
    endif

    let g:color_scheme_script = g:color_scheme_file . ".sh"
    if ! filereadable(g:color_scheme_file)
        echomsg "Cannot read color scheme script: " . color_scheme_script
        return
    endif

    execute ":silent !bash " . g:color_scheme_script
    execute "source " g:color_scheme_file
    windo :e
endfunction


function! MuServicesComplete(arg_lead, cmd_line, cursor_pos)
    let l:entries = split(globpath("libraries,apps,services", "" . a:arg_lead . "*"), "\n")
    let l:names = map(l:entries, 'fnamemodify(v:val, ":t")')
    return l:names
endfunction

function! OpenMuServicesComponent(name)
    let l:entries = split(globpath("libraries,apps,services", "" . a:name), "\n")
    let l:path = substitute(l:entries[0], "^\([.]\+/\)\+", "", "") " Strip dot prefix paths
    let l:prefix = fnamemodify(l:path, ":h")
    let l:subdir = "lib"
    if l:prefix == "apps"
        let l:subdir = "app"
    endif
    execute ":e " . l:path . "/" . l:subdir
    call search('\m^\(\%u25b8\|\s\s[^\s]\)')
endfunction

command! -nargs=1 -complete=customlist,MuServicesComplete Mu :call OpenMuServicesComponent(<q-args>)

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

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'whitelist': ['rust'],
        \ })
endif


