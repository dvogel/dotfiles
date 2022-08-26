vim9script

var pomJdkVersionCache = {}
var classpathCache = {}
var pomXmlJdkVersionPaths = [
    '/*[local-name()="project"]/*[local-name()="properties"]/*[local-name()="maven.compiler.source"]'
    ]

export def ForgetPomJdkVersion(path: string): void
    if has_key(pomJdkVersionCache, path)
        remove(pomJdkVersionCache, path)
    endif
enddef

export def IdentifyPomJdkVersion(path: string): void
    if has_key(pomJdkVersionCache, b:pomXmlPath)
        return
    endif

    for xmlpath in pomXmlJdkVersionPaths
        var cmd = "xmlstarlet sel -t -v " .. shellescape(xmlpath) .. " " .. shellescape(path)
        var versionText = system(cmd)
        if len(versionText) > 0
            pomJdkVersionCache[path] = versionText
        endif
    endfor
enddef

def ReadClasspathFromFile(filePath: string): string
    var lines = readfile(filePath)
    return trim(join(lines, ""))
enddef

export def ClasspathDiskCacheFilePath(pomPath: string): string
    return pomPath .. ".classpath-cache"
enddef

export def RegenerateClasspathMaven(pomPath: string): void
    var cpTextFilePath = ClasspathDiskCacheFilePath(pomPath)
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

export def FetchClasspath(pomPath: string): any
    if has_key(classpathCache, pomPath)
        return classpathCache[pomPath]
    endif

    if filereadable(ClasspathDiskCacheFilePath(pomPath))
        return ReadClasspathFromFile(ClasspathDiskCacheFilePath(pomPath))
    endif

    RegenerateClasspathMaven(pomPath)
    return v:null
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

export def PrintPomAttrs(path: string): void
    if has_key(pomJdkVersionCache, path)
        echo "JDK Version: " .. pomJdkVersionCache[path]
    else
        echo "JDK Version: (unknown)"
    endif
enddef

defcompile
