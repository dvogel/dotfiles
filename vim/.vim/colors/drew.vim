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

" function! Hex2guicolor(hex)
" 	let l:r = str2nr(a:hex[1:2], 16)
" 	let l:g = str2nr(a:hex[3:4], 16)
" 	let l:b = str2nr(a:hex[5:6], 16)
" 	return ((l:r * 65536) + (l:g * 256) + l:b)
" endfunction

" function! Hex2guicolor(hex)
" 	return a:hex
" endfunction

runtime colors/lists/csscolors.vim
runtime colors/lists/pantone.vim
call extend(v:colornames, {
            \ 'drew_cyan': '#10b2c0',
            \ 'drew_aqua': '#0e8f9b',
            \ 'drew_blue': '#0e689d',
            \ 'drew_peach': '#e39e58',
            \ 'drew_puke': '#ebab6a',
            \ 'drew_skin': '#e3b07d',
            \ 'drew_red': '#cb3725',
            \ 'drew_bloodred': '#770011',
            \ 'drew_watermelon': '#ee1122',
            \ 'drew_firebrick': '#c53534',
            \ 'drew_pink': '#cf2152',
            \ 'drew_palepurple': '#b294bb',
            \ 'drew_purple': '#ba99fa',
            \ 'drew_magenta': '#bb00bb',
            \ 'drew_green': '#379f4d',
            \ 'drew_camogreen': '#90ac96',
            \ 'drew_darkgreen': '#276f44',
            \ 'drew_mint': '#d5ffe6',
            \ 'drew_picklegreen': '#b8e238',
            \ 'drew_eastergreen': '#acffcd',
            \ 'drew_neongreen': '#b3e46f',
            \ 'drew_khaki': '#ad6d2b',
            \ 'drew_brown': '#642e0e',
            \ 'drew_orange': '#e35c0f',
            \ 'drew_salmon': '#f37c2f',
            \ 'drew_tan': '#c77624',
            \ 'drew_teal': '#126d67',
            \ 'drew_mtdew': '#c6d80e',
            \ 'drew_ltblue': '#208ec8',
            \ 'drew_skyblue': '#9cd7eb',
            \ 'drew_graysky': '#aabbdd',
            \ 'drew_slateblue': '#7799bb',
            \ 'drew_slategreen': '#77bb99',
            \ 'drew_babyyellow': '#fbe572',
            \ 'drew_birchwood': '#d9cd94',
            \ 'drew_graywood': '#d9d0b4',
            \ 'drew_white': '#dfdfdf',
            \ 'drew_grayishblue': '#cacaf0',
            \ 'drew_ltgray': '#c5c8c6',
            \ 'drew_darkgray': '#5e6164',
            \ 'drew_almostblack': '#1e2124',
            \ 'drew_background': '#000000',
            \ }, "force")


hi Normal guifg=drew_ltgray guibg=drew_background

hi CursorLine guifg=#ffffff guibg=#444444

hi Todo gui=REVERSE,BOLD guifg=drew_firebrick guibg=drew_babyyellow

hi ErrorMsg guibg=drew_red guifg=drew_ltgray
hi Error guibg=drew_bloodred guifg=drew_ltgray
hi IncSearch guibg=drew_tan guifg=drew_darkgray
hi ModeMsg gui=bold
hi StatusLine gui=reverse,bold
hi StatusLineNC gui=reverse
hi VertSplit guibg=drew_ltgray
hi Visual gui=reverse guifg=NONE guibg=NONE
hi VisualNOS gui=underline,bold
hi DiffText gui=bold guibg=Red
hi Cursor guibg=NONE guifg=NONE gui=inverse
hi lCursor guibg=drew_cyan guifg=NONE
hi Directory guifg=Blue
hi LineNr guifg=drew_babyyellow
hi MoreMsg gui=bold guifg=SeaGreen
hi NonText gui=bold guifg=grey10 guibg=Black
hi Question gui=bold guifg=SeaGreen
hi Search guibg=drew_babyyellow guifg=drew_darkgray gui=none
hi CurSearch guibg=drew_babyyellow guifg=drew_almostblack gui=bold
hi SpecialKey guifg=Blue
hi Title gui=bold guifg=Magenta
hi WarningMsg guifg=Red
hi WildMenu guibg=Cyan guifg=Black
hi Folded guibg=DarkBlue guifg=Grey
hi FoldColumn guibg=Grey guifg=DarkBlue
hi DiffAdd guibg=LightBlue
hi DiffChange guibg=LightMagenta
hi DiffDelete gui=bold guifg=Blue guibg=LightCyan

