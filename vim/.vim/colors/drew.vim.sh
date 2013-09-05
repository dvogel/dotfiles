#!/bin/bash

(cat | sed -r \
    -e 's/_cyan/#10b2c0/g' \
    -e 's/_aqua/#0e8f9b/g' \
    -e 's/_blue/#0e689d/g' \
    -e 's/_tan/#c77624/g' \
    -e 's/_red/#cb3725/g' \
    -e 's/_firebrick/#c53534/g' \
    -e 's/_pink/#cf2152/g' \
    -e 's/_purple/#b294bb/g' \
    -e 's/_green/#379f4d/g' \
    -e 's/_brown/#642e0e/g' \
    -e 's/_orange/#e35c0f/g' \
    -e 's/_teal/#126d67/g' \
    -e 's/_mtdew/#c6d80e/g' \
    -e 's/_ltblue/#208ec8/g' \
    -e 's/_skyblue/#9cd7eb/g' \
    -e 's/_babyyellow/#fbe572/g' \
    -e 's/_white/#dfdfdf/g' \
    -e 's/_ltgray/#c5c8c6/g' \
    -e 's/_darkgray/#5e6164/g' \
    -e 's/_background/#000000/g' > drew.vim) <<ENDOFSCHEME
" Vim color file
" Maintainer:	Drew Vogel <drewpvogel@gmail.com>
" Last Change:	June 14, 2013
" Licence:	    Public Domain

" This package offers a eye-catching color scheme that resembles the
" default color scheme of Putty telnet terminal.

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "drew"

hi Normal guifg=_ltgray guibg=_background

hi ErrorMsg guibg=_red guifg=_ltgray
hi Error guibg=_red guifg=_ltgray
hi IncSearch guibg=_tan guifg=_darkgray
hi ModeMsg gui=bold
hi StatusLine gui=reverse,bold
hi StatusLineNC gui=reverse
hi VertSplit guibg=_ltgray
hi Visual gui=reverse guifg=Grey guibg=fg
hi VisualNOS gui=underline,bold
hi DiffText gui=bold guibg=Red
hi Cursor guibg=NONE guifg=NONE gui=inverse
hi lCursor guibg=_cyan guifg=NONE
hi Directory guifg=Blue
hi LineNr guifg=_babyyellow
hi MoreMsg gui=bold guifg=SeaGreen
hi NonText gui=bold guifg=Blue guibg=Black
hi Question gui=bold guifg=SeaGreen
hi Search guibg=_tan guifg=_darkgray
hi SpecialKey guifg=Blue
hi Title gui=bold guifg=Magenta
hi WarningMsg guifg=Red
hi WildMenu guibg=Cyan guifg=Black
hi Folded guibg=DarkBlue guifg=Grey
hi FoldColumn guibg=Grey guifg=DarkBlue
hi DiffAdd guibg=LightBlue
hi DiffChange guibg=LightMagenta
hi DiffDelete gui=bold guifg=Blue guibg=LightCyan

hi Comment guifg=_skyblue
hi Constant guifg=_cyan
hi PreProc guifg=#BB00BB guibg=Black
hi Statement gui=NONE guifg=_red
hi Special guifg=#BB00BB guibg=Black
hi Ignore guifg=Grey
hi Identifier guifg=_blue
hi Type guifg=#00BB00 guibg=Black

hi link IncSearch		Visual
hi link String			Constant
hi link Character		Constant
hi link Number			Constant
hi link Boolean			Constant
hi link Float			Number
" hi link Function		Identifier
hi link Conditional		Statement
hi link Repeat			Statement
hi link Label			Statement
hi link Operator		Statement
hi link Keyword			Statement
hi link Exception		Statement
hi link Include			PreProc
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link SpecialChar		Special
hi link Delimiter		Special
hi link SpecialComment	Special
hi link Debug			Special

" vim: sw=2


" hi pythonComment guifg=_skyblue
" hi pythonFunction guifg=_blue
" hi pythonNumber guifg=_cyan

hi Function gui=NONE guifg=_cyan
hi pythonFunction gui=NONE guifg=_ltblue
hi pythonStatement gui=NONE guifg=_orange
hi pythonException gui=NONE guifg=_babyyellow
hi pythonRepeat gui=NONE guifg=_babyyellow
hi pythonConditional gui=NONE guifg=_babyyellow
hi pythonDecorator gui=NONE guifg=_orange
hi pythonDottedName gui=NONE guifg=_ltblue
hi pythonDot gui=NONE guifg=_orange
hi pythonRawString guifg=_cyan
hi pythonString gui=NONE guifg=_pink
hi pythonUniString guifg=_firebrick
hi pythonUniEscape guifg=_aqua
hi pythonOperator gui=NONE guifg=_babyyellow
hi pythonOperatorSyms gui=bold guifg=_babyyellow
hi foldcolumn guibg=NONE guifg=NONE
hi SignColumn guibg=_darkgray guifg=_red
hi pythonBuiltinFunc guifg=_babyyellow
hi pythonPreCondit guifg=_orange
hi pythonDocTest guifg=_skyblue
hi pythonDocTest2 guifg=_skyblue

hi rubySymbol gui=NONE guifg=_orange
hi rubyString gui=NONE guifg=_firebrick
hi rubyConstant gui=NONE guifg=_ltblue
hi rubyRailsUserClass gui=NONE guifg=_ltblue
hi rubyPseudoVariable gui=NONE guifg=_mtdew
hi link rubyDefine Statement
hi link rubyClass Statement

hi Function gui=NONE guifg=_ltblue
hi Statement gui=NONE guifg=_orange
hi Exception gui=NONE guifg=_babyyellow
hi Repeat gui=NONE guifg=_babyyellow
hi Conditional gui=NONE guifg=_babyyellow

ENDOFSCHEME
wait

