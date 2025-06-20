vim9script

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal smartindent
setlocal nowrap
setlocal fileformat=dos
setlocal nofixeol
setlocal noendofline
setlocal nobomb
setlocal commentstring=//\ %s

augroup CSharpAutocmds
    autocmd!
    autocmd BufEnter *.cs b:associated_files = FindAssociatedFiles()
augroup END

def FindAssociatedFiles(): list<string>
    var accum = []

    var altNamePatterns = []
    var currExt = fnamemodify(expand("%"), ":e") # should always be .cs
    var currNameWithoutExt = fnamemodify(expand("%"), ":t:r")
    var caps = matchlist(currNameWithoutExt, '\v(\w+)Tests')
    if caps == []
        add(altNamePatterns, [":t", currNameWithoutExt .. "Tests" .. "." .. currExt])
    else
        add(altNamePatterns, [":t", caps[1] .. "." .. currExt])
    endif

    var buffers = getbufinfo()
    for buf in buffers
        for [modflags, pat] in altNamePatterns
            var candidateName = fnamemodify(buf["name"], modflags)
            if match(candidateName, pat) > -1
                add(accum, buf["name"])
            endif
        endfor
    endfor

    return accum
enddef

g:FindAssociatedFiles = FindAssociatedFiles

command! -buffer SwitchToFirstAssociatedFile execute "buf " .. b:associated_files[0]
nmap <buffer> <C-a> :SwitchToFirstAssociatedFile<CR>