hi Comment guifg=drew_skyblue
hi SpecialComment guifg=drew_cyan
hi Constant guifg=drew_cyan
hi PreProc guifg=drew_magenta guibg=Black ctermfg=DarkMagenta
hi Statement gui=NONE guifg=drew_red
hi Special guifg=#BB00BB guibg=Black ctermfg=Yellow
hi Ignore guifg=Grey
hi Identifier guifg=drew_blue
hi Type guifg=drew_green gui=NONE

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

hi vimLet guifg=css_teal
hi vimHightlight guifg=drew_orange
hi vimGroup guifg=drew_blue
hi vimHiGui guifg=drew_mtdew
hi vimHiGuiFgBg guifg=drew_mtdew
hi vimHiCterm guifg=drew_mtdew
hi vimHiCtermFgBg guifg=drew_mtdew
hi vimHiCtermColor guifg=drew_firebrick
hi vimHiAttrib guifg=drew_firebrick

" hi pythonComment guifg=drew_skyblue
" hi pythonFunction guifg=drew_blue
" hi pythonNumber guifg=drew_cyan

hi Function gui=NONE guifg=drew_cyan cterm=NONE ctermfg=Blue
hi pythonFunction gui=NONE guifg=drew_ltblue ctermfg=LightBlue
hi pythonStatement gui=NONE guifg=drew_orange ctermfg=Brown
hi pythonException gui=NONE guifg=drew_babyyellow ctermfg=Yellow
hi pythonRepeat gui=NONE guifg=drew_babyyellow ctermfg=Yellow
hi pythonConditional gui=NONE guifg=drew_babyyellow ctermfg=Yellow
hi pythonDecorator gui=NONE guifg=drew_orange ctermfg=Brown
hi pythonDottedName gui=NONE guifg=drew_ltblue ctermfg=LightBlue
hi pythonDot gui=NONE guifg=drew_orange ctermfg=Brown
hi pythonRawString guifg=drew_cyan
hi pythonString gui=NONE guifg=drew_pink ctermfg=DarkMagenta
hi pythonUniString guifg=drew_firebrick
hi pythonUniEscape guifg=drew_aqua
hi pythonOperator gui=NONE guifg=drew_babyyellow
hi pythonOperatorSyms gui=bold guifg=drew_babyyellow
hi foldcolumn guibg=NONE guifg=NONE
hi SignColumn guibg=drew_darkgray guifg=drew_red
hi pythonBuiltinFunc guifg=drew_babyyellow
hi pythonPreCondit guifg=drew_orange
hi pythonDocTest guifg=drew_skyblue
hi pythonDocTest2 guifg=drew_skyblue

hi rubyBoolean gui=NONE guifg=drew_watermelon ctermfg=LightRed
hi rubySymbol gui=NONE guifg=drew_puke ctermfg=Brown
hi rubyString gui=NONE guifg=drew_firebrick ctermfg=DarkRed
hi rubyInteger gui=NONE guifg=drew_aqua ctermfg=DarkCyan
hi rubyConstant gui=NONE guifg=drew_ltblue ctermfg=Blue
hi rubyInterpolationDelimiter gui=NONE guifg=drew_babyyellow ctermfg=Yellow
hi rubyRailsUserClass gui=NONE guifg=drew_ltblue ctermfg=LightBlue
hi rubyPseudoVariable gui=NONE guifg=drew_mtdew ctermfg=LightGreen
hi rubyConditional guifg=drew_babyyellow ctermfg=Yellow
hi rubyExceptional guifg=drew_orange ctermfg=Brown
hi rubyAccess guifg=drew_birchwood ctermfg=Brown
hi rubyDefine guifg=drew_orange ctermfg=Brown
hi rubyClass guifg=drew_mtdew ctermfg=LightGreen
hi rubyModule guifg=drew_watermelon ctermfg=LightRed
hi rubyRailsTestMethod guifg=drew_purple

