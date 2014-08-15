set tabstop=2
set shiftwidth=2
set expandtab
set nowrap

" Set JavaScript Lint as compiler. 
if ! exists('b:current_compiler') 
    compiler jsl 
endif
