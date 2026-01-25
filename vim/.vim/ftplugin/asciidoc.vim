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

def AsciiDocMakeCodeBlock(firstLine: number, lastLine: number): void
    append(firstLine - 1, "-------------------")
    append(lastLine + 1, "-------------------")
enddef

def AsciiDocMakeHeader(ch: string): void
    var headerLine = substitute(getline('.'), '.', ch, 'g')
    append(line('.'), [headerLine])
enddef

def AsciiDocHelpCloseCallback(popupWinId: number, result: any): void
    unlet b:asciiDocHelpPopupWinId
enddef

def AsciiDocHelpPopupFilter(winid: number, key: string): number
    if !exists("b:asciiDocHelpPopupWinId")
        return 0
    endif

    var winNr = win_id2win(b:asciiDocHelpPopupWinId)
    if key == "\<Esc>"
        CloseAsciiDocHelp()
        return 1
    elseif key == "j"
        execute ":" .. winNr .. "wincmd j"
        return 1
    elseif key == "k"
        execute ":" .. winNr .. "wincmd k"
        return 1
    endif
    return 0
enddef

def OpenAsciiDocHelpBuffer()
    enew
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=
    silent file [AsciiDoc Help]
    setlocal filetype=

    var helpText = system("asciidoc --help syntax")
    helpText = tr(helpText, "\r", "\n")
    var helpLines = split(helpText, "\n", v:true)
    append('$', helpLines)
enddef

def AsciiDocHelp()
    var helpText = system("asciidoc --help syntax")
    helpText = tr(helpText, "\r", "\n")
    var helpLines = split(helpText, "\n", v:true)
    # b:asciiDocHelpPopupWinId = popup_create(helpLines, {
    #     "title": "Ascii Doc Help",
    #     "padding": [3, 3, 3, 3],
    #     "close": "button",
    #     "cursorline": 1,
    #     "callback": function("AsciiDocHelpCloseCallback"),
    #     "filter": function("AsciiDocHelpPopupFilter"),
    # })
enddef

def CloseAsciiDocHelp()
    if exists("b:asciiDocHelpPopupWinId")
        popup_close(b:asciiDocHelpPopupWinId)
    endif
enddef

import "cmdmenu.vim"
var asciiDocCmdMenu = [
    ["Make code block", "AsciiDocCode"],
    ["Make title header", "AsciiDocMakeTitleHeader"],
    ["Make section header", "AsciiDocMakeSectionHeader"],
]
command! -buffer ShowAsciiDocCmdMenu cmdmenu.ShowCmdMenu("AsciiDoc", asciiDocCmdMenu)
nmap <buffer> L :ShowAsciiDocCmdMenu<CR>

# command! AsciiDocHelp AsciiDocHelp()
command! AsciiDocHelp OpenAsciiDocHelpBuffer()
command! -range AsciiDocCode AsciiDocMakeCodeBlock(<line1>, <line2>)
command! AsciiDocMakeTitleHeader AsciiDocMakeHeader("=")
command! AsciiDocMakeSectionHeader AsciiDocMakeHeader("-")
command! AsciiDocMakeHeaderL0 AsciiDocMakeHeader("=")
command! AsciiDocMakeHeaderL1 AsciiDocMakeHeader("-")
command! AsciiDocMakeHeaderL2 AsciiDocMakeHeader("~")
command! AsciiDocMakeHeaderL3 AsciiDocMakeHeader("^")
command! AsciiDocMakeHeaderL4 AsciiDocMakeHeader("+")
