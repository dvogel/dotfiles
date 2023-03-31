vim9script

# Copyright 2023 Drew Vogel
# Licensed under the CC-0 "No Rights Reserved" terms (SPDX: CC0-1.0).
# Have fun :)
#
# This plugin provides a command named `AwkLike` that makes it easy to replace
# table-like lines in your vim buffer. An example invocation:
#
#     '<,'>AwkLike "$1": $2,
#
# If executed while selecting these lines:
#
#    Abc    123
#    Xyz    789
#
# Then the lines would be replaced with
#
#     "Abc": 123,
#     "Xyz": 789,
#
# The expression provided to AwkLike is used as the replacement text for each
# line. Within the replacement expression, you can use $N (N = 1-9) as a
# placeholder for the text in the Nth field (separated by consecuitive
# whitespace characters). It is very simalar to running the lines through an
# invocation of awk like this:
#
#    awk '{print "[YOUR EXPR HERE]" }'
#
# However, unlike actually using awk, you do not need to escape double-quotes
# in the expression you provide. While consecutive whitespace characters in
# the source line are collapsed, any consecutive whitespace characters in the
# replacement expression are retained as-is.

def SplitLine(txt: string): list<string>
    return split(txt, '\s\+', v:false)
enddef

# Returns a list of replacement expression indexes in the order they appear in
# the given format expression.
def ParseFmtExpr(txt: string): list<number>
    var accum = []
    var done = v:false
    var scratch = txt
    while v:true
        var pos = match(scratch, '[$][0-9]')
        if pos == -1
            break
        endif
        var cap = scratch[pos + 1]
        add(accum, str2nr(cap))
        scratch = scratch[pos + 2 : ]
    endwhile
    return accum
enddef

def TranslateFmtStr(fmt: string): string
    return substitute(fmt, '[$][0-9]', '%s', 'g')
enddef

def FmtRec(txt: string, fmt: string): string
    var ordinals = ParseFmtExpr(fmt)
    if ordinals == []
        return fmt
    endif
    var fields = SplitLine(txt)
    # len() is 0-based while ordinals is 1-based
    if len(fields) < max(ordinals)
        echoerr "Not enough fields in input."
        return fmt
    endif
    var subs: list<any> = []
    for nth in ordinals
        add(subs, fields[nth - 1])
    endfor
    var cLikeFmt = TranslateFmtStr(fmt)
    return call(function("printf", [cLikeFmt]), subs)
enddef

def FmtLines(line1: number, line2: number, fmt: string): void
    var lineNum = line1
    while lineNum <= line2
        var lineText = getline(lineNum)
        var replacement = FmtRec(lineText, fmt)
        setline(lineNum, replacement)
        lineNum = lineNum + 1
    endwhile
enddef

defcompile

v:errors = []
assert_true(SplitLine(" one two   three ") == ["one", "two", "three"])
assert_true(TranslateFmtStr("$2 -> $1") == "%s -> %s")
assert_true(FmtRec("ABC\t123", '"$2" -> "$1"') == '"123" -> "ABC"')
if len(v:errors) > 0
    for err in v:errors
        echoerr err
    endfor
endif

g:ParseFmtExpr = funcref(ParseFmtExpr)
g:FmtRec = funcref(FmtRec)

command! -nargs=1 -range AwkLike call FmtLines(<line1>, <line2>, <q-args>)

