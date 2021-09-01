" Forked from EvalSelection.vim at https://www.vim.org/scripts/script.php?script_id=889
" Original header content:
" @Author:      Thomas Link (samul AT web.de)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     29-Jän-2004.
"
" Forked to remove everything other than the ability to evaluate vimscript
" code. This includes removing all of the bits that prevent the commands and
" errors from being output.

if &cp || exists("s:loaded_evalselection_vimonly")
    finish
endif
let s:loaded_evalselection_vimonly = 16

fun! EvalVimCode(code) abort
    let lines = split(a:code, "[\r\n]\+")
    redir @E
    for l in lines
        execute ":" . l
    endfor
    redir END
endf

