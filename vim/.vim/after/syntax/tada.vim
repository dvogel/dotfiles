syn match tadaCodeSpan /[`][^`]\+[`]/ containedin=tadaListItem,tadaTodoItemComplete,tadaTodoItemDoing,tadaTodoItemPlanned
" start=/[`]/ end=/[`]/ skip=/[^`]/

highlight tadaCodeSpan guifg=drew_ltblue

