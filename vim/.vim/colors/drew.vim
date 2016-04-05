

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
let g:color_scheme_file = expand('<sfile>')

hi Normal guifg=#c5c8c6 guibg=#000000

hi Todo gui=REVERSE,BOLD guifg=#c53534 guibg=#fbe572

hi ErrorMsg guibg=#cb3725 guifg=#c5c8c6
hi Error guibg=#cb3725 guifg=#c5c8c6
hi IncSearch guibg=#c77624 guifg=#5e6164
hi ModeMsg gui=bold
hi StatusLine gui=reverse,bold
hi StatusLineNC gui=reverse
hi VertSplit guibg=#c5c8c6
hi Visual gui=reverse guifg=NONE guibg=NONE
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
hi PreProc guifg=#bb00bb guibg=Black ctermfg=DarkMagenta
hi Statement gui=NONE guifg=#cb3725
hi Special guifg=#BB00BB guibg=Black ctermfg=Yellow
hi Ignore guifg=Grey
hi Identifier guifg=#0e689d
hi Type guifg=#379f4d gui=NONE

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

hi vimHightlight guifg=#e35c0f
hi vimGroup guifg=#0e689d
hi vimHiGui guifg=#c6d80e
hi vimHiGuiFgBg guifg=#c6d80e
hi vimHiCterm guifg=#c6d80e
hi vimHiCtermFgBg guifg=#c6d80e
hi vimHiCtermColor guifg=#c53534
hi vimHiAttrib guifg=#c53534

" hi pythonComment guifg=#9cd7eb
" hi pythonFunction guifg=#0e689d
" hi pythonNumber guifg=#10b2c0

hi Function gui=NONE guifg=#10b2c0 cterm=NONE ctermfg=Blue
hi pythonFunction gui=NONE guifg=#208ec8
hi pythonStatement gui=NONE guifg=#e35c0f
hi pythonException gui=NONE guifg=#fbe572
hi pythonRepeat gui=NONE guifg=#fbe572
hi pythonConditional gui=NONE guifg=#fbe572
hi pythonDecorator gui=NONE guifg=#e35c0f
hi pythonDottedName gui=NONE guifg=#208ec8
hi pythonDot gui=NONE guifg=#e35c0f
hi pythonRawString guifg=#10b2c0
hi pythonString gui=NONE guifg=#cf2152 ctermfg=DarkMagenta
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

hi rubyBoolean gui=NONE guifg=#ee1122 ctermfg=LightRed
hi rubySymbol gui=NONE guifg=#ebab6a ctermfg=Brown
hi rubyString gui=NONE guifg=#c53534 ctermfg=DarkRed
hi rubyInteger gui=NONE guifg=#0e8f9b ctermfg=DarkCyan
hi rubyConstant gui=NONE guifg=#208ec8 ctermfg=Blue
hi rubyInterpolationDelimiter gui=NONE guifg=#fbe572 ctermfg=Yellow
hi rubyRailsUserClass gui=NONE guifg=#208ec8 ctermfg=LightBlue
hi rubyPseudoVariable gui=NONE guifg=#c6d80e ctermfg=LightGreen
hi rubyConditional guifg=#fbe572 ctermfg=Yellow
hi rubyExceptional guifg=#e35c0f ctermfg=Brown
hi rubyAccess guifg=#d9cd94 ctermfg=Brown
hi rubyDefine guifg=#e35c0f ctermfg=Brown
hi rubyClass guifg=#c6d80e ctermfg=LightGreen
hi rubyModule guifg=#ee1122 ctermfg=LightRed
hi rubyRailsTestMethod guifg=#ba99fa

hi goType          guifg=#379f4d
hi goUnsignedInts  guifg=#379f4d
hi goBoolean       guifg=#cf2152
hi goMethod        guifg=#c5c8c6
hi goOperator      guifg=#ebab6a
hi goStructDef     guifg=#208ec8
hi link goStruct Normal

