setlocal commentstring=//\ %s
let b:clrzr_exempt = v:true

compiler gcc
setlocal errorformat^=%f:%l:(%*[^)]):%m
setlocal errorformat^=/usr/bin/ld:\ %f:%l:(%*[^)]):%m
setlocal errorformat^=%-G/usr/bin/ld:\ %f.o:\ in\ function\ %m

setlocal errorformat^=%-GStarting\ make\ in%m
setlocal errorformat^=%-GIf\ there\ are\ problems%m
setlocal errorformat^=%-G%*\\a[%*\\d]:\ Nothing\ to\ be\ done\ for\ %m
setlocal errorformat^=%-Ggcc\ %m
setlocal errorformat^=%-Gmake%.%#Error\ %n
setlocal errorformat+=%-G%m

" setlocal errorformat^=%-G%*\\a[%*\\d]:\ Entering\ directory\ %*[`']%f'
" setlocal errorformat^=%-G%*\\a[%*\\d]:\ Leaving\ directory\ %*[`']%f'
" setlocal errorformat^=%-G%*\\a:\ Entering\ directory\ %*[`']%f'
" setlocal errorformat^=%-G%*\\a:\ Leaving\ directory\ %*[`']%f'