hi goBlock           guifg=drew_babyyellow  ctermfg=Yellow
hi goBoolean         guifg=drew_pink
hi goDeclaration     guifg=drew_mtdew       ctermfg=LightGreen
hi goDeclType        guifg=drew_green       ctermfg=LightGreen
hi goDirective       guifg=drew_magenta     ctermfg=Magenta
hi goFormatSpecifier guifg=drew_babyyellow  ctermfg=Yellow
hi goFunction        guifg=drew_ltblue      ctermfg=LightBlue
hi goMethod          guifg=drew_ltgray
hi goOperator        guifg=drew_puke        ctermfg=Yellow
hi goRepeat          guifg=drew_babyyellow  ctermfg=Yellow
hi goStatement       guifg=drew_orange      ctermfg=Brown
hi goString          guifg=drew_firebrick   ctermfg=DarkRed
hi goStructDef       guifg=drew_ltblue      ctermfg=LightBlue
hi goType            guifg=drew_green
hi goUnsignedInts    guifg=drew_green
hi link goStruct Normal



hi coffeeObject       guifg=drew_ltblue       ctermfg=LightBlue
hi coffeeObjAssign    guifg=drew_ltblue       ctermfg=LightBlue
hi coffeeSpecialOp    guifg=drew_ltgray       ctermfg=Yellow
hi coffeeExtendedOp   guifg=drew_babyyellow   ctermfg=Brown
hi coffeeParensParen  guifg=drew_tan          ctermfg=Brown
hi coffeeBooleanTrue  guifg=drew_neongreen    ctermfg=LightGreen
hi coffeeBooleanFalse guifg=drew_watermelon   ctermfg=LightRed
hi coffeeSpecialIdent guifg=drew_grayishblue  ctermfg=LightGray
hi coffeeRegex        guifg=drew_tan          ctermfg=Brown

hi javaScriptStatement cterm=NONE ctermfg=Brown gui=NONE guifg=drew_orange
hi javaScriptGlobalObjects guifg=drew_teal
hi javaScriptOpSymbols guifg=drew_babyyellow
hi javaScriptParens guifg=drew_tan ctermfg=Brown
hi javaScriptBraces guifg=drew_orange ctermfg=Yellow
hi javaScriptEndColons guifg=drew_ltblue
hi link javaScriptFuncArg Normal
hi javaScriptFuncKeyword gui=NONE guifg=drew_blue cterm=NONE ctermfg=Blue
hi javaScriptFuncDef gui=NONE guifg=drew_green cterm=NONE ctermfg=LightGreen
hi javaScriptFuncExp gui=NONE guifg=drew_green cterm=NONE ctermfg=LightGreen
hi javaScriptFuncComma guifg=drew_orange
hi javaScriptBoolean guifg=drew_skyblue ctermfg=Blue
hi javaScriptString guifg=drew_firebrick ctermfg=Red
hi javaScriptStringS guifg=drew_firebrick ctermfg=Red
hi javaScriptStringD guifg=drew_firebrick ctermfg=Red
hi javaScriptRegexpString guifg=drew_tan ctermfg=Brown
hi javaScriptNumber guifg=drew_cyan ctermfg=DarkCyan
hi javaScriptFloat guifg=drew_cyan ctermfg=DarkCyan

hi typescriptStringB guifg=drew_pink ctermfg=LightRed

hi markdownH1 guifg=drew_orange ctermfg=Yellow
hi markdownH2 guifg=drew_watermelon ctermfg=Yellow
hi markdownH3 guifg=drew_mtdew ctermfg=Yellow
hi markdownH4 guifg=drew_pink ctermfg=Yellow
hi markdownH5 guifg=drew_cyan ctermfg=Yellow
hi markdownH6 guifg=drew_grayishblue ctermfg=Yellow
hi markdownCode guifg=drew_green ctermfg=LightGray ctermbg=DarkBlue
hi markdownCodeBlock guifg=drew_green ctermfg=LightGray ctermbg=DarkBlue
hi markdownHeadingDelimiter guifg=drew_darkgray ctermfg=LightGray
hi markdownHeadingRule guifg=drew_darkgray ctermfg=LightGray
hi markdownListMarker guifg=drew_puke ctermfg=Brown
hi markdownOrderedListMarker guifg=drew_puke ctermfg=Brown


hi Function gui=NONE guifg=drew_ltblue
hi Statement gui=NONE guifg=drew_orange
hi Exception gui=NONE guifg=drew_babyyellow
hi Repeat gui=NONE guifg=drew_babyyellow
hi Conditional gui=NONE guifg=drew_babyyellow
hi String gui=NONE guifg=drew_firebrick

