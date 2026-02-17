vim9script

var selfTest = v:false

def MoveOptionToTop(menuChoices: list<list<any>>, idx: number): void
    var entry = menuChoices[idx]
    remove(menuChoices, idx)
    insert(menuChoices, entry, 0)
enddef

export def ShowCmdMenu(menuName: string, menuChoices: list<list<any>>, options: dict<any>): void
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
            if type(chosenCmd) == v:t_string
                execute chosenCmd
            elseif type(chosenCmd) == v:t_func
                chosenCmd->call([options])
            else
                echoerr "Unrecognized command associated with menu entry: " .. menuChoices[idx][0]
            endif
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
    try
        delcommand -buffer CmdMenuTestSayHello
        delcommand -buffer CmdMenuTestSayGoodbye
        delcommand -buffer CmdMenuTestSaySomething
        delcommand -buffer CmdMenuTest
    catch /E1237/
        # no-op
    endtry
endif
