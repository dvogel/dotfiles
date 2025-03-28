vim9script

export def AppendOption(optName: string, optValue: string)
    var cmd = "set " .. optName .. "+=" .. optValue
    execute cmd
enddef

export def AppendAutoCompleteFilePathIfExists(filePath: string)
    if filereadable(filePath)
        appendoption#AppendOption("complete", "k" .. filePath)
    endif
enddef

defcompile