hi javaParen guifg=drew_neongreen
hi javaParen1 guifg=drew_skyblue
hi javaParen2 guifg=drew_watermelon
hi javaTypedef guifg=drew_neongreen ctermfg=LightMagenta
hi javaType guifg=drew_watermelon ctermfg=LightGreen
hi javaMethodDecl guifg=drew_palepurple ctermfg=LightRed
hi javaString guifg=drew_firebrick ctermfg=DarkRed
hi javaConstant guifg=drew_aqua ctermfg=DarkCyan
hi javaScopeDecl guifg=drew_purple ctermfg=LightRed
hi javaClassDecl guifg=drew_mtdew ctermfg=LightGreen
hi javaClassName guifg=drew_graywood ctermfg=LightGray
hi javaIdentifier guifg=drew_graysky ctermfg=LightBlue
hi javaGeneric guifg=drew_neongreen ctermfg=LightGreen
hi javaLangClass guifg=drew_graywood ctermfg=Gray
hi javaAnnotation guifg=drew_puke ctermfg=Yellow
hi javaExternal guifg=drew_magenta ctermfg=DarkMagenta

hi jsonBoolean gui=NONE guifg=drew_skyblue ctermfg=LightBlue
hi jsonEscape gui=NONE guifg=drew_skyblue ctermfg=LightBlue
hi jsonKeywordMatch gui=NONE guifg=drew_babyyellow ctermfg=Yellow
hi jsonNoQuotes gui=reverse guifg=drew_red cterm=reverse ctermfg=Red
hi jsonNull gui=NONE guifg=drew_mtdew ctermfg=Yellow
hi jsonNumber gui=NONE guifg=drew_green ctermfg=Green
hi jsonQuote gui=NONE guifg=drew_red ctermfg=LightRed
hi jsonString gui=NONE guifg=drew_firebrick ctermfg=DarkRed
hi jsonBraces gui=NONE guifg=drew_babyyellow ctermfg=Yellow
hi jsonFold gui=NONE guifg=drew_purple ctermfg=Magenta
hi jsonKeywordRegion gui=NONE guifg=drew_orange ctermfg=Brown
hi jsonNoise gui=NONE guifg=drew_babyyellow ctermfg=Yellow
hi jsonPadding gui=NONE guifg=drew_purple ctermfg=Magenta
hi jsonStringSQ gui=NONE guifg=drew_red ctermfg=LightRed
hi jsonCommaError gui=reverse guifg=drew_red cterm=reverse ctermfg=LightRed
hi jsonCommentError gui=reverse guifg=drew_red cterm=reverse ctermfg=LightRed
hi jsonNumError gui=reverse guifg=drew_red cterm=reverse ctermfg=LightRed
hi jsonSemicolonError gui=reverse guifg=drew_red cterm=reverse ctermfg=LightRed

hi yamlKey gui=NONE guifg=drew_puke ctermfg=Brown
hi yamlDelimiter gui=NONE guifg=drew_puke ctermfg=Brown
hi yamlString gui=NONE guifg=drew_firebrick ctermfg=DarkRed
hi yamlNumber gui=NONE guifg=drew_green ctermfg=Green
hi yamlComment gui=NONE guifg=drew_ltgray ctermfg=Grey

