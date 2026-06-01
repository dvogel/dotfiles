vim9script

syntax sync fromstart

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
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

def AsciiDocAdmonish(line: number, admonishment: string): void
    var ln = getline(line)
    var admonishmentPat = '^[A-Z]\+:'
    if match(ln, admonishmentPat) == -1
        var newLn = admonishment .. ": " .. ln
        setline(line, newLn)
    else
        var replLn = substitute(ln, admonishmentPat, admonishment .. ":", "")
        setline(line, replLn)
    endif
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
    ["Admonish: Note", (options) => AsciiDocAdmonish(options.line, "NOTE")],
    ["Admonish: Important", (options) => AsciiDocAdmonish(options.line, "IMPORTANT")],
    ["Admonish: Warning", (options) => AsciiDocAdmonish(options.line, "WARNING")],
    ["Admonish: Tip", (options) => AsciiDocAdmonish(options.line, "TIP")],
    ["Admonish: Caution", (options) => AsciiDocAdmonish(options.line, "CAUTION")],
]
# TODO: The visual menu should have a Linkify entry that converts the selected text to a URL macro.
#       Use this syntax: https://asciidoctor.org[Asciidoctor]
#       The normal menu should have a Linkify entry that inserts a new URL macro.
#       Use this syntax: link:index.html[Docs]
var asciiDocVisualCmdMenu = [
    ["Make code block", (options) => AsciiDocMakeCodeBlock(options.line1, options.line2)],
]
command! -buffer ShowAsciiDocCmdMenu cmdmenu.ShowCmdMenu("AsciiDoc", asciiDocCmdMenu, { "line": line('.') })
command! -buffer -range ShowAsciiDocVisualCmdMenu cmdmenu.ShowCmdMenu("AsciiDoc", asciiDocVisualCmdMenu, { "line1": <line1>, "line2": <line2> })
nmap <buffer> L :ShowAsciiDocCmdMenu<CR>
vmap <buffer> L :ShowAsciiDocVisualCmdMenu<CR>
vmap <buffer> <leader>c :AsciiDocCode<CR>

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
