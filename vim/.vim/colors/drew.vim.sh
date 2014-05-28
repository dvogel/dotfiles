#!/bin/bash
# vim: ft=vim

cd $(dirname $(readlink -f "$0"))

(cat | sed -r \
          -e 's/_cyan/#10b2c0/g' \
          -e 's/_aqua/#0e8f9b/g' \
          -e 's/_blue/#0e689d/g' \
         -e 's/_peach/#e39e58/g' \
          -e 's/_puke/#ebab6a/g' \
           -e 's/_tan/#c77624/g' \
          -e 's/_skin/#e3b07d/g' \
           -e 's/_red/#cb3725/g' \
    -e 's/_watermelon/#ee1122/g' \
     -e 's/_firebrick/#c53534/g' \
          -e 's/_pink/#cf2152/g' \
        -e 's/_purple/#b294bb/g' \
         -e 's/_green/#379f4d/g' \
     -e 's/_neongreen/#b3e46f/g' \
         -e 's/_khaki/#ad6d2b/g' \
         -e 's/_brown/#642e0e/g' \
        -e 's/_orange/#e35c0f/g' \
          -e 's/_teal/#126d67/g' \
         -e 's/_mtdew/#c6d80e/g' \
        -e 's/_ltblue/#208ec8/g' \
       -e 's/_skyblue/#9cd7eb/g' \
    -e 's/_babyyellow/#fbe572/g' \
     -e 's/_birchwood/#d9cd94/g' \
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

hi Todo gui=REVERSE,BOLD guifg=_firebrick guibg=_babyyellow

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

hi vimHightlight guifg=_orange
hi vimGroup guifg=_blue
hi vimHiGui guifg=_mtdew
hi vimHiGuiFgBg guifg=_mtdew
hi vimHiCterm guifg=_mtdew
hi vimHiCtermFgBg guifg=_mtdew
hi vimHiCtermColor guifg=_firebrick
hi vimHiAttrib guifg=_firebrick

" hi pythonComment guifg=_skyblue
" hi pythonFunction guifg=_blue
" hi pythonNumber guifg=_cyan

hi Function gui=NONE guifg=_cyan cterm=NONE ctermfg=Blue
hi pythonFunction gui=NONE guifg=_ltblue
hi pythonStatement gui=NONE guifg=_orange
hi pythonException gui=NONE guifg=_babyyellow
hi pythonRepeat gui=NONE guifg=_babyyellow
hi pythonConditional gui=NONE guifg=_babyyellow
hi pythonDecorator gui=NONE guifg=_orange
hi pythonDottedName gui=NONE guifg=_ltblue
hi pythonDot gui=NONE guifg=_orange
hi pythonRawString guifg=_cyan
hi pythonString gui=NONE guifg=_pink ctermfg=DarkMagenta
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

hi rubyBoolean gui=NONE guifg=_watermelon ctermfg=LightRed
hi rubySymbol gui=NONE guifg=_puke ctermfg=Brown
hi rubyString gui=NONE guifg=_firebrick ctermfg=DarkRed
hi rubyConstant gui=NONE guifg=_ltblue ctermfg=LightBlue
hi rubyRailsUserClass gui=NONE guifg=_ltblue ctermfg=LightBlue
hi rubyPseudoVariable gui=NONE guifg=_mtdew ctermfg=LightGreen
hi rubyConditional guifg=_babyyellow
hi rubyDefine guifg=_orange ctermfg=Brown
hi rubyClass guifg=_mtdew ctermfg=LightGreen
hi rubyModule guifg=_watermelon ctermfg=LightRed

hi javaScriptStatement cterm=NONE ctermfg=Brown gui=NONE guifg=_orange
hi javaScriptGlobalObjects guifg=_teal
hi javaScriptOpSymbols guifg=_babyyellow
hi javaScriptParens guifg=_tan ctermfg=Brown
hi javaScriptBraces guifg=_orange ctermfg=Yellow
hi javaScriptEndColons guifg=_ltblue
hi link javaScriptFuncArg Normal
hi javaScriptFuncKeyword gui=NONE guifg=_blue cterm=NONE ctermfg=Blue
hi javaScriptFuncDef gui=NONE guifg=_green cterm=NONE ctermfg=LightGreen
hi javaScriptFuncExp gui=NONE guifg=_green cterm=NONE ctermfg=LightGreen
hi javaScriptFuncComma guifg=_orange
hi javaScriptBoolean guifg=_skyblue ctermfg=Blue
hi javaScriptString guifg=_firebrick ctermfg=Red
hi javaScriptStringS guifg=_firebrick ctermfg=Red
hi javaScriptStringD guifg=_firebrick ctermfg=Red
hi javaScriptRegexpString guifg=_tan ctermfg=Brown
hi javaScriptNumber guifg=_cyan ctermfg=DarkCyan
hi javaScriptFloat guifg=_cyan ctermfg=DarkCyan

hi link markdownH1 Identifier
hi link markdownH2 Identifier
hi link markdownH3 Identifier
hi link markdownH4 Identifier
hi link markdownH5 Identifier
hi link markdownH6 Identifier
hi link markdownCode Function
hi link markdownCodeBlock Function
hi link markdownHeadingDelimiter Statement
hi link markdownHeadingRule Statement

hi Function gui=NONE guifg=_ltblue
hi Statement gui=NONE guifg=_orange
hi Exception gui=NONE guifg=_babyyellow
hi Repeat gui=NONE guifg=_babyyellow
hi Conditional gui=NONE guifg=_babyyellow
hi String gui=NONE guifg=_firebrick

hi jsonBoolean gui=NONE guifg=_skyblue ctermfg=LightBlue
hi jsonEscape gui=NONE guifg=_skyblue ctermfg=LightBlue
hi jsonKeywordMatch gui=NONE guifg=_babyyellow ctermfg=Yellow
hi jsonNoQuotes gui=reverse guifg=_red cterm=reverse ctermfg=Red
hi jsonNull gui=NONE guifg=_mtdew ctermfg=Yellow
hi jsonNumber gui=NONE guifg=_green ctermfg=Green
hi jsonQuote gui=NONE guifg=_red ctermfg=LightRed
hi jsonString gui=NONE guifg=_firebrick ctermfg=DarkRed
hi jsonBraces gui=NONE guifg=_babyyellow ctermfg=Yellow
hi jsonFold gui=NONE guifg=_purple ctermfg=Magenta
hi jsonKeywordRegion gui=NONE guifg=_orange ctermfg=Brown
hi jsonNoise gui=NONE guifg=_babyyellow ctermfg=Yellow
hi jsonPadding gui=NONE guifg=_purple ctermfg=Magenta
hi jsonStringSQ gui=NONE guifg=_red ctermfg=LightRed
hi jsonCommaError gui=reverse guifg=_red cterm=reverse ctermfg=LightRed
hi jsonCommentError gui=reverse guifg=_red cterm=reverse ctermfg=LightRed
hi jsonNumError gui=reverse guifg=_red cterm=reverse ctermfg=LightRed
hi jsonSemicolonError gui=reverse guifg=_red cterm=reverse ctermfg=LightRed

"hi groovyExternal                  xxx links to Include
hi groovyError               gui=bold guifg=#fafafa guibg=#990000
"hi groovyConditional               xxx links to Conditional
"hi groovyRepeat                    xxx links to Repeat
hi groovyBoolean             gui=NONE guifg=_ltblue
"hi groovyConstant                  xxx links to Constant
hi groovyTypedef             gui=NONE guifg=_orange
hi groovyOperator            gui=NONE guifg=_babyyellow  
hi groovyType                gui=NONE guifg=_teal
hi groovyStatement           gui=NONE guifg=_orange
hi groovyStorageClass        gui=NONE guifg=_orange
hi groovyExceptions          gui=NONE guifg=_mtdew
hi groovyAssert              gui=NONE guifg=_orange
hi groovyMethodDecl          gui=NONE guifg=_orange
hi groovyClassDecl           gui=NONE guifg=_orange
"hi groovyBranch                    xxx links to Conditional
"hi groovyUserLabelRef              xxx links to groovyUserLabel
"hi groovyScopeDecl                 xxx links to groovyStorageClass
hi groovyLangClass           gui=NONE guifg=_watermelon
hi groovyJavaLangClass       gui=NONE guifg=_pink
hi groovyJavaLangObject      gui=NONE guifg=_pink
hi groovyJDKBuiltin          gui=NONE guifg=_mtdew
hi groovyJDKOperOverl        gui=NONE guifg=_mtdew
hi groovyJDKMethods          gui=NONE guifg=_mtdew
"hi groovyLabel                     xxx links to Label
hi groovyNumber              gui=NONE guifg=_aqua
hi groovyString              gui=NONE guifg=_firebrick
"hi groovyLabelRegion               xxx cleared
"hi groovyUserLabel                 xxx links to Label
"hi groovyError2                    xxx cleared
"hi groovyLangObject                xxx cleared
hi groovyTodo                gui=bold guifg=_babyyellow
"hi groovySpecial                   xxx links to Special
"hi groovySpecialChar               xxx links to SpecialChar
hi groovyComment             gui=NONE guifg=_ltgray
hi groovyStar                gui=NONE guifg=_ltgray
hi groovyLineComment         gui=NONE guifg=_ltgray
hi groovyCommentString       gui=NONE guifg=_ltgray
hi groovyComment2String      gui=NONE guifg=_ltgray
hi groovyCommentCharacter    gui=NONE guifg=_ltgray
"hi groovyCharacter                 xxx links to Character


hi CSVColumnEven          gui=NONE   guifg=_ltgray       guibg=_background
hi CSVColumnOdd           gui=NONE   guifg=_darkgray     guibg=_background
hi CSVColumnHeaderEven    gui=NONE   guifg=_watermelon
hi CSVColumnHeaderOdd     gui=NONE   guifg=_firebrick
hi CSVDelimiter           gui=NONE   guifg=_orange       guibg=_blue
"hi CSVComment             gui=NONE
"hi CSVHeaderLine          gui=NONE

hi Delimiter     gui=NONE   guifg=_babyyellow
hi shSetList     gui=NONE   guifg=_ltblue
hi shVariable    gui=NONE   guifg=_ltblue
hi shExpr        gui=NONE   guifg=_skyblue
hi shOption      gui=NONE   guifg=_mtdew
hi shCommandSub  gui=NONE   guifg=_babyyellow
hi shDerefSimple gui=NONE   guifg=_teal
hi shArithRegion gui=NONE   guifg=_teal

hi cssComment               gui=italic   guifg=_darkgray
hi cssIdentifier            gui=NONE   guifg=_blue
hi cssBraces                gui=NONE   guifg=_mtdew
hi cssTagName               gui=NONE   guifg=_orange
hi cssClassNameDot          gui=NONE   guifg=_ltblue
hi cssClassName             gui=NONE   guifg=_ltblue
hi cssPseudoClassId         gui=NONE   guifg=_peach
hi cssSelectorOp            gui=NONE   guifg=_mtdew
hi cssNoise                 gui=NONE   guifg=_purple
hi cssDefinition            gui=NONE   guifg=_birchwood
hi link cssFontProp         cssDefinition
hi link cssTextProp         cssDefinition
hi link cssBoxProp          cssDefinition
hi link cssPositioningProp  cssDefinition
hi link cssBorderProp       cssDefinition
hi link cssBackgroundProp   cssDefinition
hi link cssUIProp           cssDefinition
hi link cssDimensionProp    cssDefinition
hi link cssPageProp         cssDefinition
hi cssVendor                gui=NONE   guifg=_babyyellow
" hi cssDimensionProp         gui=NONE   guifg=
hi cssColor                 gui=NONE   guifg=_orange
hi cssImportant             gui=NONE   guifg=_pink
" hi cssAttrRegion            gui=NONE   guifg=
" hi cssCommonAttr            gui=NONE   guifg=
hi cssBackgroundAttr        gui=NONE   guifg=_watermelon
hi cssPositioningAttr       gui=NONE   guifg=_red
hi cssBoxAttr               gui=NONE   guifg=_red
hi cssUIAttr                gui=NONE   guifg=_red
hi cssGradientAttr          gui=NONE   guifg=_red
hi cssFunction              gui=NONE   guifg=_red
hi cssFunctionName          gui=NONE   guifg=_green
hi cssValueLength           gui=NONE   guifg=_watermelon
hi cssValueNumber           gui=NONE   guifg=_watermelon
hi cssUnitDecorators        gui=NONE   guifg=_red



hi Pmenu      gui=NONE    guibg=Gray     guifg=Black      ctermbg=LightGray ctermfg=Black
hi PmenuSel   gui=NONE    guibg=Gray     guifg=Yellow     ctermbg=LightGray ctermfg=Black
hi PmenuSbar  gui=NONE    guibg=Magenta  guifg=Red        ctermbg=Magenta   ctermfg=Red
hi PmenuThumb gui=NONE    guibg=Magenta  guifg=Red        ctermbg=Magenta   ctermfg=Red

ENDOFSCHEME
wait