"hi groovyExternal                  xxx links to Include
hi groovyError               gui=bold guifg=#fafafa guibg=#990000
"hi groovyConditional               xxx links to Conditional
"hi groovyRepeat                    xxx links to Repeat
hi groovyBoolean             gui=NONE guifg=drew_ltblue
"hi groovyConstant                  xxx links to Constant
hi groovyTypedef             gui=NONE guifg=drew_orange
hi groovyOperator            gui=NONE guifg=drew_babyyellow  
hi groovyType                gui=NONE guifg=drew_teal
hi groovyStatement           gui=NONE guifg=drew_orange
hi groovyStorageClass        gui=NONE guifg=drew_orange
hi groovyExceptions          gui=NONE guifg=drew_mtdew
hi groovyAssert              gui=NONE guifg=drew_orange
hi groovyMethodDecl          gui=NONE guifg=drew_orange
hi groovyClassDecl           gui=NONE guifg=drew_orange
"hi groovyBranch                    xxx links to Conditional
"hi groovyUserLabelRef              xxx links to groovyUserLabel
"hi groovyScopeDecl                 xxx links to groovyStorageClass
hi groovyLangClass           gui=NONE guifg=drew_watermelon
hi groovyJavaLangClass       gui=NONE guifg=drew_pink
hi groovyJavaLangObject      gui=NONE guifg=drew_pink
hi groovyJDKBuiltin          gui=NONE guifg=drew_mtdew
hi groovyJDKOperOverl        gui=NONE guifg=drew_mtdew
hi groovyJDKMethods          gui=NONE guifg=drew_mtdew
"hi groovyLabel                     xxx links to Label
hi groovyNumber              gui=NONE guifg=drew_aqua
hi groovyString              gui=NONE guifg=drew_firebrick
"hi groovyLabelRegion               xxx cleared
"hi groovyUserLabel                 xxx links to Label
"hi groovyError2                    xxx cleared
"hi groovyLangObject                xxx cleared
hi groovyTodo                gui=bold guifg=drew_babyyellow
"hi groovySpecial                   xxx links to Special
"hi groovySpecialChar               xxx links to SpecialChar
hi groovyComment             gui=NONE guifg=drew_ltgray
hi groovyStar                gui=NONE guifg=drew_ltgray
hi groovyLineComment         gui=NONE guifg=drew_ltgray
hi groovyCommentString       gui=NONE guifg=drew_ltgray
hi groovyComment2String      gui=NONE guifg=drew_ltgray
hi groovyCommentCharacter    gui=NONE guifg=drew_ltgray
"hi groovyCharacter                 xxx links to Character


hi CSVColumnEven          gui=NONE   guifg=drew_ltgray       guibg=drew_background
hi CSVColumnOdd           gui=NONE   guifg=drew_darkgray     guibg=drew_background
hi CSVColumnHeaderEven    gui=NONE   guifg=drew_watermelon
hi CSVColumnHeaderOdd     gui=NONE   guifg=drew_firebrick
hi CSVDelimiter           gui=NONE   guifg=drew_orange       guibg=drew_blue
"hi CSVComment             gui=NONE
"hi CSVHeaderLine          gui=NONE

hi Delimiter     gui=NONE   guifg=drew_babyyellow
hi shSetList     gui=NONE   guifg=drew_ltblue
hi shVariable    gui=NONE   guifg=drew_ltblue
hi shExpr        gui=NONE   guifg=drew_skyblue
hi shOption      gui=NONE   guifg=drew_mtdew
hi shCommandSub  gui=NONE   guifg=drew_babyyellow
hi shDerefSimple gui=NONE   guifg=drew_teal
hi shArithRegion gui=NONE   guifg=drew_teal

hi cssComment               gui=italic   guifg=drew_darkgray
hi cssIdentifier            gui=NONE   guifg=drew_blue
hi cssBraces                gui=NONE   guifg=drew_mtdew
hi cssTagName               gui=NONE   guifg=drew_orange
hi cssClassNameDot          gui=NONE   guifg=drew_ltblue
hi cssClassName             gui=NONE   guifg=drew_ltblue
hi cssPseudoClassId         gui=NONE   guifg=drew_peach
hi cssSelectorOp            gui=NONE   guifg=drew_mtdew
hi cssNoise                 gui=NONE   guifg=drew_palepurple
hi cssDefinition            gui=NONE   guifg=drew_birchwood
hi link cssFontProp         cssDefinition
hi link cssTextProp         cssDefinition
hi link cssBoxProp          cssDefinition
hi link cssPositioningProp  cssDefinition
hi link cssBorderProp       cssDefinition
hi link cssBackgroundProp   cssDefinition
hi link cssUIProp           cssDefinition
hi link cssDimensionProp    cssDefinition
hi link cssPageProp         cssDefinition
hi cssVendor                gui=NONE   guifg=drew_babyyellow
" hi cssDimensionProp         gui=NONE   guifg=
hi cssColor                 gui=NONE   guifg=drew_orange
hi cssImportant             gui=NONE   guifg=drew_pink
" hi cssAttrRegion            gui=NONE   guifg=
" hi cssCommonAttr            gui=NONE   guifg=
hi cssBackgroundAttr        gui=NONE   guifg=drew_watermelon
hi cssPositioningAttr       gui=NONE   guifg=drew_red
hi cssBoxAttr               gui=NONE   guifg=drew_red
hi cssUIAttr                gui=NONE   guifg=drew_red
hi cssGradientAttr          gui=NONE   guifg=drew_red
hi cssFunction              gui=NONE   guifg=drew_red
hi cssFunctionName          gui=NONE   guifg=drew_green
hi cssValueLength           gui=NONE   guifg=drew_watermelon
hi cssValueNumber           gui=NONE   guifg=drew_watermelon
hi cssUnitDecorators        gui=NONE   guifg=drew_red

