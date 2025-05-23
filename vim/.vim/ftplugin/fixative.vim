vim9script

def InvertDict(subj: dict<any>): dict<any>
    var newSubj: dict<any> = {}
    for k in keys(subj)
        newSubj[subj[k]] = k
    endfor
    return newSubj
enddef

var optFixativeAuto = false

var percentMapping = {
    ':': "%3A",
    '/': "%2F",
    '?': "%3F",
    '#': "%23",
    '[': "%5B",
    ']': "%5D",
    '@': "%40",
    '!': "%21",
    '$': "%24",
    '&': "%26",
    "'": "%27",
    '(': "%28",
    ')': "%29",
    '*': "%2A",
    '+': "%2B",
    ',': "%2C",
    ';': "%3B",
    '=': "%3D",
    '%': "%25",
    ' ': "%20",
}

var percentInverseMapping = InvertDict(percentMapping)

def PercentDecode(subj: string): string
    var decoded = ""
    const modeCopy = 1
    const modeDecode = 2
    var mode = modeCopy
    var decodeIdx = 0
    var idx = 0
    while idx < len(subj)
        var ch = subj[idx]
        if mode == modeCopy
            if ch == "%"
                mode = modeDecode
                decodeIdx = idx
            else
                decoded ..= ch
            endif
        elseif mode == modeDecode
            if idx == decodeIdx + 2
                var encoded = subj[idx - 2 : idx]
                var decCh = get(percentInverseMapping, encoded, "")
                if decCh == ""
                    echoerr "Error percent-decoding string: " .. encoded
                    return ""
                endif
                decoded ..= decCh
                mode = modeCopy
            endif
        else
            echoerr "We are forsaken for logic is gone."
            return ""
        endif
        idx += 1
    endwhile
    return decoded
enddef

def TakePattern(subj: string, pat: string, ltrimLen: number, rtrimLen: number): list<string>
    var matched = matchstr(subj, '^' .. pat, 0)
    if matched == ""
        return ["", subj]
    else
        return [matched[0 + ltrimLen : -1 - rtrimLen], subj[len(matched) : ]]
    endif
enddef

def TakeScheme(url: string): list<string>
    return TakePattern(url, '[a-z][a-z0-9]*:', 0, 0)
enddef

def TakeHost(url: string): list<string>
    return TakePattern(url, '//[^:/]\+', 2, 0)
enddef

def TakePort(url: string): list<string>
    return TakePattern(url, ':[^/]\+', 1, 0)
enddef

def TakePath(url: string): list<string>
    return TakePattern(url, '/[^?#]*', 0, 0)
enddef

def TakeQuery(url: string): list<string>
    return TakePattern(url, '[?][^#]*', 0, 0)
enddef

def TakeFragment(url: string): list<string>
    return TakePattern(url, '[#].\+', 0, 0)
enddef

def ParseQueryString(qs: string): dict<string>
    var parts = split(substitute(qs, '^?', '', ''), '&')
    var accum = {}
    for part in parts
        # var kvrest = split(part, '=')
        # accum[kvrest[0]] = kvrest[1]
        var [k, v] = split(part, '=')
        accum[k] = PercentDecode(v)
    endfor
    return accum
enddef

def ParseUrl(url: string): dict<string>
    var [scheme, rest] = TakeScheme(url)
    var [host, rest1] = TakeHost(rest)
    var [port, rest2] = TakePort(rest1)
    var [path, rest3] = TakePath(rest2)
    var [query, rest4] = TakeQuery(rest3)
    var [fragment, rest5] = TakeFragment(rest4)
    return {
        "scheme": scheme,
        "host": host,
        "port": port,
        "path": path,
        "query": query,
        "fragment": fragment,
        "rest": rest5
    }
enddef

def FormatUrlLines(url: dict<string>): list<string>
    var lines = []
    add(lines, "{scheme}:      " .. get(url, "scheme", "<missing>"))
    add(lines, "{host}:        " .. get(url, "host", "<missing>"))
    add(lines, "{port}:        " .. get(url, "port", "<missing>"))
    add(lines, "{path}:        " .. get(url, "path", "<missing>"))
    add(lines, "╰─{decpath}:   " .. PercentDecode(get(url, "path", "")))
    add(lines, "{query}:       " .. get(url, "query", "<missing>"))
    add(lines, "╰─{decquery}:  " .. PercentDecode(get(url, "query", "")))

    var queryParams = ParseQueryString(get(url, "query", ""))
    for k in keys(queryParams)
        add(lines, "               ╰─{" .. k .. "}: " .. queryParams[k])
    endfor
    add(lines, "{fragment}:    " .. get(url, "fragment", "<missing>"))
    add(lines, "{rest}:        " .. get(url, "rest", "<none>"))
    return lines
