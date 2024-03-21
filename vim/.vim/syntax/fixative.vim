
syn clear

syn match fixativeInputSep /^---$/
syn match fixativeHyperEndSep /^\^\^\^/
syn match fixativeHyperCopy /[{].\{-1,}[}]/

highlight link fixativeInputSep Comment
highlight link fixativeHyperEndSep Comment
highlight link fixativeHyperCopy Identifier

