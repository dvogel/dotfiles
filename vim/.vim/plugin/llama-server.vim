vim9script

var llamaChannel: any = v:null

if !exists('g:llamaLogBufNr')
    g:llamaLogBufNr = -1
endif

def g:ForgetLlamaChannel(ch: any): void
    if llamaChannel == ch || ch == v:null
        llamaChannel = v:null
    endif
enddef

def ParseEventDataLine(ln: string): any
    var strippedLine = substitute(
            substitute(ln, '[\r\n]\+', '', ''),
            '^data: ', '', '')
    try
        var parsed = json_decode(strippedLine)
        return parsed
    catch
        return strippedLine
    endtry
enddef

def g:ReceiveLlamaResponseLine(bufnr: number, ch: any, ln: string): void
    var bufList = getbufinfo(bufnr)
    if len(bufList) == 0
        ch_close(ch)
        return
    endif

    var bufAttrs = bufList[0]

    var responseValue = ParseEventDataLine(ln)
    var loggedText: any = v:null
    if type(responseValue) == v:t_string
        # no-op
    elseif type(responseValue) == v:t_dict
        loggedText = responseValue['choices'][0]['delta']['content']
    elseif type(responseValue) == v:t_none
        # no-op
    else
        # no-op
    endif

    if loggedText != v:null
        var currLines = getbufline(g:llamaLogBufNr, '$')
        var newLines = split(loggedText, "\n", 1)
        setbufline(g:llamaLogBufNr, '$', currLines[0] .. newLines[0])
        if len(newLines) > 1
            for newLine in newLines[1 : ]
                appendbufline(g:llamaLogBufNr, '$', newLine)
            endfor
        endif
    endif
enddef

def g:CreateNewLlamaLogBuffer(): void
    if g:llamaLogBufNr == -1
        new
        g:llamaLogBufNr = bufnr()
        nmap <buffer> <Esc> :close<CR>
        setlocal noswapfile
        setlocal buftype=nofile
        setlocal filetype=markdown
        # setlocal bufhidden=hide
        echomsg "Llama log buffer: " .. string(g:llamaLogBufNr)
    else
        var bufList = getbufinfo(g:llamaLogBufNr)
        if len(bufList) == 1
            if bufList[0]['hidden'] == 1
                split
                execute "buf " .. g:llamaLogBufNr
            endif
        endif
    endif
enddef

def g:LlamaConnect(prompt: string): void
    if !exists("g:llamaServerAddress")
        echoerr "You must set g:llamaServerAddress"
        return
    endif

    if llamaChannel != v:null
        ch_close(llamaChannel)
        llamaChannel = v:null
    endif

    g:CreateNewLlamaLogBuffer()

    llamaChannel = ch_open(g:llamaServerAddress, {
        "mode": "nl",
        "drop": "never",
        "callback": function(g:ReceiveLlamaResponseLine, [bufnr()]),
        "close_cb": g:ForgetLlamaChannel,
    })

    var filetypeSystemPrompts = {
        'bash': 'I am writing a bash shell script.',
        'sh': 'I am writing a POSIX shell script.',
        'python': 'I am writing a python program.',
        'java': 'I am writing a java program.',
        'vim': 'I am writing vimscript.',
    }

    var systemPrompt = "You are a helpful assistant."
    if has_key(filetypeSystemPrompts, &filetype)
        systemPrompt = systemPrompt .. " " .. filetypeSystemPrompts[&filetype]
    else
        systemPrompt = systemPrompt .. " I am writing code in " .. &filetype .. "."
    endif

    appendbufline(g:llamaLogBufNr, '$', "")
    appendbufline(g:llamaLogBufNr, '$', "")
    appendbufline(g:llamaLogBufNr, '$', "")
    appendbufline(g:llamaLogBufNr, '$', "# Llama system Prompt:")
    appendbufline(g:llamaLogBufNr, '$', systemPrompt)
    appendbufline(g:llamaLogBufNr, '$', "")
    appendbufline(g:llamaLogBufNr, '$', "# Llama user Prompt:")
    appendbufline(g:llamaLogBufNr, '$', prompt)
    appendbufline(g:llamaLogBufNr, '$', "")
    appendbufline(g:llamaLogBufNr, '$', "# Result")
    appendbufline(g:llamaLogBufNr, '$', "")
    appendbufline(g:llamaLogBufNr, '$', "")


    var entityBody = json_encode({
        "stream": true,
        "temperature": 0.8,
        "messages": [
            {
                "role": "system",
                "content": systemPrompt,
            },
            {
                "id": 1731617236447,
                "role": "user",
                "content": prompt
            }
        ],
        "cache_prompt": true,
        "dynatemp_range": 0,
        "dynatemp_exponent": 1,
        "top_k": 40,
        "top_p": 0.95,
        "min_p": 0.05,
        "typical_p": 1,
        "xtc_probability": 0,
        "xtc_threshold": 0.1,
        "repeat_last_n": 64,
        "repeat_penalty": 1,
        "presence_penalty": 0,
        "frequency_penalty": 0,
        "dry_multiplier": 0,
        "dry_base": 1.75,
        "dry_allowed_length": 2,
        "dry_penalty_last_n": -1,
        "max_tokens": -1
    })

    ch_sendraw(llamaChannel, "POST /chat/completions HTTP/1.1\r\n")
    ch_sendraw(llamaChannel, "Host: " .. g:llamaServerAddress .. "\r\n")
    ch_sendraw(llamaChannel, "Content-Type: application/json\r\n")
    ch_sendraw(llamaChannel, "Accept: text/event-stream\r\n")
    ch_sendraw(llamaChannel, "Content-Length: " .. string(len(entityBody)) .. "\r\n")
    ch_sendraw(llamaChannel, "\r\n")
    ch_sendraw(llamaChannel, entityBody .. "\r\n\r\n")
enddef

def g:PromptFromVisualSelection(): void
    var visBegin = getpos("'<")
    var visEnd = getpos("'>")
    var lines = getline(visBegin[1], visEnd[1])
    var prompt = join(lines, "\n")
    g:LlamaConnect(prompt)
enddef

def g:MoveCursorToTheEndOfTheFileAsSave()
enddef


defcompile

