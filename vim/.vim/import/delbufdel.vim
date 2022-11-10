vim9script

export def DelicatelyDeleteBuffer(): void
	var byeNr = bufnr()
    var bufcount = len(getbufinfo({'buflisted': true}))
    if bufcount == 0
        # there is no current buffer
    elseif bufcount == 1
        bdelete
    else
        var buflist = getbufinfo({'buflisted': true})
        filter(buflist, (idx, bufObj) => len(bufObj.windows) == 0)
        sort(buflist, (a, b) => a.lastused - b.lastused)
        if len(buflist) == 0
            echo "No buffers to switch to."
        else
            execute "buffer! " .. buflist[0].bufnr
            if bufnr('#') >= 0 && bufnr('#') != buflist[0].bufnr && buflisted(bufnr('#')) == 1
                execute "bdelete " .. byeNr
            endif
        endif
    endif
enddef

export def DeleteBuffersMatching(globPat: string): void
    var pattern = glob2regpat(globPat)
	var count = 0
    for bufObj in getbufinfo()
        if match(bufObj.name, pattern) >= 0
			execute "bdelete " .. bufObj.bufnr
			count = count + 1
        endif
    endfor
	if count > 0
		echomsg "Deleted " .. count .. " buffers matching " .. globPat
	endif
enddef

defcompile

