vim9script

const defaultAlphabet = "nato"
var alphabets = {
    "nato": {
        "A": "Alfa",
        "N": "November",
        "B": "Bravo",
        "O": "Oscar",
        "C": "Charlie",
        "P": "Papa",
        "D": "Delta",
        "Q": "Quebec",
        "E": "Echo",
        "R": "Romeo",
        "F": "Foxtrot",
        "S": "Sierra",
        "G": "Golf",
        "T": "Tango",
        "H": "Hotel",
        "U": "Uniform",
        "I": "India",
        "V": "Victor",
        "J": "Juliett",
        "W": "Whiskey",
        "K": "Kilo",
        "X": "Xray",
        "L": "Lima",
        "Y": "Yankee",
        "M": "Mike",
        "Z": "Zulu",
    }
}

export def PhoneticExpansion(alphabetName: string): void
    if alphabetName == ""
        PhoneticExpansion("nato")
        return
    endif
    var ln = getline('.')
    var ch = ln[col('.') - 1]
    var isupper = ch == toupper(ch)
    var expansion = alphabets[alphabetName][toupper(ch)]
    if isupper
        echo toupper(expansion)
    else
        echo tolower(expansion)
    endif
enddef

export def PhoneticAlphabets(argLead: string, cmdLine: string, cursorPos: number): list<string>
    return keys(alphabets)
enddef

command! -nargs=? -complete=customlist,PhoneticAlphabets PhoneticExpansion call PhoneticExpansion(<q-args>)
