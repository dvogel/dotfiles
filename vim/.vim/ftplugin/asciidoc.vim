vim9script

syntax sync fromstart

setlocal tabstop=4
setlocal shiftwidth=4
setlocal nojoinspaces
# q = allow formatting with gq
# n = use formatlistpat to auto-indent numbered list items
# l = long lines are not broken in insert mode
# j = remove comment leader when joining lines, if possible
setlocal formatoptions=qnjl
setlocal textwidth=10000
setlocal showbreak=████
setlocal breakindent
setlocal breakindentopt=sbr,shift:4
setlocal wrap

def AsciiDocHelp()
    var helpText = system("asciidoc --help syntax")
    helpText = tr(helpText, "\r", "\n")
    var helpLines = split(helpText, "\n", v:true)
    setline(line('$') + 1, helpLines)
enddef

command! AsciiDocHelp AsciiDocHelp()