hi coffeeObject       guifg=#208ec8       ctermfg=LightBlue
hi coffeeObjAssign    guifg=#208ec8       ctermfg=LightBlue
hi coffeeSpecialOp    guifg=#c5c8c6       ctermfg=Yellow
hi coffeeExtendedOp   guifg=#fbe572   ctermfg=Brown
hi coffeeParensParen  guifg=#c77624          ctermfg=Brown
hi coffeeBooleanTrue  guifg=#b3e46f    ctermfg=LightGreen
hi coffeeBooleanFalse guifg=#ee1122   ctermfg=LightRed
hi coffeeSpecialIdent guifg=#cacaf0  ctermfg=LightGray
hi coffeeRegex        guifg=#c77624          ctermfg=Brown

hi javaScriptStatement cterm=NONE ctermfg=Brown gui=NONE guifg=#e35c0f
hi javaScriptGlobalObjects guifg=#126d67
hi javaScriptOpSymbols guifg=#fbe572
hi javaScriptParens guifg=#c77624 ctermfg=Brown
hi javaScriptBraces guifg=#e35c0f ctermfg=Yellow
hi javaScriptEndColons guifg=#208ec8
hi link javaScriptFuncArg Normal
hi javaScriptFuncKeyword gui=NONE guifg=#0e689d cterm=NONE ctermfg=Blue
hi javaScriptFuncDef gui=NONE guifg=#379f4d cterm=NONE ctermfg=LightGreen
hi javaScriptFuncExp gui=NONE guifg=#379f4d cterm=NONE ctermfg=LightGreen
hi javaScriptFuncComma guifg=#e35c0f
hi javaScriptBoolean guifg=#9cd7eb ctermfg=Blue
hi javaScriptString guifg=#c53534 ctermfg=Red
hi javaScriptStringS guifg=#c53534 ctermfg=Red
hi javaScriptStringD guifg=#c53534 ctermfg=Red
hi javaScriptRegexpString guifg=#c77624 ctermfg=Brown
hi javaScriptNumber guifg=#10b2c0 ctermfg=DarkCyan
hi javaScriptFloat guifg=#10b2c0 ctermfg=DarkCyan

hi markdownH1 guifg=#e35c0f
hi markdownH2 guifg=#ee1122
hi markdownH3 guifg=#c6d80e
hi markdownH4 guifg=#cf2152
hi markdownH5 guifg=#10b2c0
hi markdownH6 guifg=#cacaf0
hi markdownCode guifg=#379f4d
hi markdownCodeBlock guifg=#379f4d
hi markdownHeadingDelimiter guifg=#5e6164
hi markdownHeadingRule guifg=#5e6164
hi markdownListMarker guifg=#ebab6a
hi markdownOrderedListMarker guifg=#ebab6a


hi Function gui=NONE guifg=#208ec8
hi Statement gui=NONE guifg=#e35c0f
hi Exception gui=NONE guifg=#fbe572
hi Repeat gui=NONE guifg=#fbe572
hi Conditional gui=NONE guifg=#fbe572
hi String gui=NONE guifg=#c53534

hi jsonBoolean gui=NONE guifg=#9cd7eb ctermfg=LightBlue
hi jsonEscape gui=NONE guifg=#9cd7eb ctermfg=LightBlue
hi jsonKeywordMatch gui=NONE guifg=#fbe572 ctermfg=Yellow
hi jsonNoQuotes gui=reverse guifg=#cb3725 cterm=reverse ctermfg=Red
hi jsonNull gui=NONE guifg=#c6d80e ctermfg=Yellow
hi jsonNumber gui=NONE guifg=#379f4d ctermfg=Green
hi jsonQuote gui=NONE guifg=#cb3725 ctermfg=LightRed
hi jsonString gui=NONE guifg=#c53534 ctermfg=DarkRed
hi jsonBraces gui=NONE guifg=#fbe572 ctermfg=Yellow
hi jsonFold gui=NONE guifg=#ba99fa ctermfg=Magenta
hi jsonKeywordRegion gui=NONE guifg=#e35c0f ctermfg=Brown
hi jsonNoise gui=NONE guifg=#fbe572 ctermfg=Yellow
hi jsonPadding gui=NONE guifg=#ba99fa ctermfg=Magenta
hi jsonStringSQ gui=NONE guifg=#cb3725 ctermfg=LightRed
hi jsonCommaError gui=reverse guifg=#cb3725 cterm=reverse ctermfg=LightRed
hi jsonCommentError gui=reverse guifg=#cb3725 cterm=reverse ctermfg=LightRed
hi jsonNumError gui=reverse guifg=#cb3725 cterm=reverse ctermfg=LightRed
hi jsonSemicolonError gui=reverse guifg=#cb3725 cterm=reverse ctermfg=LightRed

