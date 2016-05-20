setlocal ruler
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal nowrap

function! ConvertRubySymbolToString()
  let save_cursor = getpos(".")
  let cword = expand('<cword>')
  let regex = "s/:\\(" . cword . "\\)/'\\1'/g"
  call setpos('.', [save_cursor[0], save_cursor[1], 0, save_cursor[3]])
  if search(":" . cword, 'n', line('.')) > 0
    execute regex
  endif
  call setpos('.', save_cursor)
endfunction

nmap <Leader>sts :call ConvertRubySymbolToString()<CR>
nmap <F8> :call ToggleLine("binding.pry")<CR> 
