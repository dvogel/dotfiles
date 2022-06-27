setlocal keywordprg=:Zeavim

let universal_flags="--skip-removing-unused-imports --skip-sorting-imports --skip-reflowing-long-strings --skip-javadoc-formatting"

if &shiftwidth == 4
    let b:java_style_flag = universal_flags." --aosp"
else
    " The google style is the default and is not set explicitly
    let b:java_style_flag = universal_flags.""
endif

