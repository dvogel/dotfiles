vim9script

var selfTest = v:false

def MoveOptionToTop(menuChoices: list<list<string>>, idx: number): void
    var entry = menuChoices[idx]
    remove(menuChoices, idx)
    insert(menuChoices, entry, 0)
enddef

export def ShowCmdMenu(menuName: string, menuChoices: list<list<string>>): void
    var dispChoices = mapnew(menuChoices, (idx, pair) => pair[0])
    var screenCur = screenpos(win_getid(), line('.'), col('.'))
    popup_menu(dispChoices, {
        "padding": [1, 1, 1, 1],
        "border": [1, 0, 0, 0],
        "pos": "topleft",
        "line": screenCur['row'] + 1,
        "col": screenCur['col'] + 1,
        "title": " " .. menuName .. " Menu ",
        "callback": (winid: number, result: number) => {
            if result == - 1
                echomsg menuName .. " menu cancelled."
                return
            endif

            var idx = result - 1
            var chosenCmd = menuChoices[idx][1]
            execute chosenCmd
            MoveOptionToTop(menuChoices, idx)
        }
    })
enddef

if selfTest == v:true
    var testMenuChoices = [
        ["Say Hello", "CmdMenuTestSayHello"],
        ["Say Goodbye", "CmdMenuTestSayGoodbye"],
        ["Say Something", "CmdMenuTestSaySomething hello and goodbye"],
    ]

    def CmdMenuTestShowMenu(): void
        ShowCmdMenu("Test", testMenuChoices)
    enddef

    command! -buffer CmdMenuTestSayHello :echo "hello"
    command! -buffer CmdMenuTestSayGoodbye :echo "goodbye"
    command! -buffer -nargs=* CmdMenuTestSaySomething :echo <q-args>
    command! -buffer CmdMenuTest CmdMenuTestShowMenu()
    nmap <buffer> L :CmdMenuTest<CR>
else
    delcommand! CmdMenuTestSayHello
    delcommand! CmdMenuTestSayGoodbye
    delcommand! CmdMenuTestSaySomething
    delcommand! CmdMenuTest
endif