hi dosiniLabel     gui=NONE guifg=drew_blue
hi dosiniHeader    gui=NONE guifg=drew_orange
hi dosiniNumber    gui=NONE guifg=drew_green
hi dosiniComment   gui=NONE guifg=drew_darkgray

highlight Pmenu      ctermfg=7  ctermbg=0  guibg=#444444 guifg=#dddddd
highlight PmenuSbar  ctermfg=7  ctermbg=7  guibg=#666666 guifg=#ffffff
highlight PmenuSel   ctermfg=1  ctermbg=7  guibg=#888888 guifg=#dd0000
highlight PmenuThumb ctermbg=14 ctermbg=14 guibg=#ffff00 guifg=#00ffff

hi NERDTreeOpenable   gui=NONE   guifg=drew_skyblue
hi NERDTreeClosable   gui=NONE   guifg=drew_skyblue
hi NERDTreeDir        gui=NONE   guifg=drew_peach

hi procProcName guifg=drew_salmon
hi procComment guifg=drew_ltgray

hi bashStatement ctermfg=DarkCyan
hi bashBlock ctermfg=Yellow
hi bashDo ctermfg=Yellow
hi bashComment ctermfg=Gray
hi bashDeref guifg=drew_firebrick ctermfg=DarkMagenta
hi link bashIdentifier Normal
hi bashHereDoc ctermfg=DarkGray
hi bashRedir ctermfg=Yellow
hi link bashCommandOpts Normal
hi bashOperator ctermfg=Brown
hi bashIf guifg=drew_babyyellow ctermfg=Yellow

hi link C89Identifier Normal
hi link c89Function Normal
hi c89Macro guifg=drew_tan
hi cCMacro guifg=drew_tan
hi c89Constant guifg=drew_aqua
hi cAnsiFunction guifg=drew_blue
hi cUserFunction guifg=drew_ltblue
hi link cCommentError Comment

hi CtrlPPrtCursor guifg=drew_mtdew

highlight GBufExHeader guifg=drew_blue ctermfg=blue
highlight GBufExHeaderGroupKey guifg=drew_orange ctermfg=lightred
highlight GBufExBufNr guifg=drew_purple ctermfg=blue
highlight GBufExDirname guifg=drew_birchwood ctermfg=brown
highlight GBufExBasename guifg=drew_tan ctermfg=yellow


highlight rustModPath guifg=drew_slateblue ctermfg=DarkGray
highlight rustTypeScope guifg=drew_slateblue ctermfg=DarkGray
highlight rustConstant guifg=drew_green ctermfg=LightGreen
highlight rustQuestionMark guifg=drew_salmon ctermfg=Brown gui=bold
highlight rustSigil guifg=drew_watermelon ctermfg=LightRed gui=none
highlight rustOperator guifg=drew_babyyellow ctermfg=Yellow


highlight rustIdentifierTypeLevel guifg=drew_green ctermfg=Green
highlight rustIdentifierValueLevel guifg=drew_ltgray ctermfg=Blue
highlight rustPathIdentifierTypeLevel guifg=drew_slategreen ctermfg=LightBlue
highlight rustPathIdentifierValueLevel guifg=drew_slateblue ctermfg=DarkGreen
highlight rustPathSpecialSegment guifg=drew_darkgray ctermfg=brown gui=italic

highlight rustEnumVariantDecl guifg=drew_slateblue ctermfg=Gray
highlight rustEnumVariantArgsDecl guifg=drew_darkgray ctermfg=DarkGray

highlight rustStructMemberValueLevel guifg=drew_slateblue ctermfg=LightBlue
highlight rustStructMemberTypeLevel guifg=drew_slategreen ctermfg=LightBlue
highlight rustStructMemberType guifg=drew_slategreen ctermfg=LightBlue

highlight brsKeyword guifg=drew_orange
highlight brsType guifg=drew_green
highlight brsComment guifg=darkgray
highlight brsOperator guifg=drew_babyyellow
