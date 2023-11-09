syn clear
syn match adocLink ~http[s]\?://[^ ]\{-}\ze\(:".\{-}"\)\?#~ nextgroup=adocLinkLabel
syn match adocLinkLabel ~:".\{-\}"~

highlight link adocLink Special
highlight link adocLinkLabel Literal
