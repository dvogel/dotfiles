syn case ignore

syn keyword brsKeyword for step to while
syn keyword brsKeyword if then else
syn keyword brsKeyword function sub end as return print
syn keyword brsType boolean object string void
syn match brsOperator /[-=+*/]/
syn match brsOperator /\w\zs[.]\ze\w/
syn region brsComment start=/'/ end=/$/
syn match brsLiteralStr /"\([^"]\+\|\\["]\)*"/
syn match brsLiteralNum /\d\+/
syn keyword brsLiteralBool true false

highlight link brsKeyword Keyword
highlight link brsOperator Operator
highlight link brsComment Comment
highlight link brsType Type
highlight link brsLiteralStr String
highlight link brsLiteralNum Number
highlight link brsLiteralBool Boolean

