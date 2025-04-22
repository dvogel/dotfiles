vim9script

export def PrettyPrint(val: any): void
    echo PrettyFormat(val)
enddef

export def PrettyFormat(val: any): string
    var accum: list<string> = []
    PrettyFormatIndent(accum, "", v:false, val)
    return join(accum, "")
enddef

def PrettyFormatIndent(accum: list<string>, indent: string, skipFirstIndent: bool, val: any): void
    if type(val) == v:t_none || type(val) == v:t_bool || type(val) == v:t_number || type(val) == v:t_float
        if !skipFirstIndent
            add(accum, indent)
        endif
        add(accum, string(val))
    elseif type(val) == v:t_string
        if !skipFirstIndent
            add(accum, indent)
        endif
        add(accum, '"' .. val .. '"')
    elseif type(val) == v:t_list
        if !skipFirstIndent
            add(accum, indent)
        endif
        add(accum, "[")
        for item in val
            add(accum, "\n")
            PrettyFormatIndent(accum, indent .. "  ", v:false, item)
            add(accum, ",")
        endfor
        if len(val) > 0
            add(accum, "\n")
        endif
        add(accum, indent)
        add(accum, "]")
    elseif type(val) == v:t_dict
        if !skipFirstIndent
            add(accum, indent)
        endif
        add(accum, "{")
        for [key, item] in items(val)
            add(accum, "\n")
            PrettyFormatIndent(accum, indent .. "  ", v:false, key)
            add(accum, ": ")
            PrettyFormatIndent(accum, indent .. "  ", v:true, item)
            add(accum, ",")
        endfor
        if len(val) > 0
            add(accum, "\n")
        endif
        add(accum, indent)
        add(accum, "}")
    else
        if !skipFirstIndent
            add(accum, indent)
        endif
        add(accum, indent)
        add(accum, "<" .. typename(val) .. ">")
    endif
enddef

