vim9script

import "base64.vim"

def InvertDict(subj: dict<any>): dict<any>
    var newSubj = {}
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
        var segmentJson = base64.Base64Decode(segment64)
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

def SlurpOutput(): list<string>
    var sepLineNum = FindBufferSeparatorLine()
    if sepLineNum == -1
        return []
    endif
    return getline(sepLineNum + 3, '$')
enddef

def ReplaceInputWithLines(newInputLines: list<string>): void
    var sepLineNum = FindBufferSeparatorLine()
    if sepLineNum == -1
        return
    endif
    deletebufline(bufnr(), 1, sepLineNum - 1)
    append(0, newInputLines)
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

def RedrawActionBar(lineNum: number, inputTypes: list<string>): void
    var actions = []

    for type in inputTypes
        if type == "jwt"
            add(actions, "[Decode As Jwt]")
            add(actions, "[Encode As Base64]")
        endif
    endfor

    extend(actions, [
        "[From Clipboard]",
        "[To Clipboard]",
        "[Promote Output]"
    ])

    setline(lineNum, join(actions, " / "))
    setline(lineNum + 1, "---")
enddef

def UpdateBufferWith(startLineNum: number, newLines: list<string>)
    var lineNum = startLineNum 
    for ln in newLines
        setline(lineNum, ln)
        lineNum += 1
    endfor
enddef

def IdentifyInputTypes(input: string): list<string>
    var accum = []

    if matchstr(input, '\v[a-z]+://', 0) != ""
        add(accum, "url")
    endif

    if strcharpart(input, 0, 3) == "eyJ"
        add(accum, "jwt")
    endif

    if matchstr(input, '\v^[-_A-Za-z0-9]+[=]{0,3}$') != ""
        add(accum, "base64")
    elseif matchstr(input, '\v([-_A-Za-z0-9]{76}\n)+([-_A-Za-z0-9]{0,76})[=]{0,3}') != ""
        add(accum, "base64")
    endif

    return accum
enddef

def UpdateBufferAsUrl(input: string, firstLine: number): void
    var parsedUrl = ParseUrl(input)
    if get(parsedUrl, "scheme") != ""
        var urlLines = FormatUrlLines(parsedUrl)

        add(urlLines, "^^^")
        add(urlLines, "Updated: " .. strftime("%c", localtime()))

        UpdateBufferWith(firstLine, urlLines)
        return
    endif
enddef

def UpdateBufferAsJwt(input: string, firstLine: number): void
    var parsedJwt = ParseJwt(input)
    UpdateBufferWith(firstLine, parsedJwt)
enddef

def UpdateBufferAsBase64(input: string, firstLine: number): void
    UpdateBufferWith(firstLine, [base64.Base64Decode(input)])
enddef

def UpdateBufferByType(input: string, firstLine: number, type: string): void
    if type == "url"
        UpdateBufferAsUrl(input, firstLine)
    elseif type == "jwt"
        UpdateBufferAsJwt(input, firstLine)
    elseif type == "base64"
        UpdateBufferAsBase64(input, firstLine)
    endif
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
    var inputTypes = IdentifyInputTypes(input)
    RedrawActionBar(sepLineNum + 1, inputTypes)
    if len(inputTypes) > 0
        UpdateBufferByType(input, sepLineNum + 3, inputTypes[0])
    elseif input == ""
        UpdateBufferWith(sepLineNum + 3, ["Input is empty."])
    else
        UpdateBufferWith(sepLineNum + 3, ["Could not identify input type."])
    endif
enddef

def MaybeUpdateBuffer()
    if BufferIsEmpty()
        setline(1, "---")
        UpdateBuffer()
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
    elseif synName == "fixativeHyperAction"
        var actionName = ActionNameUnderCursor()
        if actionName == "[From Clipboard]"
            ReplaceInputWithLines(getreg('+', 1, v:true))
            UpdateBuffer()
        elseif actionName == "[To Clipboard]"
            setreg('+', SlurpInput())
            echo "Copied to clipboard"
        elseif actionName == "[Promote Output]"
            var output = SlurpOutput()
            if output == []
                echomsg "No output found in the current buffer."
            else
                ReplaceInputWithLines(output)
                UpdateBuffer()
            endif
        elseif actionName == "[Encode As Base64]"
            var input = SlurpInput()
            var newInput = base64.Base64Encode(input)
            ReplaceInputWithLines([newInput])
            UpdateBuffer()
        endif
    endif
enddef

def ActionNameUnderCursor(): string
    var lineText = getline('.')
    var cursorPos = getpos('.')
    var cursorCol = cursorPos[2]

    var beginOffset = cursorCol
    while beginOffset > 0 && lineText[beginOffset] != "["
        beginOffset -= 1
    endwhile

    var endOffset = cursorCol
    while endOffset < len(lineText) && lineText[endOffset] != "]"
        endOffset += 1
    endwhile

    if lineText[beginOffset] == "[" && lineText[endOffset] == "]"
        return strcharpart(lineText, beginOffset, endOffset - beginOffset + 1)
    else
        echomsg "Could not find hyper action text markers '[' and ']'"
        return ""
    endif
enddef

def BufferIsEmpty(): bool
    if line('$') == 1 && getline(1) == ""
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

command! -buffer FixativeUpdateBuffer :call UpdateBuffer()
command! -nargs=1 -complete=customlist,ComplOptFixativeAuto FixativeAuto :call SetOptFixativeAuto(<q-args>)

augroup Fixative
    autocmd!
    autocmd BufEnter,WinEnter [Fixative Buffer] call MaybeUpdateBuffer()
augroup END

def MarkInput(): void
    var sepLineNum = FindBufferSeparatorLine()
    if sepLineNum > 1
        var lastLineLen = len(getline(sepLineNum - 1))
        setpos("'<", [bufnr(), 1, 1, 0])
        setpos("'>", [bufnr(), sepLineNum - 1, lastLineLen, 0])
        normal gv
    endif
enddef

nmap <buffer> I :call <SID>MarkInput()<CR>
omap <buffer> I :<C-U>call <SID>MarkInput()<CR>
nmap <C-S-f> :set filetype=fixative<CR>
nmap <C-S-c> :call <SID>UpdateBufferFromClipboard()<CR>
nmap <S-Return> :call <SID>HyperAction()<CR>
nmap <Tab> /\[\zs.\{-1,\}\ze\]<CR>

MaybeUpdateBuffer()

