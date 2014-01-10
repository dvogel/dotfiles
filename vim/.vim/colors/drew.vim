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

hi Normal guifg=#c5c8c6 guibg=#000000

hi ErrorMsg guibg=#cb3725 guifg=#c5c8c6
hi Error guibg=#cb3725 guifg=#c5c8c6
hi IncSearch guibg=#c77624 guifg=#5e6164
hi ModeMsg gui=bold
hi StatusLine gui=reverse,bold
hi StatusLineNC gui=reverse
hi VertSplit guibg=#c5c8c6
hi Visual gui=reverse guifg=Grey guibg=fg
hi VisualNOS gui=underline,bold
hi DiffText gui=bold guibg=Red
hi Cursor guibg=NONE guifg=NONE gui=inverse
hi lCursor guibg=#10b2c0 guifg=NONE
hi Directory guifg=Blue
hi LineNr guifg=#fbe572
hi MoreMsg gui=bold guifg=SeaGreen
hi NonText gui=bold guifg=Blue guibg=Black
hi Question gui=bold guifg=SeaGreen
hi Search guibg=#c77624 guifg=#5e6164
hi SpecialKey guifg=Blue
hi Title gui=bold guifg=Magenta
hi WarningMsg guifg=Red
hi WildMenu guibg=Cyan guifg=Black
hi Folded guibg=DarkBlue guifg=Grey
hi FoldColumn guibg=Grey guifg=DarkBlue
hi DiffAdd guibg=LightBlue
hi DiffChange guibg=LightMagenta
hi DiffDelete gui=bold guifg=Blue guibg=LightCyan

hi Comment guifg=#9cd7eb
hi Constant guifg=#10b2c0
hi PreProc guifg=#BB00BB guibg=Black
hi Statement gui=NONE guifg=#cb3725
hi Special guifg=#BB00BB guibg=Black
hi Ignore guifg=Grey
hi Identifier guifg=#0e689d
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


" hi pythonComment guifg=#9cd7eb
" hi pythonFunction guifg=#0e689d
" hi pythonNumber guifg=#10b2c0

hi Function gui=NONE guifg=#10b2c0
hi pythonFunction gui=NONE guifg=#208ec8
hi pythonStatement gui=NONE guifg=#e35c0f
hi pythonException gui=NONE guifg=#fbe572
hi pythonRepeat gui=NONE guifg=#fbe572
hi pythonConditional gui=NONE guifg=#fbe572
hi pythonDecorator gui=NONE guifg=#e35c0f
hi pythonDottedName gui=NONE guifg=#208ec8
hi pythonDot gui=NONE guifg=#e35c0f
hi pythonRawString guifg=#10b2c0
hi pythonString gui=NONE guifg=#cf2152
hi pythonUniString guifg=#c53534
hi pythonUniEscape guifg=#0e8f9b
hi pythonOperator gui=NONE guifg=#fbe572
hi pythonOperatorSyms gui=bold guifg=#fbe572
hi foldcolumn guibg=NONE guifg=NONE
hi SignColumn guibg=#5e6164 guifg=#cb3725
hi pythonBuiltinFunc guifg=#fbe572
hi pythonPreCondit guifg=#e35c0f
hi pythonDocTest guifg=#9cd7eb
hi pythonDocTest2 guifg=#9cd7eb

hi rubySymbol gui=NONE guifg=#e35c0f
hi rubyString gui=NONE guifg=#c53534
hi rubyConstant gui=NONE guifg=#208ec8
hi rubyRailsUserClass gui=NONE guifg=#208ec8
hi rubyPseudoVariable gui=NONE guifg=#c6d80e
hi link rubyDefine Statement
hi link rubyClass Statement

hi link javaScriptFuncKeyword Function
hi javaScriptGlobalObjects guifg=#126d67
hi javaScriptOpSymbols guifg=#fbe572
hi javaScriptParens guifg=#c77624
hi javaScriptBraces guifg=#e35c0f
hi javaScriptEndColons guifg=#208ec8
hi link javaScriptFuncArg Normal
hi javaScriptFuncComma guifg=#e35c0f
hi link javaScriptString String
hi javaScriptRegexpString guifg=#c77624
hi javaScriptNumber guifg=#10b2c0
hi javaScriptFloat guifg=#10b2c0

hi Function gui=NONE guifg=#208ec8
hi Statement gui=NONE guifg=#e35c0f
hi Exception gui=NONE guifg=#fbe572
hi Repeat gui=NONE guifg=#fbe572
hi Conditional gui=NONE guifg=#fbe572
hi String gui=NONE guifg=#c53534

hi jsonBoolean gui=NONE guifg=#9cd7eb
hi jsonEscape gui=NONE guifg=#9cd7eb
hi jsonKeywordMatch gui=NONE guifg=#fbe572
hi jsonNoQuotes gui=reverse guifg=#cb3725
hi jsonNull gui=NONE guifg=#c6d80e
hi jsonNumber gui=NONE guifg=#379f4d
hi jsonQuote gui=NONE guifg=#cb3725
hi jsonString gui=NONE guifg=#c53534
hi jsonBraces gui=NONE guifg=#fbe572
hi jsonFold gui=NONE guifg=#b294bb
hi jsonKeywordRegion gui=NONE guifg=#e35c0f
hi jsonNoise gui=NONE guifg=#fbe572
hi jsonPadding gui=NONE guifg=#b294bb
hi jsonStringSQ gui=NONE guifg=#cb3725
hi jsonCommaError gui=reverse guifg=#cb3725
hi jsonCommentError gui=reverse guifg=#cb3725
hi jsonNumError gui=reverse guifg=#cb3725
hi jsonSemicolonError gui=reverse guifg=#cb3725


