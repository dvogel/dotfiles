vim9script

import "pomutil.vim"

var outstandingCpidRequests: dict<func> = {}
var channel: channel
var debugMode: bool = v:false

command! CpidDebugOn debugMode = v:true
command! CpidDebugOff debugMode = v:false

def DebugMsg(msg: any): void
    if debugMode == v:true
        if type(msg) == v:t_func
            var MsgFunc = msg
            echomsg MsgFunc()
        else
            echomsg msg
        endif
    endif
enddef

def DebugErr(msg: any): void
    if debugMode == v:true
        if type(msg) == v:t_func
            var MsgFunc = msg
            echoerr MsgFunc()
        else
            echoerr msg
        endif
    endif
enddef

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
    var importPrefixPat = '^import\s'
    var emptyLinePat = '^\s*$'
    var packagePrefixPat = '^package\s'
    var accum: list<number> = []
    var idx = 0
    for ln in lines
        if match(ln, importPrefixPat) >= 0
            extend(accum, [idx])
        elseif len(accum) == 0 && match(ln, packagePrefixPat) >= 0
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
    var packagePrefixPat = '^package\s'
    return match(lines, packagePrefixPat)
enddef

export def ExtractDeclPackageName(lines: list<string>): string
    var packageDeclCapturePat = '^package\s\+\([a-z0-9]\+\%([.][a-z0-9]\+\)*\)\s*;'
    var packageDeclMatch = matchlist(lines, packageDeclCapturePat)
    if packageDeclMatch == []
        return ""
    else
        return packageDeclMatch[1]
    endif
enddef

var stringLiteralPattern = '"\([\]["]\|[^"]\)*"'
var classDerefPattern = '[^._A-Za-z0-9]\zs[A-Z][A-Za-z0-9_]*'
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
    var indexNames = []

    if exists('b:jdkVersion')
        add(indexNames, "jdk" .. b:jdkVersion)
    elseif exists('b:pomXmlPath')
        add(indexNames, b:pomXmlPath)
        add(indexNames, fnamemodify(b:pomXmlPath, ":p:h"))
        var jdkIndexName: any = pomutil.FetchJdkVersion(b:pomXmlPath)
        if jdkIndexName != v:null
            add(indexNames, "jdk" .. jdkIndexName)
        endif
    endif

    return indexNames
enddef

var classIdentPat = '[A-Z][A-Za-z0-9_]*'
var importPat = '^import \%(static \)\?\([a-z0-9]\+\%([.][A-Za-z0-9]\+\)*\)[.]\([*]\|' .. classIdentPat .. '\);'
var declPat = '\(\W\|^\)class\s\+' .. classIdentPat .. '\(\s\|$\)'

# Since class patterns are also unfortunately also valid variable patterns
# we need to identify declared variables to avoid reporting them as
# classes needing import. This is especially true for static class
# members that often have all-caps names. e.g. LOGGER.
var memberDeclPat = '\%(\W\|^\)\%(public\|private\|protected\)\?\%(\s\+final\)\?\%(\s\+\%(var\|char\|byte\|int\|long\|float\|double\|' .. classIdentPat .. '\)\)\s\+\(' .. classIdentPat .. '\)'

export def SelfTestCollectKnownClassNames(): void
    var memberDeclMatches = matchlist("protected final int DEFAULT_BATCH_SIZE = 1000L;", memberDeclPat)
    assert_equal("DEFAULT_BATCH_SIZE", memberDeclMatches[1])
enddef

# TODO: This needs to enumerate all of the classes in the current package.
export def CollectKnownClassNames(lines: list<string>): list<string>
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
                        type: "PackageMultiEnumerateQuery",
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
            classMatch = matchstr(ln, classIdentPat)
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

    if exists("b:cpidPackageName")
        var resp = ch_evalexpr(channel, {
            type: "PackageMultiEnumerateQuery",
            index_names: indexNames,
            package_name: b:cpidPackageName,
        })
        if resp["type"] == "PackageEnumerateQueryResponse"
            if has_key(resp["results"], b:cpidPackageName)
                extend(knownClassNames, resp["results"][b:cpidPackageName])
            else
                DebugMsg(() => "No cpid results for package " .. string(b:cpidPackageName))
            endif
        endif
    endif

	sort(knownClassNames)
	return uniq(knownClassNames)
enddef

export def CheckBuffer(): void
    if exists("b:cpidIgnore")
        return
    endif

    if !exists("b:cpidUsedClassNames") || !exists("b:cpidKnownClassNames")
        return
    endif

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
    if !exists("b:cpidClassesNeedingImport")
        echo "No missing imports for " .. expand("%:t")
        return
    endif

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

def FixFirstMissingImport(classNames: list<string>): void
    if len(classNames) == 0
        return
    endif

    var cls = classNames[0]
    var rest = slice(classNames, 1)

    var indexNames = GetBufferIndexNames()
    var resp = CpidSendSync("ClassQueryResponse", {
        type: "ClassMultiQuery",
        index_names: indexNames,
        class_name: cls,
        })

    if empty(resp)
        FixFirstMissingImport(rest)
        return
    endif

    if !has_key(resp["results"], cls)
        echoerr "response from cpid lacked results for class " .. cls
        FixFirstMissingImport(rest)
        return
    endif

    var choices = resp["results"][cls]
    if len(choices) == 0
        DebugMsg(() => "Squelching fix for class " .. cls .. " because the list of potential namespaces is empty.")
        FixFirstMissingImport(rest)
        return
    endif

    popup_menu(choices, {
        "padding": [1, 1, 1, 1],
        "border": [1, 0, 0, 0],
        "title": " Package for class " .. cls .. ": ",
        "callback": (winid: number, result: number) => {
            echomsg "callback with rest: " .. string(rest)
            if result >= 1
                RecvImportChoice(winid, choices[result - 1], cls)
            endif
            if len(rest) > 0
                FixFirstMissingImport(rest)
            endif
            },
        })
enddef

export def FixMissingImports(): void
    if !exists("b:cpidClassesNeedingImport")
        echo "No missing imports for " .. expand("%:t")
        return
    endif

    FixFirstMissingImport(b:cpidClassesNeedingImport)
enddef

export def ReindexProject(): void
    if has_key(b:, "pomXmlPath")
        var projectPath = fnamemodify(b:pomXmlPath, ":p:h")
        DebugMsg(() => "Requesting reindexing of project path " .. projectPath)
        var resp = ch_evalexpr(channel, {
            "type": "ReindexProjectCmd",
            index_name: projectPath,
            archive_source: projectPath,
            })
    endif
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
    if exists("b:cpidIgnore")
        return
    endif

	var lines = getline(1, '$')
    b:cpidPackageName = ExtractDeclPackageName(lines)
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
    if exists("b:cpidIgnore")
        return
    endif

    b:pomXmlPath = pomutil.FindPomXml(expand("%:p"))
    if b:pomXmlPath != ""
        pomutil.IdentifyPomJdkVersion(b:pomXmlPath)
    elseif exists('b:jdkVersion')
        # no-op
    else
        return
    endif

    if !CheckCpidConnection()
        ConnectToCpid()
    endif
    if CheckCpidConnection()
        UpdateBufferShadow()
        CheckBuffer()
    else
        echo "cpid connection failed :("
    endif
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

