vim9script

import autoload "pomutil.vim"

var outstandingCpidRequests: dict<func> = {}
var channel: channel

# These classes come from java.lang, which is automatically imported. These
# would be returned be returned by a PackageEnumerateQuery. In fact this list
# was built with:
#   cpid pkgenum jdk11 java.lang | jq -r '.["java.lang"][]'
# However there is no need to import these so they are added to the known
# classes list for every buffer. Could potentially save some memory by
# removing these from the b:classesNeedingImport list instead.
var preludeClasses = [
    'AbstractMethodError', 'AbstractStringBuilder',
    'Appendable', 'ApplicationShutdownHooks', 'ArithmeticException',
    'ArrayIndexOutOfBoundsException', 'ArrayStoreException', 'AssertionError',
    'AssertionStatusDirectives', 'AutoCloseable', 'Boolean',
    'BootstrapMethodError', 'Byte', 'Character', 'CharacterData',
    'CharacterData00', 'CharacterData01', 'CharacterData02', 'CharacterData03',
    'CharacterData0E', 'CharacterDataLatin1', 'CharacterDataPrivateUse',
    'CharacterDataUndefined', 'CharacterName', 'CharSequence', 'Class',
    'ClassCastException', 'ClassCircularityError', 'ClassFormatError',
    'ClassLoader', 'ClassLoaderHelper', 'ClassNotFoundException', 'ClassValue',
    'Cloneable', 'CloneNotSupportedException', 'Comparable', 'Compiler',
    'CompoundEnumeration', 'ConditionalSpecialCasing', 'Deprecated', 'Double',
    'Enum', 'EnumConstantNotPresentException', 'Error', 'Exception',
    'ExceptionInInitializerError', 'FdLibm', 'Float', 'FunctionalInterface',
    'IllegalAccessError', 'IllegalAccessException', 'IllegalArgumentException',
    'IllegalCallerException', 'IllegalMonitorStateException',
    'IllegalStateException', 'IllegalThreadStateException',
    'IncompatibleClassChangeError', 'IndexOutOfBoundsException',
    'InheritableThreadLocal', 'InstantiationError', 'InstantiationException',
    'Integer', 'InternalError', 'InterruptedException', 'Iterable',
    'LayerInstantiationException', 'LinkageError', 'LiveStackFrame',
    'LiveStackFrameInfo', 'Long', 'Math', 'Module', 'ModuleLayer', 'NamedPackage',
    'NegativeArraySizeException', 'NoClassDefFoundError', 'NoSuchFieldError',
    'NoSuchFieldException', 'NoSuchMethodError', 'NoSuchMethodException',
    'NullPointerException', 'Number', 'NumberFormatException', 'Object',
    'OutOfMemoryError', 'Override', 'Package', 'Process', 'ProcessBuilder',
    'ProcessEnvironment', 'ProcessHandle', 'ProcessHandleImpl', 'ProcessImpl',
    'PublicMethods', 'Readable', 'Record', 'ReflectiveOperationException',
    'Runnable', 'Runtime', 'RuntimeException', 'RuntimePermission', 'SafeVarargs',
    'SecurityException', 'SecurityManager', 'Short', 'Shutdown', 'StackFrameInfo',
    'StackOverflowError', 'StackStreamFactory', 'StackTraceElement',
    'StackWalker', 'StrictMath', 'String', 'StringBuffer', 'StringBuilder',
    'StringCoding', 'StringConcatHelper', 'StringIndexOutOfBoundsException',
    'StringLatin1', 'StringUTF16', 'SuppressWarnings', 'System', 'Terminator',
    'Thread', 'ThreadDeath', 'ThreadGroup', 'ThreadLocal', 'Throwable',
    'TypeNotPresentException', 'UnknownError', 'UnsatisfiedLinkError',
    'UnsupportedClassVersionError', 'UnsupportedOperationException',
    'VerifyError', 'VersionProps', 'VirtualMachineError', 'Void', 'WeakPairMap',
]

# Return a list of all of the values in `xs` that are not in `ys`
export def ListSubtraction(xs: list<any>, ys: list<any>): list<any>
    var remaining = []
	for xItem in xs
		var matched = false
		for yItem in ys
            if xItem == yItem
				matched = true
                break
			endif
		endfor
		if matched == false
            extend(remaining, [xItem])
		endif
	endfor
    return remaining
enddef

export def FindImportLineIndexes(lines: list<string>): list<number>
	var importPat = '^import\s'
    var emptyLinePat = '^\s*$'
    var packagePat = '^package\s'
    var accum: list<number> = []
    var idx = 0
    for ln in lines
        if match(ln, importPat) >= 0
            extend(accum, [idx])
        elseif len(accum) == 0 && match(ln, packagePat) >= 0
            # No-op
        elseif match(ln, emptyLinePat) >= 0
            # No-op
        else
            return accum
        endif
        idx += 1
    endfor
    return accum