hi yamlKey gui=NONE guifg=#ebab6a ctermfg=Brown
hi yamlDelimiter gui=NONE guifg=#ebab6a ctermfg=Brown
hi yamlString gui=NONE guifg=#c53534 ctermfg=DarkRed
hi yamlNumber gui=NONE guifg=#379f4d ctermfg=Green
hi yamlComment gui=NONE guifg=#c5c8c6 ctermfg=Grey

"hi groovyExternal                  xxx links to Include
hi groovyError               gui=bold guifg=#fafafa guibg=#990000
"hi groovyConditional               xxx links to Conditional
"hi groovyRepeat                    xxx links to Repeat
hi groovyBoolean             gui=NONE guifg=#208ec8
"hi groovyConstant                  xxx links to Constant
hi groovyTypedef             gui=NONE guifg=#e35c0f
hi groovyOperator            gui=NONE guifg=#fbe572  
hi groovyType                gui=NONE guifg=#126d67
hi groovyStatement           gui=NONE guifg=#e35c0f
hi groovyStorageClass        gui=NONE guifg=#e35c0f
hi groovyExceptions          gui=NONE guifg=#c6d80e
hi groovyAssert              gui=NONE guifg=#e35c0f
hi groovyMethodDecl          gui=NONE guifg=#e35c0f
hi groovyClassDecl           gui=NONE guifg=#e35c0f
"hi groovyBranch                    xxx links to Conditional
"hi groovyUserLabelRef              xxx links to groovyUserLabel
"hi groovyScopeDecl                 xxx links to groovyStorageClass
hi groovyLangClass           gui=NONE guifg=#ee1122
hi groovyJavaLangClass       gui=NONE guifg=#cf2152
hi groovyJavaLangObject      gui=NONE guifg=#cf2152
hi groovyJDKBuiltin          gui=NONE guifg=#c6d80e
hi groovyJDKOperOverl        gui=NONE guifg=#c6d80e
hi groovyJDKMethods          gui=NONE guifg=#c6d80e
"hi groovyLabel                     xxx links to Label
hi groovyNumber              gui=NONE guifg=#0e8f9b
hi groovyString              gui=NONE guifg=#c53534
"hi groovyLabelRegion               xxx cleared
"hi groovyUserLabel                 xxx links to Label
"hi groovyError2                    xxx cleared
"hi groovyLangObject                xxx cleared
hi groovyTodo                gui=bold guifg=#fbe572
"hi groovySpecial                   xxx links to Special
"hi groovySpecialChar               xxx links to SpecialChar
hi groovyComment             gui=NONE guifg=#c5c8c6
hi groovyStar                gui=NONE guifg=#c5c8c6
hi groovyLineComment         gui=NONE guifg=#c5c8c6
hi groovyCommentString       gui=NONE guifg=#c5c8c6
hi groovyComment2String      gui=NONE guifg=#c5c8c6
hi groovyCommentCharacter    gui=NONE guifg=#c5c8c6
"hi groovyCharacter                 xxx links to Character


hi CSVColumnEven          gui=NONE   guifg=#c5c8c6       guibg=#000000
hi CSVColumnOdd           gui=NONE   guifg=#5e6164     guibg=#000000
hi CSVColumnHeaderEven    gui=NONE   guifg=#ee1122
hi CSVColumnHeaderOdd     gui=NONE   guifg=#c53534
hi CSVDelimiter           gui=NONE   guifg=#e35c0f       guibg=#0e689d
"hi CSVComment             gui=NONE
"hi CSVHeaderLine          gui=NONE

