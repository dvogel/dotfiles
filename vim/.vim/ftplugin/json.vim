setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=0
setlocal smarttab
setlocal expandtab
setlocal nosmartindent

function! LintJSON()
  let output = system("python -m json.tool " . expand("%"))
  if output =~ "^Expecting : "
    echoerr output
  end
endfunction

autocmd! BufWritePost *.json call LintJSON()

com! FormatJSON %!python -m json.tool
map <leader>jf <Esc>:FormatJSON<CR>

com! PPJSON %!json_pp
map <leader>jpp <Esc>:PPJSON<CR>

function! AutofmtCommandHook(bufnr) abort
    return {
                \ "command": "jq -r .",
                \ "options": {},
                \ }
endfunction

let b:autofmt_command_hook = function('AutofmtCommandHook')
