setlocal ruler
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal nowrap

function! ConvertRubySymbolToString()
  let save_cursor = getpos(".")
  let cword = expand('<cword>')
  call setpos('.', [save_cursor[0], save_cursor[1], 0, save_cursor[3]])
  if search(":" . cword, 'n', line('.')) > 0
    let regex = "s/:\\(" . cword . "\\)/'\\1'/g"
    execute regex
  elseif search(cword . ":", 'n', line('.')) > 0
    let regex = "s/\\(" . cword . "\\):/'\\1' =>/g"
    execute regex
  endif
  call setpos('.', save_cursor)
endfunction

function! ConvertRubyStringToSymbol()
    let save_cursor = getpos(".")
    let start_line = line(".")
    let cword = expand('<cword>')

    let cmd = "s/['\"]\\(" . cword . "\\)['\"]/:\\1/g"
    execute cmd
    call setpos('.', save_cursor)
endfunction

nmap <Leader>sts :call ConvertRubySymbolToString()<CR>
nmap <Leader>STS :call ConvertRubyStringToSymbol()<CR>
nmap <F8> :call ToggleLine("binding.pry")<CR> 

