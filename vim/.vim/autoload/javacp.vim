vim9script

var classpathCache = {}

var preludeClasses = [
    'Boolean', 'Byte', 'Character', 'Class', 'Double', 'Float', 'Integer',
    'Long', 'Math', 'Number', 'Object', 'String', 'StringBuffer',
    'StringBuilder', 'System', 'Thread', 'ThreadGroup', 'ThreadLocal',
    'Throwable', 'Void'
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

var classDerefPattern = '[^.@A-Za-z0-9]\zs[A-Z][A-Za-z0-9_]*'
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
			extend(usedClassNames, [aMatch[0]])
			cnum = aMatch[2]
		endwhile
	endfor
	sort(usedClassNames)
	return uniq(usedClassNames)
enddef

export def CollectKnownClassNames(lines: list<string>): list<string>
	var classPat = '[A-Z][A-Za-z0-9_]*'
	var importPat = '^import [a-z0-9]\+\([.][a-z0-9]\+\)*[.]([*]|' .. classPat .. ');'
    var declPat = 'class ' .. classPat .. ' .*{'
	var knownClassNames = []
    var classMatch: any
	for ln in lines
		var importMatches = matchlist(ln, importPat)
		if len(importMatches) > 0
            if importMatches[1] == "*"
                # Needs to query cpid to resolve these.
            elseif importMatches[1] != ""
                extend(knownClassNames, [importMatches[1]])
                continue
			endif
		endif

        var declMatch = matchstr(ln, declPat)
        if declMatch != ""
            classMatch = matchstr(ln, classPat)
            if classMatch != ""
                extend(knownClassNames, [classMatch])
                continue
            endif
        endif
	endfor
	sort(knownClassNames)
	return uniq(knownClassNames)
enddef

export def CheckBuffer(): void
	var lines = getline(1, '$')
	var usedClasses = CollectUsedClassNames(lines)
	var knownClasses = CollectKnownClassNames(lines)
    extend(knownClasses, preludeClasses)
    # echo "usedClasses=".join(usedClasses, ",")
    # echo "knownClasses=".join(knownClasses, ",")

	# TODO: This could be faster by taking advantage of the fact that both
	# usedClasses and knownClasses could be sorted.
	var classesNeedingImport = ListSubtraction(usedClasses, knownClasses)
    if empty(classesNeedingImport) == 0
        # echo 'Need to import: ' .. join(classes_needing_import, ', ') .. "\n"
    endif

    var javaUtilClasses = ['ArrayList', 'HashSet', 'LinkedHashSet', 'TreeSet', 'Set', 'List', 'Map']
    for cls in classesNeedingImport
        if index(javaUtilClasses, cls) >= 0
            echo 'Need to import java.util.' .. cls .. "\n"
            break
        endif
    endfor
enddef

# Returns a string that is either a readable path ending in pom.xml or the
# emptry string if no pom.xml file was found above the given path.
export def FindPomXml(path: string): string
    var prefix = path
    while !filereadable(prefix .. "/pom.xml")
        prefix = fnamemodify(prefix, ":h")
        if prefix == "/"
            return ""
        endif
    endwhile
    return prefix .. "/pom.xml"
enddef

def DiskCacheFilePath(pomPath: string): string
    return pomPath .. ".classpath-cache"
enddef

def ReadClasspathFromFile(filePath: string): string
    var lines = readfile(filePath)
    return trim(join(lines, ""))
enddef

export def RegenerateClasspathMaven(pomPath: string): void
    var cpTextFilePath = DiskCacheFilePath(pomPath)
    var workDirPath = fnamemodify(pomPath, ":h")
    job_start(
        ["mvn", "dependency:build-classpath", "-Dmdep.outputFile=" .. cpTextFilePath],
        {
            "cwd": workDirPath,
            "stoponexit": "term",
            "exit_cb": (job: any, status: number) => {
                classpathCache[pomPath] = ReadClasspathFromFile(cpTextFilePath)
                echomsg "Determined classpath: " .. classpathCache[pomPath]
            }
        })
enddef

export def GenerateClasspathMaven(pomPath: string): void
    if has_key(classpathCache, pomPath)
        echo "Cached classpath: " .. classpathCache[pomPath]
        return
    endif

    RegenerateClasspathMaven(pomPath)
enddef

defcompile

