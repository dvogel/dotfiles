vim9script

var charMap = {
    "├": "└",
    "└": "├",
    "-": "+",
    "+": "-",
    "│": " ",
    " ": "│",
}

def ToggleCharUnderCursor(): void
    var ln = getline(".")
    var chCol = charcol(".") - 1
    var ch = ln[chCol]
    var newCh = get(charMap, ch, ch)
    echo ch .. " => " .. newCh
    var newLn = ln
    if chCol == 0
        newLn = newCh .. ln[1 : ]
    else
        newLn = ln[0 : chCol - 1] .. newCh .. ln[chCol + 1 : ]
    endif
    setline(".", newLn)
enddef

command! ToggleCharUnderCursor call ToggleCharUnderCursor()
nmap <leader>tc :ToggleCharUnderCursor<CR>
