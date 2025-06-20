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

def AsciDocMakeCodeBlock(firstLine: number, lastLine: number): void
    append(firstLine - 1, "-------------------")
    append(lastLine + 1, "-------------------")
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

command! AsciiDocHelp AsciiDocHelp()
command! -range AsciiDocCode AsciDocMakeCodeBlock(<line1>, <line2>)



