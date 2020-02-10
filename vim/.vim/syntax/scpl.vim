syn match scplNote "\[.\+\]"
syn match scplSlugline "^[A-Z0-9 .]\+$"
syn match scplAction "^[A-Z]\+.*$"
syn match scplDialog "^\s\{12\}.*$"

highlight scplNote     guifg=#c05050
highlight scplSlugline guifg=#c0a0c0 gui=bold
highlight scplAction   guifg=#c0a0c0
highlight scplDialog   guifg=#a0a020

