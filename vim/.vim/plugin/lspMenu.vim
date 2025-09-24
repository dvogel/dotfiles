vim9script

var menuChoices = [
    ["Code Actions", "LspCodeAction"],
    ["Hover", "LspHover"],
    ["Show References", "LspShowReferences"],
    ["Show Incoming Calls", "LspIncomingCalls"],
    ["Show Diagnostics", "LspDiagHere"],
    ["Format", "LspFormat"],
    ["Rename", "LspRename"],
    ["Show Signature", "LspShowSignature"],
    ["Goto Declaration", "LspGotoDeclaration"],
    ["Goto Impl", "LspGotoImpl"],
    ["Goto Definition", "LspGotoDefinition"],
]

def MoveOptionToTop(idx: number): void
    var entry = menuChoices[idx]
    remove(menuChoices, idx)
    insert(menuChoices, entry, 0)
enddef

def ShowLspMenu(): void
    var dispChoices = mapnew(menuChoices, (idx, pair) => pair[0])
    var screenCur = screenpos(win_getid(), line('.'), col('.'))
    popup_menu(dispChoices, {
        "padding": [1, 1, 1, 1],
        "border": [1, 0, 0, 0],
        "pos": "topleft",
        "line": screenCur['row'] + 1,
        "col": screenCur['col'] + 1,
        "title": " LSP Menu ",
        "callback": (winid: number, result: number) => {
            if result == - 1
                echomsg "LSP menu cancelled."
                return
            endif

            var idx = result - 1
            var chosenCmd = menuChoices[idx][1]
            execute chosenCmd
            MoveOptionToTop(idx)
        }
    })
enddef

command! LspMenu call <SID>ShowLspMenu()

