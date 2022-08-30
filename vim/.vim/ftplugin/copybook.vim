vim9script

command! CopybookGoToFirstSegment normal gg<CR>/^\s\+\01\s<CR>
nnoremap gs :CopybookGoToFirstSegment<CR>

highlight copybookComment ctermfg=grey guifg=drew_darkgray
highlight copybookCommentEol ctermfg=grey guifg=drew_darkgray
highlight copybookRedefine ctermfg=brown guifg=drew_orange
highlight copybookRepeat ctermfg=brown guifg=drew_orange
highlight copybookValues ctermfg=brown guifg=drew_orange
highlight copybookIndex ctermfg=green guifg=drew_green
highlight copybookEol ctermfg=red guifg=drew_watermelon
highlight copybookPic ctermfg=green guifg=drew_mtdew
highlight copybookItemLevel ctermfg=brown guifg=drew_orange
highlight copybookItemName ctermfg=blue guifg=drew_ltblue