enddef

export def FindFinalImport(lines: list<string>): number
    var importIndexes = FindImportLineIndexes(lines)
    if len(importIndexes) == 0
        return -1
    else
        return importIndexes[-1]
    endif
enddef

export def FindPackageDecl(lines: list<string>): number
    var packagePat = '^package\s'
    return match(lines, packagePat)
enddef

var stringLiteralPattern = '"\([\]["]\|[^"]\)*"'
var classDerefPattern = '[^._@A-Za-z0-9]\zs[A-Z][A-Za-z0-9_]*'
export def CollectUsedClassNames(lines: list<string>): list<string>
    var usedClassNames = []
    var inComment = v:false
    for ln in lines
        var cnum = 0
        if match(ln, '^\s*//') >= 0
            continue
        elseif match(ln, '^\s*/[*]') >= 0
            inComment = true
            continue
        elseif inComment && match(ln, '[*]/\s*$') >= 0
            inComment = false
        elseif match(ln, '^import ') >= 0
            continue
        elseif inComment
            continue
        endif

        while true
            var aMatch = matchstrpos(ln, classDerefPattern, cnum)
            if aMatch[0] == ""
                break
            endif

            # Update cnum because we need to move the search cursor within the
            # line even if we squelch this specific match.
            cnum = aMatch[2]

            # Make sure the match wasn't contained in a string literal.
            var strLitMatch = matchstrpos(ln, stringLiteralPattern)
            if strLitMatch[0] != ""
                if cnum >= strLitMatch[1] && cnum <= strLitMatch[2]
                    continue
                endif
            endif

            extend(usedClassNames, [aMatch[0]])
        endwhile
    endfor
    sort(usedClassNames)
    return uniq(usedClassNames)
enddef

def GetBufferIndexNames(): list<string>
    var indexNames = [b:pomXmlPath]
    var jdkIndexName: any = pomutil.FetchJdkVersion(b:pomXmlPath)
    if jdkIndexName != v:null
        add(indexNames, jdkIndexName)
    endif
    return indexNames
enddef

# TODO: This needs to enumerate all of the classes in the current package.
export def CollectKnownClassNames(lines: list<string>): list<string>
	var classPat = '[A-Z][A-Za-z0-9_]*'
	var importPat = '^import \([a-z0-9]\+\%([.][a-z0-9]\+\)*\)[.]\([*]\|' .. classPat .. '\);'
    var declPat = '\(\W\|^\)class\s\+' .. classPat .. '\(\s\|$\)'

    # Since class patterns are also unfortunately also valid variable patterns
    # we need to identify declared variables to avoid reporting them as
    # classes needing import. This is especially true for static class
    # members that often have all-caps names. e.g. LOGGER.
    var memberDeclPat = '\(\W\|^\)\%\(public\|private\)\?\%\(\s\+final\)\?\%\(\s\+var\|char\|byte\|int\|long\|float\|double\|' .. classPat .. '\)\s\+\(' .. classPat .. '\)'
	var knownClassNames = []
    var classMatch: any
    var indexNames = GetBufferIndexNames()
	for ln in lines
		var importMatches = matchlist(ln, importPat)
		if len(importMatches) > 0
            var packageName = importMatches[1]
            var className = importMatches[2]
            if className == "*"
                if empty(b:pomXmlPath)
                    echomsg "Skipping package wildcard query to cpid because b:pomXmlPath is empty."
                else
                    var resp = ch_evalexpr(channel, {
                        type: "PackageEnumerateQuery",
                        index_names: indexNames,
                        package_name: packageName,
                        })
                    if resp["type"] == "PackageEnumerateQueryResponse"
                        extend(knownClassNames, resp["results"][packageName])
                    endif
                endif
            elseif importMatches[2] != ""
                add(knownClassNames, importMatches[2])
                continue
			endif
		endif

        var declMatch = matchstr(ln, declPat)
        if declMatch != ""
            classMatch = matchstr(ln, classPat)
            if classMatch != ""
                add(knownClassNames, classMatch)
                continue
            endif
        endif

        var memberDeclMatches = matchlist(ln, memberDeclPat)
        if memberDeclMatches != []
            add(knownClassNames, memberDeclMatches[1])
        endif
	endfor
	sort(knownClassNames)
	return uniq(knownClassNames)
enddef

export def CheckBuffer(): void
	var lines = getline(1, '$')
	# var usedClasses = CollectUsedClassNames(lines)
	# var knownClasses = CollectKnownClassNames(lines)
    var usedClasses = b:cpidUsedClassNames
    var knownClasses = b:cpidKnownClassNames
    extend(knownClasses, preludeClasses)

    # TODO: This could be faster by taking advantage of the fact that both
    # usedClasses and knownClasses could be sorted.
	var classesNeedingImport = ListSubtraction(usedClasses, knownClasses)

    b:cpidClassesNeedingImport = classesNeedingImport
    ShowMissingImports()
