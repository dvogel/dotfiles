setlocal shiftwidth=2
setlocal tabstop=2
setlocal expandtab
setlocal nowrap
setlocal commentstring=//\ %s

let s:completeOpts = ".,w,b,u,t,i"
let s:awsActionsFile = expand("<sfile>:h") .. "/aws-actions-ref.txt"
if filereadable(s:awsActionsFile)
    let s:completeOpts ..= ",k" .. s:awsActionsFile
endif
execute "setlocal complete=" .. s:completeOpts
