setlocal keywordprg=:Zeavim

if &shiftwidth == 4
    let b:java_style_flag = "--aosp"
else
    let b:java_style_flag = ""
endif