enddef

export def ShowMissingImports(): void
    var accum = []
    for cls in b:cpidClassesNeedingImport
        add(accum, {
            "bufnr": bufnr(),
            "text": "Missing import for " .. cls,
            "pattern": '\W' .. cls .. '\W',
            "type": 'E',
            })
    endfor
    setloclist(bufwinid(bufnr()), accum, 'r')
enddef

def FixSingleMissingImport(cls: string): void
    var indexNames = GetBufferIndexNames()
    var resp = CpidSendSync("ClassQueryResponse", {
        type: "ClassQuery",
        index_names: indexNames,
        class_name: cls,
        })

    if empty(resp)
        return
    endif

    if !has_key(resp["results"], cls)
        echoerr "response from cpid lacked results for class " .. cls
        return
    endif

    var choices = resp["results"][cls]
    if len(choices) == 0
        echomsg "Squelching fix for class " .. cls .. " because the list of potential namespaces is empty."
        return
    endif

    popup_menu(choices, {
        "padding": [1, 1, 1, 1],
        "border": [1, 0, 0, 0],
        "title": " Package for class " .. cls .. ": ",
        "callback": (winid: number, result: number) => {
            if result >= 1
                RecvImportChoice(winid, choices[result - 1], cls)
            endif
            },
        })
enddef

export def FixMissingImports(): void
    # TODO: Since popup_menu() in FixSingleMissingImport() is async, this loop
    # draws each window over the top of the previous one in the list before
    # accepting input.
    for cls in b:cpidClassesNeedingImport
        FixSingleMissingImport(cls)
    endfor
enddef

export def ReindexClasspath(): void
    if has_key(b:, "pomXmlPath")
        var cpText = pomutil.FetchClasspath(b:pomXmlPath)
        if cpText == v:null
            echo "Cannot index classpath because it is still being generated."
            return
        endif

        var resp = ch_evalexpr(channel, {
            type: "ReindexClasspathCmd",
            index_name: b:pomXmlPath,
            archive_source: cpText,
            })
    endif
enddef

export def UpdateBufferShadow(): void
	var lines = getline(1, '$')
    b:cpidKnownClassNames = CollectKnownClassNames(lines)
    b:cpidUsedClassNames = CollectUsedClassNames(lines)
enddef

export def RecvCpidChannelMessage(chan: channel, msg: dict<any>): void
    echomsg "Dropping response from cpid because it lacked a callback: " .. string(msg)
enddef

export def RecvImportChoice(winid: number, packageName: string, className: string): void
    var newLine = "import " .. packageName .. "." ..  className .. ";"
    var lines = getline(1, '$')

    var finalImportLine = FindFinalImport(lines)
    if finalImportLine > -1
        append(finalImportLine + 1, newLine)
        return
    endif 

    var packageDeclLine = FindPackageDecl(lines)
    if packageDeclLine > -1
        # These are appended in "reverse" order to avoid line number
        # arithmatic.
        append(packageDeclLine + 1, newLine)
        append(packageDeclLine + 1, "")
        return
    endif

    echoerr "Could not identify the correct line to insert: " .. newLine
enddef

export def CpidSendSync(expectedRespType: string, options: dict<any>): dict<any>
    try
        var resp = ch_evalexpr(channel, options)
        if type(resp) != v:t_dict
            echoerr "unexpected response from cpid. expecting json object."
            return {}
        endif

        if !has_key(resp, "type") || resp["type"] != expectedRespType
            echoerr "unexpected response from cpid. expecting:" .. expectedRespType
            return {}
        endif

        return resp
    catch
        echoerr "Lost connection to cpid."
        return {}
    endtry
enddef

export def ConnectToCpid(): void
    var xdg_state_home = getenv("XDG_STATE_HOME")
    if xdg_state_home == v:null
        xdg_state_home = getenv("HOME") .. "/.local/state"
    endif
    var socket_path = xdg_state_home .. "/cpid/sock"

    channel = ch_open("unix:" .. socket_path, {
        "mode": "json",
        "callback": RecvCpidChannelMessage,
    })
enddef

export def CheckCpidConnection(): bool
    try
        var chanInfo = ch_info(channel)
        return !!chanInfo
    catch
        ConnectToCpid()
        return v:false
    endtry
enddef

export def InitializeJavaBuffer(): void
    b:pomXmlPath = pomutil.FindPomXml(expand("%:p"))
    pomutil.IdentifyPomJdkVersion(b:pomXmlPath)

    if !CheckCpidConnection()
        ConnectToCpid()
    endif
    UpdateBufferShadow()
    CheckBuffer()
enddef

export def StatusLineExpr(): string
    if has_key(b:, "cpidClassesNeedingImport") && len(b:cpidClassesNeedingImport) > 0
        # return "🞂I🞀 "
        return "%#CpidStatus#🞀I🞂%#StatusLine# "
    else
        return ""
    endif
enddef

defcompile

