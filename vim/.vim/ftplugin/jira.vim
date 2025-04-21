vim9script

setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal nojoinspaces
setlocal autoindent
setlocal breakindent
setlocal breakindentopt=list:-1
setlocal formatlistpat=^\\*\\+
setlocal formatoptions=qnjl

def JiraNoformatRange(firstLine: number, lastLine: number): void
    append(firstLine - 1, "{noformat}")
    append(lastLine + 1, "{noformat}")
enddef

command! -range JiraNoformat JiraNoformatRange(<line1>, <line2>)
vmap <buffer> <leader>n :JiraNoformat<CR>
