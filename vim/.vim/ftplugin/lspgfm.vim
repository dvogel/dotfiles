vim9script

def SearchInStdDocs(term: string): void
    var url = "https://doc.rust-lang.org/std/index.html?search=" .. term
    var cmd = "xdg-open \"" .. url .. "\""
    system(cmd)
enddef

command -buffer SearchForWordInStdDocs SearchInStdDocs(expand('<cword>'))

nmap <buffer> <leader>d :SearchForWordInStdDocs<CR>
nmap <buffer> <ESC> :close<CR>
