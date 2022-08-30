vim9script

syn match copybookEol '\zs[.]\ze.*$' skipnl skipempty skipwhite nextgroup=copybookItemLevel,copybookIndex,copybookPic
syn match copybookRedefine 'REDEFINES' skipwhite skipnl nextgroup=copybookItemName
syn match copybookIndex 'INDEXED BY [[:upper:]]\+\(-[[:upper:][:digit:]]\+\)*' skipwhite skipnl nextgroup=copybookPic
syn match copybookItemLevel '\s\+\zs\d\+\ze\s' skipwhite nextgroup=copybookItemName
syn match copybookPic 'PIC [X9]\+\((\d\+)\)\?\([.]\d\+-\?\)\?'
syn match copybookRepeat 'OCCURS\s\+\d\+\(\s\+TIMES\)\?' skipwhite skipnl nextgroup=copybookValues,copybookPic,copybookIndex
syn match copybookValues '\(VALUE SPACES\|VALUES \d\+ THRU \d\+\|VALUE[S]\?.*\(\s\+\'[^\']*\'\|\s\+\d\+\|\s\+THRU\)\+\|VALUE ZERO\)' skipwhite nextgroup=copybookPic
syn match copybookItemName '\s\zs[[:upper:]]\+\(-[[:upper:][:digit:]]\+\)*' skipwhite skipnl nextgroup=copybookPic,copybookRedefine,copybookRepeat,copybookValues
# syn region copybookComment start='\*' end='\*' contains=NONE
syn match copybookComment "\*.*\*"
syn match copybookCommentEol "\*[^*]*$"

highlight link copybookComment Comment
highlight link copybookCommentEol Comment

b:current_syntax = "copybook"
