vim9script

import 'findfiles.vim'

def AutofmtCommandHook(bufnr: number): dict<any>
    var prettierCmd = "prettier"

    var packageJsonPath = findfiles.FindPackageJson()
    echo "packageJsonPath: " .. packageJsonPath
    if packageJsonPath != ""
        var prettierPath = fnamemodify(packageJsonPath, ":h") .. "/node_modules/.bin/prettier"
        if executable(prettierPath)
            prettierCmd = prettierPath
        endif
    endif

    var prettierCmdParts = [
        prettierCmd,
        "--stdin-filepath " .. expand("%:p"),
        "--tab-width " .. &shiftwidth,
    ]
    if &textwidth
        add(prettierCmdParts, "--print-width " .. &textwidth)
    endif
    
    var cmd = join(prettierCmdParts, " ")
    echomsg cmd
    return {
        "command": cmd,
        "options": {},
    }
enddef
b:autofmt_command_hook = function('AutofmtCommandHook')
