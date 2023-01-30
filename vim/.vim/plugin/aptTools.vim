

vim9script

var words: list<string> = []

var removeLibs: bool = v:false
var removePatterns: list<string> = []
var modRuleLines: list<string> = []

def ResetOptions(): void
    removeLibs = v:false
    removePatterns = []
    modRuleLines = []
enddef

def ParsePackageList(lines: list<string>): list<string>
    var accum: list<string> = []
    for ln in lines
        if match(ln, "^#") == -1
            extend(accum, split(ln))
        endif
    endfor
    return accum
enddef

var modPatNoLibs = '^#\s*nolibs'
var modPatNoPkg = '^#\s*nopkg\s\+\(.\+\)'
def ParseModRules(lines: list<string>): void
    removePatterns = []
    modRuleLines = []

    for ln in lines
        if match(ln, modPatNoLibs) >= 0
            add(modRuleLines, ln)
            removeLibs = v:true
            continue
        endif

        var matches = matchlist(ln, modPatNoPkg)
        if matches != []
            add(modRuleLines, ln)
            add(removePatterns, matches[1])
            continue
        endif
    endfor
enddef

def PackageShouldBeKept(pkgName: string): bool
    for pkgPat in removePatterns
        if match(pkgName, pkgPat) >= 0
            return v:false
        endif
    endfor
    return v:true
enddef

export def RewriteBuffer(): void
    ResetOptions()

    var lines = getline(1, '$')
    ParseModRules(lines)
    var packageNames = ParsePackageList(lines)
    if removeLibs == v:true
        filter(packageNames, (idx, pkgName) => match(pkgName, "^lib") == -1)
    endif
    filter(packageNames, (idx, pkgName) => PackageShouldBeKept(pkgName))

    normal ggdG
    for ln in modRuleLines
        append("$", ln)
    endfor

    var longListLine = join(packageNames, " ")

    append("$", "")
    append("$", longListLine)
    normal Ggqq

    append("$", "")
    append("$", "# aptitude install " .. longListLine)
enddef

nnoremap <leader>apt <ScriptCmd>:call RewriteBuffer()<CR>

defcompile

