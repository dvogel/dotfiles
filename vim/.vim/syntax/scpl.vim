runtime colors/lists/csscolors.vim

" syn match scplNote "\[.\+\]"
syn match scplSlugline "^[A-Z0-9 .]\+$"
" syn match scplAction "^[A-Z]\+.*$"
" syn match scplDialog "^\s\{12\}.*$"

let v:colornames["pleasant_green"] = "#309030"
" highlight scplNote     guifg=#c05050
highlight scplSlugline guifg=#c0a0c0 gui=bold
highlight scplAction   guifg=#c0a0c0
highlight scplDialog   guifg=#a0a020

syn sync fromstart
syn region scplDialog matchgroup=scplDialogHeader start="\[[a-zA-Z. ]\+\]" end="^\["me=s-1 contains=scplDialogTextBold,scplDialogTextItalic,scplDialogText,scplDirection
syn match scplDialogText "[^\[ ]\+" contained
syn match scplDialogTextBold "\*\*[^*]\+\*\*" contained
syn match scplDialogTextItalic "_[^_]\+_" contained

syn region scplDirection start="^\w\+:" end="$"he=e+1 contains=scplTodo,scplDirPrefix,scplDirText
syn match scplDirPrefix "\(action\|aside\|effect\|note\):" contained nextgroup=scplDirText
syn match scplDirText "(<?:)[a-zA-Z0-9.,' \t]\+" contained
syn match scplTodo "\(todo\|TODO\):.*$" contained

highlight scplTodo guifg=css_gold gui=bold
highlight scplDirPrefix guifg=#c05050 gui=bold
highlight scplDirection guifg=css_dimgrey gui=NONE
highlight scplDialogText guifg=css_lightgrey
highlight scplDialogTextItalic guifg=css_lightgrey gui=italic
highlight scplDialogTextBold guifg=css_lightgrey gui=bold
highlight scplDialogHeader guifg=css_goldenrod