hi Delimiter     gui=NONE   guifg=#fbe572
hi shSetList     gui=NONE   guifg=#208ec8
hi shVariable    gui=NONE   guifg=#208ec8
hi shExpr        gui=NONE   guifg=#9cd7eb
hi shOption      gui=NONE   guifg=#c6d80e
hi shCommandSub  gui=NONE   guifg=#fbe572
hi shDerefSimple gui=NONE   guifg=#126d67
hi shArithRegion gui=NONE   guifg=#126d67

hi cssComment               gui=italic   guifg=#5e6164
hi cssIdentifier            gui=NONE   guifg=#0e689d
hi cssBraces                gui=NONE   guifg=#c6d80e
hi cssTagName               gui=NONE   guifg=#e35c0f
hi cssClassNameDot          gui=NONE   guifg=#208ec8
hi cssClassName             gui=NONE   guifg=#208ec8
hi cssPseudoClassId         gui=NONE   guifg=#e39e58
hi cssSelectorOp            gui=NONE   guifg=#c6d80e
hi cssNoise                 gui=NONE   guifg=#b294bb
hi cssDefinition            gui=NONE   guifg=#d9cd94
hi link cssFontProp         cssDefinition
hi link cssTextProp         cssDefinition
hi link cssBoxProp          cssDefinition
hi link cssPositioningProp  cssDefinition
hi link cssBorderProp       cssDefinition
hi link cssBackgroundProp   cssDefinition
hi link cssUIProp           cssDefinition
hi link cssDimensionProp    cssDefinition
hi link cssPageProp         cssDefinition
hi cssVendor                gui=NONE   guifg=#fbe572
" hi cssDimensionProp         gui=NONE   guifg=
hi cssColor                 gui=NONE   guifg=#e35c0f
hi cssImportant             gui=NONE   guifg=#cf2152
" hi cssAttrRegion            gui=NONE   guifg=
" hi cssCommonAttr            gui=NONE   guifg=
hi cssBackgroundAttr        gui=NONE   guifg=#ee1122
hi cssPositioningAttr       gui=NONE   guifg=#cb3725
hi cssBoxAttr               gui=NONE   guifg=#cb3725
hi cssUIAttr                gui=NONE   guifg=#cb3725
hi cssGradientAttr          gui=NONE   guifg=#cb3725
hi cssFunction              gui=NONE   guifg=#cb3725
hi cssFunctionName          gui=NONE   guifg=#379f4d
hi cssValueLength           gui=NONE   guifg=#ee1122
hi cssValueNumber           gui=NONE   guifg=#ee1122
hi cssUnitDecorators        gui=NONE   guifg=#cb3725

hi dosiniLabel     gui=NONE guifg=#0e689d
hi dosiniHeader    gui=NONE guifg=#e35c0f
hi dosiniNumber    gui=NONE guifg=#379f4d
hi dosiniComment   gui=NONE guifg=#5e6164


hi Pmenu      gui=NONE    guibg=Gray     guifg=Black      ctermbg=LightGray ctermfg=Black
hi PmenuSel   gui=NONE    guibg=Gray     guifg=Yellow     ctermbg=LightGray ctermfg=Black
hi PmenuSbar  gui=NONE    guibg=Magenta  guifg=Red        ctermbg=Magenta   ctermfg=Red
hi PmenuThumb gui=NONE    guibg=Magenta  guifg=Red        ctermbg=Magenta   ctermfg=Red

hi NERDTreeOpenable   gui=NONE   guifg=#9cd7eb
hi NERDTreeClosable   gui=NONE   guifg=#9cd7eb
hi NERDTreeDir        gui=NONE   guifg=#e39e58

hi procProcName guifg=#f37c2f
hi procComment guifg=#c5c8c6

hi bashStatement ctermfg=DarkCyan
hi bashBlock ctermfg=Yellow
hi bashDo ctermfg=Yellow
hi bashComment ctermfg=Gray
hi bashDeref ctermfg=DarkMagenta
hi bashIdentifier ctermfg=DarkGreen
hi bashHereDoc ctermfg=DarkGray
hi bashRedir ctermfg=Yellow
hi link bashCommandOpts Normal
hi bashOperator ctermfg=Brown


