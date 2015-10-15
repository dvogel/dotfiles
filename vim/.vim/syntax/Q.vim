" Vim syntax file
" Language:	   Q language used by CASES.
" Maintainer:  Drew Vogel <dvogel@ssc.wisc.edu>
" URL:         http://www.uwsc.wisc.edu/software/csmq.vim

" if version < 600
"     syntax clear
" elseif exists("b:current_syntax")
"     finish
" endif

syntax clear
syntax case match
syntax keyword QType int char
syntax keyword QOperator eq ne lt gt le ge
syntax keyword QStatement accept active add adddate addtime advance allow anychar autoid begin blink bold call caseid certify clear clearkey close codergoto complete copy cxskip datestring datestyle default define display divide end entry equiv etc exit fill form formatted from get goto gotoloq help history in indirect input inputloc into loc loop loqvar make menu missing multiply new next no nodata noncase normal on open optional posvar preset protocol randomize record reference reject rename reset return reverse section set setdate setkey settime show skip specify start stop store subdate subdirectory subtime subtract supergoto super syn synonym template trace undefine underline unformatted use white window write 
syntax match QStatement /roster \(append\|begin\|close\|create\|end\|exit\|label\|open\|reopen\)"/
syntax keyword QIfElseEndif if else endif
syntax match QConstant /<[^>]*>/
syntax match QItemDecl /^>[a-zA-Z0-9_]\+</
syntax match QIdentifier /[a-zA-Z0-9_]\+\(@[a-zA-Z0-9_]\+\)\?/
syntax region QFunction start=/\[/ end=/\]/ contains=QStatement,QIdentifier,QConstant,QOperator,QIfElseEndif
syntax region QComment start=/\[#/ end=/\]/
syntax region QIfBlock start=/\[if / end=/\[endif\]/ contains=ALLBUT,QOperator,QConstant,QIfElseEndif

highlight QComment guifg=Grey
highlight QStatement guifg=#BBBB00
highlight QItemDecl guifg=Yellow
highlight QIdentifier guifg=#80a0ff
highlight QConstant guifg=#BB0000
highlight QFunction guifg=Cyan
highlight QOperator guifg=Green
highlight QIfElseEndif guifg=Green

let b:current_syntax = "Q"

" 1. When multiple Match or Region items start in the same position, the item
"    defined last has priority.
" 2. A Keyword has priority over Match and Region items.
" 3. An item that starts in an earlier position has priority over items that
"    start in later positions.
