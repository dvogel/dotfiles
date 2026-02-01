vim9script

def ShowLens(text: list<string>)
    var winPadding = 3
    # Ensure the popup is at least 1 line tall in the case of a very short buf
    # window.
    var minheight = 
        max([1,
            # Accomodate all lines from the transform unless they won't fit in the
            # window.
            min([len(text),
                winheight(bufwinnr(bufnr())) - winPadding])])
    var longestLineLen = max(map(copy(text), (idx, ln) => strchars(ln)))
    var minwidth =
        max([1,
            min([longestLineLen,
                winwidth(bufwinnr(bufnr())) - winPadding])])
    popup_dialog(text, {
        "minheight": minheight,
        "minwidth": longestLineLen,
        "line": "cursor+1",
        "col": "cursor+1",
        "pos": "topleft",
        "moved": "word",
        "wrap": v:false,
    })
enddef

def SyntaxTrailTransform(textObj: dict<any>): list<string>
    if exists("g:SyntaxTrailAt")
        var trail = g:SyntaxTrailAt(textObj["start"][0], textObj["start"][1])
        var withLineBreaks = substitute(trail, ' ->', '\r ->', "g")
        var lines = split(withLineBreaks, '\r')
        return lines
    endif
    return null_list
enddef

def CurrentWordSubject(): dict<any>
    var col = charcol(".")
    var ln = getline(".")
    var word = expand("<cword>")

    if strchars(word) == 0
        return null_dict
    endif

    var searchStart = 0
    while true
        var foundIdx = stridx(ln, word, searchStart)
        if foundIdx == -1
            return null_dict
        endif
        
        var foundEndIdx = foundIdx + strchars(word) - 1
        if foundIdx <= col && col <= foundEndIdx
            return {
                "text": word,
                "start": [line("."), foundIdx],
                "end": [line("."), foundEndIdx],
                "bufnr": bufnr()
            }
        endif
        
        searchStart = foundEndIdx
    endwhile

    return null_dict
enddef

def CurrentLineSubject(): dict<any>
    var ln = line(".")
    var text = getline(".")
    if strchars(trim(text)) == 0
        return null_dict
    endif

    return {
        "text": text,
        "start": [ln, 0],
        "end": [ln, strchars(text)],
        "bufnr": bufnr(),
    }
enddef

# Returns a list of objects of the shape:
# {
#   'text': string,
#   'start: [line: number, col: number],
#   'end': [line: number, col: number],
#   'bufnr': number,
# }
# The column numbers are 0-indexed and represent the inclusive range.
def SubjectTexts(): list<dict<any>>
    return filter([
        CurrentWordSubject(),
        CurrentLineSubject(),
        # CurrentParagraphSubject(),
    ], (idx, val) => !empty(val))
enddef

# Returns a list of transform functions. Each transform function should return
# the text to display or null_list if the subject is irrelevant.
def Analyzers(): list<func>
    var analyzers = []
    if exists("b:omniLensAnalyzers") && type(b:omniLensAnalyzers) == v:t_list
        extend(analyzers, b:omniLensAnalyzers)
    endif
    extend(analyzers, [
        funcref(SyntaxTrailTransform)
    ])
    return analyzers
enddef

def OmniLensMain(): void
    var subjects = SubjectTexts()
    var analyzers = Analyzers()

    # echomsg "OmniLensMain: " .. string(len(subjects)) .. " subjects"
    # echomsg "OmniLensMain: " .. string(len(analyzers)) .. " analyzers"

    for subj in subjects
        for Analyzer in analyzers
            var result = Analyzer(subj)
            if result != null_list
                ShowLens(result)
                # TODO: Add a way for the user to indicate they want the next
                # lens
                return
            endif
        endfor
    endfor
enddef

command! OmniLens OmniLensMain()

nnoremap <leader>O :OmniLens<CR>
