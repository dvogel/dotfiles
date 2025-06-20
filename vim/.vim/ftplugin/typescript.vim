vim9script

setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=110
setlocal expandtab
setlocal smarttab
setlocal nosmartindent
setlocal nowrap

augroup TypescriptAutocmds
	autocmd!
	# autocmd BufWrite *.ts :Autoformat
augroup END

import 'findfiles.vim'

def AutofmtCommandHook(bufnr: number): dict<any>
    var cmd = "tsfmt"

    var packageJsonPath = findfiles.FindPackageJson()
    echo "packageJsonPath: " .. packageJsonPath
    if packageJsonPath != ""
        var cmdPath = fnamemodify(packageJsonPath, ":h") .. "/node_modules/.bin/tsfmt"
        if executable(cmdPath)
            cmd = cmdPath
        endif
    endif

    var cmdParts = [
        cmd,
        "--stdin",
    ]

    # var tsFmtJsonPath = expand("%:p:h") .. "/tsfmt.json"
    # if filereadable(tsFmtJsonPath)
    #     add(cmdParts, "--useTsfmt")
    #     add(cmdParts, tsFmtJsonPath)
    # endif

    var workingDir = getcwd()
    if filereadable(packageJsonPath)
        workingDir = fnamemodify(packageJsonPath, ":p:h")
    endif

    return {
        "command": join(cmdParts, " "),
        "options": {
            "cwd": workingDir,
        }
    }
enddef
b:autofmt_command_hook = function('AutofmtCommandHook')