enddef

def TakeJwtSegment(input: string): list<string>
    return TakePattern(input, '[^.]\+', 0, 0)
enddef

def PadBase64String(input: string): string
    var rem = len(input) % 4
    if rem == 3
        return input .. "="
    elseif rem == 2
        return input .. "=="
    else
        return input
    endif
enddef

def DecodeBase64String(input: string): string
    return system('echo "' .. PadBase64String(input) .. '" | base64 -d -')
enddef

def ParseJwt(input: string): list<string>
    var accum = []
    var subject = input

    while true
        if len(subject) == 0
            break
        endif

        var [_, rest] = TakePattern(subject, '[.]\+', 0, 0)
        var [segment64, rest1] = TakeJwtSegment(rest)
        add(accum, segment64)
        var segmentJson = DecodeBase64String(segment64)
        try
            var segmentData = json_decode(segmentJson)
            if type(segmentData) == v:t_dict
                add(accum, segmentJson)
            endif
        catch /E491/
            add(accum, "WARNING: non-JSON segment")
        endtry

        subject = rest1
    endwhile

    return accum
enddef

def SlurpInput(): string
    var slurped = []
    var sepLineNum = FindBufferSeparatorLine()
    if sepLineNum == -1
        return ""
    endif

    for lineNum in range(1, sepLineNum - 1)
        add(slurped, getline(lineNum))
    endfor
    return join(slurped, "\n")
enddef

def FindBufferSeparatorLine(): number
    var lineNum = 1
    var lastLineNum = line("$")
    while lineNum <= lastLineNum
        var ln = getline(lineNum)
        if ln == "---"
            return lineNum
        endif
        lineNum += 1
    endwhile

    return -1
enddef

def UpdateBufferWith(startLineNum: number, newLines: list<string>)
    var lineNum = startLineNum 
    for ln in newLines
        setline(lineNum, ln)
        lineNum += 1
    endfor
enddef

def UpdateBuffer()
    var sepLineNum = FindBufferSeparatorLine()
    if sepLineNum == -1
        echoerr "No '---' separator found."
        return
    endif

    normal gg
    search("^---")
    if line("$") > line(".")
        normal j
        normal dG
    endif

    var input = SlurpInput()
    var parsedUrl = ParseUrl(input)
    if get(parsedUrl, "scheme") != ""
        var urlLines = FormatUrlLines(parsedUrl)

        add(urlLines, "^^^")
        add(urlLines, "Updated: " .. strftime("%c", localtime()))

        UpdateBufferWith(sepLineNum + 1, urlLines)
        return
    endif

    if strcharpart(input, 0, 3) == "eyJ"
        var parsedJwt = ParseJwt(input)
        UpdateBufferWith(sepLineNum + 1, parsedJwt)
        return
    endif
enddef

def MaybeUpdateBuffer()
    if BufferIsEmpty()
        return
    endif
    if optFixativeAuto
        UpdateBuffer()
    endif
enddef

def HyperAction(): void
    var synId = get(synstack(line("."), col(".")), -1)
    var synName = synIDattr(synId, "name")
    if synName == "fixativeHyperCopy"
        var ln = getline(line("."))
        var val = substitute(ln, '^.*[{].*[}]:[ \t]\+', '', '')
        if val == ""
            echo "Ignoring empty field. Clipboard was not changed."
        else
            @+ = val
            echo "Copyied '" .. val .. "' to clipboard."
        endif
    endif
enddef

def BufferIsEmpty(): bool
    if getline('$') > 1 && line(1) == ""
        return v:true
    endif

    return v:false
enddef

def UpdateBufferFromClipboard(): void
    normal ggdG
    normal O
    normal "+P
    normal o---
    UpdateBuffer()
enddef

def EchoHyper()
    echo "HYPER"
enddef

def ComplOptFixativeAuto(argLead: string, cmdLine: string, cursorPos: number): list<string>
    return ["on", "off"]
enddef

def SetOptFixativeAuto(newSetting: string)
    if newSetting == "on"
        optFixativeAuto = true
    elseif newSetting == "off"
        optFixativeAuto = false
    else
        echoerr "Must be one of: on, off"
    endif
enddef

command! FixativeBuffer :call UpdateBuffer()
command! -nargs=1 -complete=customlist,ComplOptFixativeAuto FixativeAuto :call SetOptFixativeAuto(<q-args>)

augroup Fixative
    autocmd!
    autocmd BufEnter,WinEnter [Fixative Buffer] call MaybeUpdateBuffer()
augroup END

nmap <C-S-f> :e!<CR>
nmap <C-S-c> :call <SID>UpdateBufferFromClipboard()<CR>
nmap <S-Return> :call <SID>HyperAction()<CR>

UpdateBuffer()

