set ts=2
set sw=2

" Set JavaScript Lint as compiler. 
if ! exists('b:current_compiler') 
    compiler jsl 
endif
