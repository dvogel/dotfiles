if get(b:, 'editorconfig_applied', 0) == 0
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal expandtab
endif
setlocal nowrap
setlocal ruler
setlocal textwidth=100
setlocal wildignore+=*.class
compiler mvn


" augroup javaTweaks
"     autocmd FileType java let b:m1=matchadd('Search', '\%<120v.\%>115v', -1)
"     autocmd FileType java let b:m2=matchadd('Todo', '\%>120v.\+', -1)
"     autocmd FileType java ProjectRootCD
" augroup END

function! GoogleJavaImport()
    let ln = getline(".")
    let fqSymbol = substitute(ln, '^\s*import\s\+\([a-zA-Z0-9.]\+\);\s*$', '\1', '')
    if ln == fqSymbol
        echoerr "No import found on line " . line(".") . "."
        return
    endif

    let cmd = "xdg-open 'https://www.google.com/search?q=javadoc+" . fqSymbol . "'"
    call system(cmd)
endfunction
command! GoogleJavaImport call GoogleJavaImport()
nmap <Leader>goog :GoogleJavaImport<CR>

augroup JavaAutocmds
    autocmd!
    autocmd BufWrite *.java :Autoformat
augroup END

nmap <C-F11> :Autoformat<CR>
nmap <F11> :LspDocumentDiagnostics<CR>

function! FixJavaImport()
    let ln = getline(".")
    " Strip leading and trailing whitespace.
    let ln = substitute(ln, '^\s\+', "", "")
    echo "msg=".ln
    let ln = substitute(ln, '\s\+$', "", "")
    let ln = substitute(ln, '^package ', "", "")
    if matchstr(ln, "^import ") != "import "
        let ln = "import " . ln
    endif

    if matchstr(ln, ";$") != ";"
        let ln = ln . ";"
    endif

    execute "s/^.*$/" . ln . "/"
endfunc
nmap <Leader>import :call FixJavaImport()<CR>








" TODO: Replace this with vim-cpid once it is more than a prototype.

" Return a list of all of the values in `xs` that are not in `ys`
function! ListSubtraction(xs, ys)
    let remaining = []
	for x_item in a:xs
		let matched = v:false
		for y_item in a:ys
            if x_item == y_item
				let matched = v:true
                break
			endif
		endfor
		if matched == v:false
            call extend(remaining, [x_item])
		endif
	endfor
    return remaining
endfunction

function! CollectUsedClassNames(lines)
	let class_pat = '[^.@A-Za-z0-9]\zs[A-Z][A-Za-z0-9_]*'
	let class_names = []
    let in_comment = v:false
	for ln in a:lines
		let cnum = 0
        if match(ln, '^\s*//') >= 0
            continue
        elseif match(ln, '^\s*/[*]') >= 0
            let in_comment = v:true
            continue
        elseif in_comment == v:true && match(ln, '[*]/\s*$') >= 0
            let in_comment = v:false
        elseif match(ln, '^import ') >= 0
            continue
        elseif in_comment == v:true
            continue
        endif

		while 1
			let match = matchstrpos(ln, class_pat, cnum)
			if match[0] == ""
				break
			endif
			call extend(class_names, [match[0]])
			let cnum = match[2]
		endwhile
	endfor
	call sort(class_names)
	return uniq(class_names)
endfunction

function! CollectKnownClassNames(lines)
	let class_pat = '[A-Z][A-Za-z0-9_]*'
	let import_pat = '^import [a-z0-9]\+\([.][a-z0-9]\+\)*[.]'.class_pat.';'
    let decl_pat = 'class '.class_pat.' .*{'
	let known_class_names = []
	for ln in a:lines
		let import_match = matchstr(ln, import_pat)
		if import_match != ""
			let class_match = matchstr(ln, class_pat)
			if class_match != ""
				call extend(known_class_names, [class_match])
                continue
			endif
		endif

        let decl_match = matchstr(ln, decl_pat)
        if decl_match != ""
            let class_match = matchstr(ln, class_pat)
            if class_match != ""
                call extend(known_class_names, [class_match])
                continue
            endif
        endif
	endfor
	call sort(known_class_names)
	return uniq(known_class_names)
endfunction


function! CheckBuffer()
	let lines = getline(1, '$')
    let prelude_classes = ['Boolean', 'Byte', 'Character', 'Class', 'Double', 'Float', 'Integer', 'Long', 'Math', 'Number', 'Object', 'String', 'StringBuffer', 'StringBuilder', 'System', 'Thread', 'ThreadGroup', 'ThreadLocal', 'Throwable', 'Void']
	let used_classes =  CollectUsedClassNames(lines)
	let known_classes = CollectKnownClassNames(lines)
    call extend(known_classes, prelude_classes)
    " echo "used_classes=".join(used_classes, ",")
    " echo "known_classes=".join(known_classes, ",")

	" TODO: This could be faster by taking advantage of the fact that both
	" used_classes and known_classes could be sorted.
	let classes_needing_import = ListSubtraction(used_classes, known_classes)
    if empty(classes_needing_import) == 0
        " echo 'Need to import: '.join(classes_needing_import, ', ')."\n"
    endif

    let java_util_classes = ['ArrayList', 'HashSet', 'LinkedHashSet', 'TreeSet', 'Set', 'List', 'Map']
    for cls in classes_needing_import
        if index(java_util_classes, cls) >= 0
            echo 'Need to import java.util.'.cls."\n"
            break
        endif
    endfor
endfunction

command! CheckForMissingImports :call CheckBuffer()

augroup CpidJavaTemp
	autocmd!
	autocmd BufWrite *.java CheckForMissingImports
augroup END

